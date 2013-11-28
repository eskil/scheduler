require 'calendar_util'

class SchedulesController < ApplicationController

  def create
    @activity = Activity.find(params[:activity_id])
    @schedule = Schedule.new(:activity => @activity)
    if params[:recurring]
      @schedule.recurring = true
      days = params[:recurring].split(',').each{|s| s.strip!}.each do |day|
        if Schedule::DAYS.include? day
          @schedule.send("on_#{day}=", true)
        end
      end
    else
      @schedule.date_at = Date.parse(params[:date])
    end

    @schedule.time_at = Time.parse(params[:time]).seconds_since_midnight
    @schedule.slots = params[:slots]
    @schedule.save!

    respond_to do |format|
      format.json {
        render :json => {}
      }
    end
  end

  def query
    if params[:date].present?
      from_date = params[:date]
      to_date = params[:date]
    else
      from_date = params[:from_date]
      to_date = params[:to_date]
    end
    scheduled = Schedule.where("date_at >= ?", from_date).where("date_at <= ?", to_date)
    weekdays = CalendarUtil::weekday_range(from_date, to_date)
    recurring = Schedule.where_recurring_on_days(weekdays)

    respond_to do |format|
      format.json {
        render :json => {:scheduled => scheduled.to_json, :recurring => recurring.to_json}
      }
    end

  end
end
