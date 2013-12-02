class Activity < ActiveRecord::Base
  ##
  # Relationships
  #
  has_many :schedules
  has_many :events

  ##
  # Validations
  #
  validates :name, :presence => true
  validates :vendor, :presence => true

  def as_json(options={})
    super(:except => [:created_at, :updated_at])
  end
end
