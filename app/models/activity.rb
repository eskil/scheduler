class Activity < ActiveRecord::Base
  ##
  # Relationships
  #
  has_many :schedules

  ##
  # Validations
  #
  validates :name, :presence => true
  validates :vendor, :presence => true

end
