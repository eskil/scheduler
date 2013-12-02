class EventsController < ApplicationController
  def create
    # This will 404 if the activity is not found
    @activity = Activity.find(params[:activity_id])

    # Ensure the date/time exists
    date_at = Date.parse(params[:date]),
    time_at = Time.parse(params[:time]).seconds_since_midnight
    @schedule = Schedule.where(:activity_id => @activity.id,
                               :date_at => date_at, :time_at => time_at).first
    if @schedule.nil?
      render :json => {}, :status => :forbidden and return
    end

    # Check spots available
    spots_wanted = params[:spots].to_i
    spots_available = @schedule.spots
    events = Event.where(:activity => @activity, :date_at => date_at, :time_at => time_at)
    if events.present?
      spots_used = events.collect(&:spots).inject(&:+)
      spots_available -= spots_used
    end
    if spots_available - spots_wanted < 0
      render :json => {:spots => spots_available}, :status => :conflict and return
    end

    @event = Event.create(:activity => @activity,
                          :date_at => date_at.to_s,
                          :time_at => time_at,
                          :spots => spots_wanted)
    render :json => @event, :status => :created
  end
end
