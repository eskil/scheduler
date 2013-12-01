##
# A schedule is either on a date or recurring on certain weekdays.
#
# A schedule has a time of day it occurs which is time-zone agnostic,
# so it's specified as seconds past midnight.
#

class Schedule < ActiveRecord::Base
  ##
  # Constants
  #
  # This is incidentally equal to Date::DAYNAMES.collect{|d| d.downcase.slice(0, 3)}
  # but should never change since it's part of the API specification.
  #
  DAYS = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat']

  ##
  # Relationships
  #
  belongs_to :activity

  ##
  # Validations
  #
  validates :activity, :presence => true
  validates_presence_of :date_at, :unless => :recurring
  validates :time_at, :presence => true
  validates :spots, :presence => true

  ##
  # Scopes
  #
  scope :where_recurring_on_days, lambda {|days|
    return if days.blank?
    conditions = []
    if days.is_a? String
      # You can query using "mon, tue", mostly for console purposes.
      # But take care to not cause SQL injection in this case.
      days.split(',').each{|s| s.strip!}.each do |day|
        if DAYS.include? day
          conditions << "on_#{day} = 't'"
        end
      end
    else
      days.each do |day|
        if day >= 0 && day <= 6
          conditions << "on_#{DAYS[day]} = 't'"
        end
      end
    end
    where(:recurring => true).where(conditions.join(" OR "))
  }


  def time_at_local
    Time.at(time_at).utc
  end
end

