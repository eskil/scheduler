require 'calendar_util'

class SchedulesController < ApplicationController
  ##
  # GET /schedules/query
  #
  # Query a date or date range and find all available events for all
  # activities or a particular.
  #
  # @param date, query a speficic date (ISO8601)
  # @param from_date, query from this date, (ISO8601)
  # @param to_date, query to this date, (ISO8601)
  # @param activity_id, query a particular activity.
  #
  # Querying either requires looking up scheduled events both by date
  # or recurring. Then we have to look for booked events and subtract
  # the slots to figure out availability.
  #
  # This should do a minimum amount of queries, so you'll see things like
  # caching lists of activity_ids to query them at the end etc.
  #
  def query
    # Query for date or range as best possible
    if params[:date].present?
      date = params[:date]
      from_date = date
      to_date = date
      weekdays = CalendarUtil::weekday_range(date, date)
      scheduled = Schedule.where("date_at = ?", date)
      recurring = Schedule.where_recurring_on_days(weekdays)
      events = Event.all.where("date_at = ?", date)
    else
      from_date = params[:from_date]
      to_date = params[:to_date]
      weekdays = CalendarUtil::weekday_range(from_date, to_date)
      scheduled = Schedule.where("date_at >= ?", from_date).where("date_at <= ?", to_date)
      recurring = Schedule.where_recurring_on_days(weekdays)
      events = Event.all.where("date_at >= ?", from_date)
        .where("date_at <= ?", to_date)
    end

    if params[:activity_id].present?
      scheduled = scheduled.where(:activity_id => params[:activity_id])
      recurring = recurring.where(:activity_id => params[:activity_id])
      events = events.where(:activity_id => params[:activity_id])
    end

    # Get all booked events so we can subtract availability, flip it
    # into a hash by activity/date/time => spots-booked so we can subtract
    # them from the schedule
    events = events.where(:activity_id => scheduled.collect(&:activity_id))
    events_by_date_time = Hash.new {|h,k| h[k] = Hash.new {|h,k| h[k] = Hash.new(0)}}
    events.to_a.each do |event|
      events_by_date_time[event.activity_id][event.date_at][event.time_at] += event.spots
    end

    # Get all results and flip into hashes. While doing that, create
    # a set of activity id so we can return all the schedule activities
    # seperate but read them from the DB in 1 query.
    activity_ids = Set.new
    availabilities = {}
    scheduled.to_a.each do |schedule|
      spots = schedule.spots
      spots -= events_by_date_time[schedule.activity_id][schedule.date_at][schedule.time_at]
      next if spots <= 0

      activity_ids << schedule.activity_id

      availabilities[schedule.date_at] ||= []
      availabilities[schedule.date_at] << {:activity_id => schedule.activity_id,
        :time_at => schedule.time_at, :spots => spots}
    end

    # Now flip the recurring schedules into a hash from weekday to list of schedules
    recurs_on = {}
    recurring.to_a.each do |recur|
      (0..6).each do |day|
        if recur.recurs_on? day
          (recurs_on[day] ||= []) << recur
        end
      end
    end
    # Then travese the set of days, lookup recurrent schedules or each
    # weekday and create an entry in availabilities if there spots available.
    (Date.parse(from_date)..Date.parse(to_date)).each do |date|
      next if !recurs_on.has_key? date.wday
      recurs_on[date.wday].each do |schedule|
        spots = schedule.spots
        spots -= events_by_date_time[schedule.activity_id][date][schedule.time_at]
        next if spots <= 0

        activity_ids << schedule.activity_id

        availabilities[date] ||= []
        availabilities[date] << {:activity_id => schedule.activity_id,
          :time_at => schedule.time_at, :spots => spots}
      end
    end

    # ... phew...

    if activity_ids.empty?
      head :not_found and return
    end

    activities = Activity.where(:id => activity_ids.to_a)

    render :json => {:activities => activities, :availabilities => availabilities}
  end
end
