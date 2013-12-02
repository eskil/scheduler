require 'calendar_util'

class SchedulesController < ApplicationController

  ##
  # POST /schedules
  # @param activity_id, id of activity
  # @param recurring, list of space seperated days on which event recurs, eg. "mon tue"
  # @param date, ISO8601 date string
  # @param time, HH:MM of event
  # @param spots, number of spots available
  #
  # Does not handle overwriting existing schedules.
  #
  def create
    @activity = Activity.find(params[:activity_id])
    @schedule = Schedule.new(:activity => @activity,
                             :price_cents => params[:price], :price_currency => params[:currency])
    if params[:recurring]
      params[:recurring].split(' ').compact.each.each do |day|
        if Schedule::DAYS.include? day
          @schedule.send("on_#{day}=", true)
        end
      end
    else
      @schedule.date_at = Date.parse(params[:date])
    end

    @schedule.time_at = Time.parse(params[:time]).seconds_since_midnight
    @schedule.spots = params[:spots]
    @schedule.save!

    respond_to do |format|
      format.json {
        render :json => @schedule.as_json(:only => [:id]), :status => :created
      }
    end
  end

  def query
    # Query for date or range as best possible
    if params[:date].present?
      date = params[:date]
      scheduled = Schedule.where("date_at = ?", date)
      weekdays = CalendarUtil::weekday_range(date, date)
      events = Event.all.where("date_at = ?", date)
    else
      from_date = params[:from_date]
      to_date = params[:to_date]
      scheduled = Schedule.where("date_at >= ?", from_date)
        .where("date_at <= ?", to_date)
      weekdays = CalendarUtil::weekday_range(from_date, to_date)
      events = Event.scoped.where("date_at >= ?", from_date)
        .where("date_at <= ?", to_date)
    end

    # If there are recurring events on these days,
    recurring = Schedule.where_recurring_on_days(weekdays)
    if recurring.empty?

    else
      events = events.where(:activity => scheduled.collect(&:activity_id))
    end

    respond_to do |format|
      format.json {
        render :json => events
      }
    end

  end
end
