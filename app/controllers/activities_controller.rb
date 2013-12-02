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
end
