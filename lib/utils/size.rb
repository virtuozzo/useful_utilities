require 'active_support/core_ext/numeric/bytes'
require 'utils/size/bit'
require 'utils/size/cdn_byte'
require 'utils/size/frequency'
require 'utils/size/byte'
require 'utils/size/percentage'

module Utils
  module Size
    extend self
    extend Utils::Size::Bit
    extend Utils::Size::CdnByte
    extend Utils::Size::Frequency
    extend Utils::Size::Byte
    extend Utils::Size::Percentage
  end
end
