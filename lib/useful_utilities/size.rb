require 'active_support/core_ext/numeric/bytes'
require_relative 'size/bit'
require_relative 'size/cdn_speed'
require_relative 'size/frequency'
require_relative 'size/byte'
require_relative 'size/percentage'

module UsefulUtilities
  module Size
    include UsefulUtilities::Size::Bit
    include UsefulUtilities::Size::CdnSpeed
    include UsefulUtilities::Size::Frequency
    include UsefulUtilities::Size::Byte
    include UsefulUtilities::Size::Percentage

    extend self
  end
end
