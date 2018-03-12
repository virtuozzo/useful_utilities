require 'active_support/all'

module UsefulUtilities
  # Utilities for time

  # @author OnApp Ltd.
  module Time
    extend self

    SECONDS_IN_HOUR = 3_600
    MILLISECONDS_IN_SECOND = 1_000

    # @param time [Time]
    # @return [DateTime] time in UTC
    # @example
    #   time #=> 2013-12-19 14:01:22 +0200
    #
    #   UsefulUtilities::Time.assume_utc(time) #=> 2013-12-19 14:01:22 UTC
    def assume_utc(time)
      time.to_datetime.change(offset: 0)
    end

    # @param time [Time]
    # @return [Time] time rounded to hours
    # @example
    #   time #=> 2014-01-04 14:29:59
    #
    #   UsefulUtilities::Time.round_to_hours(time) #=> 2014-01-04 14:00:00
    def round_to_hours(time)
      (time.min < 30) ? time.beginning_of_hour : time.end_of_hour
    end

    # @param time [Time]
    # @return [Time] beginning of the next hour
    # @example
    #   time #=> 2018-03-07 15:51:58 +0200
    #   UsefulUtilities::Time.beginning_of_next_hour(time) #=> 2018-03-07 16:00:00 +0200
    def beginning_of_next_hour(time)
      time.beginning_of_hour.in(1.hour)
    end

    # @param time [Time]
    # @return [Time] beginning of the next day
    # @example
    #   time #=> 2018-03-07 15:51:58 +0200
    #   UsefulUtilities::Time.beginning_of_next_day(time) #=> 2018-03-08 00:00:00 +0200
    def beginning_of_next_day(time)
      time.beginning_of_day.in(1.day)
    end

    # @param time [Time]
    # @return [Time] beginning of the next month
    # @example
    #   time #=> 2018-03-07 15:51:58 +0200
    #   UsefulUtilities::Time.beginning_of_next_month(time) #=> 2018-04-01 00:00:00 +0300
    def beginning_of_next_month(time)
      time.beginning_of_month.in(1.month)
    end

    # @param from [Time]
    # @param till [Time]
    # Yields local time of the beginning of each hour
    # between from & till
    def each_hour_from(from, till = ::Time.now)
      cursor = from.dup.utc.beginning_of_hour
      end_time = till.dup.utc.beginning_of_hour

      while cursor < end_time
        yield cursor, next_hour = beginning_of_next_hour(cursor)

        cursor = next_hour
      end
    end

    # @param from [Time]
    # @param till [Time]
    # Yields local time of the beginning of each day
    # between from & till
    def each_day_from(from, till = ::Time.now)
      cursor = from.beginning_of_day
      end_time = till.beginning_of_day

      while cursor < end_time
        yield cursor, next_day = beginning_of_next_day(cursor)

        cursor = next_day
      end
    end

    # @param time_string [String] string to parse from
    # @param time_zone [String] timezone
    # @return [DateTime] parsed time in UTC
    #
    # Parse and convert Time to the given time zone. If time zone is
    # not given, Time is assumed to be given in UTC. Returns result in
    # UTC
    #
    # @example
    #   time_string #=> "2018-03-07 15:51:58 +0200"
    #   time_zone   #=> "EET"
    #
    #   UsefulUtilities::Time.to_utc(time_string, time_zone) #=> Wed, 07 Mar 2018 13:51:58 +0000
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

    # @param time [Time]
    # @return [Integer] time in milliseconds
    # @example
    #   time #=> 2018-03-07 15:51:58 +0200
    #   UsefulUtilities::Time.to_milliseconds(time) #=> 1520430718000
    def to_milliseconds(time)
      time.to_time.to_i * MILLISECONDS_IN_SECOND
    end

    # @param end_time [Time] end time
    # @param start_time [Time] start time
    # @return [Integer] difference in hours
    # @example
    #   end_time   #=> 2018-03-07 14:51:58 +0200
    #   start_time #=> 2018-03-07 15:51:58 +0200
    #
    #   UsefulUtilities::Time.diff_in_hours(end_time, start_time) #=> 1
    def diff_in_hours(end_time, start_time)
      ((end_time.to_i - start_time.to_i) / SECONDS_IN_HOUR).abs
    end

    # @param date [Date]
    # @return [Boolean] checks if date is valid
    def valid_date?(date)
      return true if date.acts_like?(:date)
      return false if date.blank?

      # http://stackoverflow.com/a/35502357/717336
      date_hash = Date._parse(date.to_s)
      Date.valid_date?(date_hash[:year].to_i,
                       date_hash[:mon].to_i,
                       date_hash[:mday].to_i)
    end
  end
end
