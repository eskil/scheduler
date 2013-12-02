require 'calendar_util'

class SchedulesController < ApplicationController
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
