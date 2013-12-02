class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
    respond_to do |format|
      format.html {
        render
      }
    end
  end

  def show
    @activity = Activity.find(params[:id])

    respond_to do |format|
      format.html { render }
    end
  end

  def create
    @activity = Activity.create(:name => params[:name], :vendor => params[:vendor])

    respond_to do |format|
      format.json {
        render :json => @activity, :status => :created
      }
    end
  end

  ##
  # POST /activity/:id/book
  #
  # @params date, the date to book for in ISO8601
  # @params time, the time to book for in "HH:MM" format
  # @params spots, the number of spots to book
  #
  def book
    # This will 404 if the activity is not found
    @activity = Activity.find(params[:id])

    # Ensure the date/time exists
    date_at = Date.parse(params[:date])
    time_at = Time.parse(params[:time]).seconds_since_midnight
    @schedule = Schedule.where(:activity_id => @activity.id,
                               :date_at => date_at, :time_at => time_at).first
    if @schedule.nil?
      @schedule = Schedule.where_recurring_on_days([date_at.wday])
        .where(:time_at => time_at).first
      if @schedule.nil?
        render :json => {}, :status => :forbidden and return
      end
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
