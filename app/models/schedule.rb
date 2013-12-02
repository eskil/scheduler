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
  validates_presence_of :date_at, :unless => :is_recurring?
  validates :time_at, :presence => true
  validates :spots, :presence => true


  composed_of :price,
        :class_name => "Money",
        :mapping => [%w(price_cents cents), %w(price_currency currency_as_string)],
        :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency || Money.default_currency) },
        :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }

  ##
  # Scopes
  #
  scope :where_recurring_on_days, lambda {|days|
    # This scope allows for querying for recurring events using either a list of weekdays
    # or (for console use) list of space-seperated weekdays by name.
    # Eg.
    #   where_recurring_on_days([0, 1, 2])
    # or
    #   where_recurring_on_days("sun mon tue")
    return if days.blank?
    conditions = []
    if days.is_a? String
      # You can query using "mon tue", mostly for console purposes.
      # But take care to not cause SQL injection in this case.
      # Also make sure to query using '1' for truth to be compatible
      # with assorted SQL implementations.
      days.split(' ').compact.each do |day|
        if DAYS.include? day
          conditions << "on_#{day} = '1'"
        end
      end
    else
      days.each do |day|
        if day >= 0 && day <= 6
          conditions << "on_#{DAYS[day]} = '1'"
        end
      end
    end
    where(conditions.join(" OR "))
  }

  def time_at_local
    Time.at(time_at).utc
  end

  # Test if a schedule is a recurring schedule or dated
  def is_recurring?
    on_sun || on_mon || on_tue || on_wed || on_thu || on_fri || on_sat
  end

  # Test if a recurring schedule recurs on a specific weekday
  def recurs_on?(wday)
    return (wday == 0 && on_sun) || (wday == 1  && on_mon) ||
      (wday == 2 && on_tue) || (wday == 3 && on_wed) ||
      (wday == 4 && on_thu) || (wday == 5 && on_fri) ||
      (wday == 6 && on_sat)
  end
end

