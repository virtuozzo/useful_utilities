require 'active_support/core_ext/numeric/bytes'
require_relative 'size/bit'
require_relative 'size/cdn_speed'
require_relative 'size/frequency'
require_relative 'size/byte'
require_relative 'size/percentage'

module Utils
  module Size
    include Utils::Size::Bit
    include Utils::Size::CdnSpeed
    include Utils::Size::Frequency
    include Utils::Size::Byte
    include Utils::Size::Percentage
    extend self
  end
end
