require 'socket'
require 'timeout'

module UsefulUtilities
  # API utilities
  module Api
    extend self

    # @note Exceptions to handle
    # @see #port_open?
    RESCUE_PORT_OPEN_EXCEPTIONS = [
      StandardError,
      SocketError,
      Timeout::Error].freeze

    # @param value [Numeric]
    # @return [FalseClass/Numeric] false if value is infinity or value if not
    def convert_limit(value)
      value == Float::INFINITY ? false : value
    end

    # @param ip [String]
    # @param port [Integer]
    # @option sleep_time [Integer] :sleep_time (1)
    # @option max_attempts [Integer] :max_attempts (3)
    # @return [Boolean] check if a port is open or not on a remote host
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
