class Event < ActiveRecord::Base
  ##
  # Relationships
  #
  belongs_to :activity

  ##
  # Convert into the JSON the API expects.
  #
  def as_api_json
    {:id => self.id, :activity => self.activity.id,
     :date => self.date_at, :time => self.time_at,
     :spots => self.spots}.to_json
  end
end
