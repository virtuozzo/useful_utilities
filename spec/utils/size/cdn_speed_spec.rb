require 'spec_helper'

describe Utils::Size::CdnSpeed do
  include described_class

  context '.to_cdn_gbps' do
    specify { expect(to_cdn_gbps(1000**3*8,  :bit)).to  eq 1.0 }
    specify { expect(to_cdn_gbps(1000**2*8,  :kbit)).to eq 1.0 }
    specify { expect(to_cdn_gbps(1000*8,     :Mbit)).to eq 1.0 }
    specify { expect(to_cdn_gbps(121248.05,  :Mbit)).to eq 15.15600625 }
    specify { expect(to_cdn_gbps(1*8   ,     :Gbit)).to eq 1.0 }
    specify { expect(to_cdn_gbps(1.0/1000*8, :Tbit)).to eq 1.0 }
    specify { expect { to_cdn_gbps(4, :KiB) }.to raise_error(ArgumentError) }
  end
end
