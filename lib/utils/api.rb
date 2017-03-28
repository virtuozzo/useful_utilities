require 'socket'
require 'timeout'

module Utils
  module Api
    extend self

    RESCUE_PORT_OPEN_EXCEPTIONS = [Errno::ENETUNREACH, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError, Timeout::Error].freeze

    def convert_limit(value)
      value == Float::INFINITY ? false : value
    end

    # checks if a port is open or not on a remote host
    def port_open?(ip, port, sleep_time: 1, max_attempts: 3)
      try_to(max_attempts: max_attempts, sleep_time: sleep_time, rescue_what: RESCUE_PORT_OPEN_EXCEPTIONS) do
        Timeout::timeout(sleep_time) do
          TCPSocket.new(ip, port).close
          true
        end
      end
    rescue *RESCUE_PORT_OPEN_EXCEPTIONS
      false
    end
  end
end
