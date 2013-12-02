class Event < ActiveRecord::Base
  ##
  # Relationships
  #
  belongs_to :activity

  def time_at_local
    Time.at(time_at).utc
  end

  def as_json(options={})
    {:id => self.id, :activity => self.activity.as_json,
     :date => self.date_at, :time => self.time_at,
     :spots => self.spots}
  end
end
