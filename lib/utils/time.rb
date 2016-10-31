require 'active_support/all'

module Utils
  module Time
    extend self

    SECONDS_IN_HOUR = 3_600
    MILLISECONDS_IN_SECOND = 1_000

    # Whatever time is passed it will return it without any GMT offset and the passed time will be in UTC
    # t = Time.now              #=> 2013-12-19 14:01:22 +0200
    # Utils::Time.assume_utc(t) #=> 2013-12-19 14:01:22 UTC
    def assume_utc(time)
      time.to_datetime.change(offset: 0)
    end

    # Examples of usage:
    # 2014-01-04 14:29:59 #=> 2014-01-04 14:00:00
    # 2014-01-04 14:30:00 #=> 2014-01-04 15:00:00
    def round_to_hours(time)
      (time.min < 30) ? time.beginning_of_hour : time.end_of_hour
    end

    def beginning_of_next_hour(time)
      time.beginning_of_hour.in(1.hour)
    end

    def beginning_of_next_day(time)
      time.beginning_of_day.in(1.day)
    end

    def beginning_of_next_month(time)
      time.beginning_of_month.in(1.month)
    end

    # yields local time of the beginning of each hour
    # between start time & current time
    def each_hour_from(from, till = nil)
      cursor = from.beginning_of_hour
      till ||= ::Time.now.beginning_of_hour

      while cursor < till
        yield cursor, next_hour = beginning_of_next_hour(cursor)

        cursor = next_hour
      end
    end

    def each_day_from(from, till = nil)
      cursor = from.beginning_of_day
      till ||= ::Time.now.beginning_of_day

      while cursor < till
        yield cursor, next_day = beginning_of_next_day(cursor)

        cursor = next_day
      end
    end

    # Parse and convert Time to the given time zone. If time zone is
    # not given, Time is assumed to be given in UTC. Returns result in
    # UTC
    def to_utc(time_string, time_zone)
      time = ::DateTime.parse(time_string) # Wed, 22 Aug 2012 13:34:18 +0000
    rescue
      nil
    else
      if time_zone.present?
        current_user_offset = ::Time.now.in_time_zone(::Time.find_zone(time_zone)).strftime("%z") # "+0300"
        time = time.change(:offset => current_user_offset) # Wed, 22 Aug 2012 13:34:18 +0300
        time.utc # Wed, 22 Aug 2012 10:34:18 +0000
      else
        time
      end
    end

    def to_milliseconds(time)
      time.to_time.to_i * MILLISECONDS_IN_SECOND
    end

    # takes two objects: Time
    def diff_in_hours(end_time, start_time)
      ((end_time.to_i - start_time.to_i) / SECONDS_IN_HOUR).abs
    end
  end
end
