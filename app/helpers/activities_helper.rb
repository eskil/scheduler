module ActivitiesHelper
  def recurs(schedule)
    return '' if !schedule.is_recurring?
    result = []
    Schedule::DAYS.each do |day|
      if schedule.send("on_#{day}")
        result << day
      end
    end
    result.join(' ')
  end
end
