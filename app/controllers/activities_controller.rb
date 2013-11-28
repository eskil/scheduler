class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
    respond_to do |format|
      format.json {
        render :json => {}
      }
      format.html {
        render
      }
    end
  end

  def show
    @activity = Activity.find(params[:id])

    respond_to do |format|
      format.json {
        render :json => @activity.to_json
      }
      format.html { render }
    end
  end

  def create
    @activity = Activity.create(:name => params[:name], :vendor => params[:vendor])

    respond_to do |format|
      format.json {
        render :json => @activity.to_json(:only => [:id])
      }
      format.html {
        render :action => :show
      }
    end
  end
end
