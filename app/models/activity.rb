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
    options.merge!(:except => [:created_at, :updated_at])
    super(options)
  end
end
