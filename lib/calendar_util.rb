module CalendarUtil
  ##
  # Given a date range, return which weekdays are included as a array
  # of number [0..6].
  #
  def self.weekday_range(from_date, to_date)
    start_date = Date.strptime(from_date)
    end_date = Date.strptime(to_date)
    days = end_date.mjd - start_date.mjd

    return [] if days < 0
    return *(0..6) if days >= 7

    end_day = end_date.wday
    start_day = start_date.wday
    if end_day >= start_day
      return *(start_day..end_day)
    end
    head = *(0..end_day)
    tail = *(start_day..6)
    return (head+tail).uniq
  end
end
