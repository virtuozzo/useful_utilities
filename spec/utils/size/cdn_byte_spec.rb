require 'spec_helper'

describe Utils::Size::CdnByte do
  include described_class

  context '.to_cdn_gigabytes' do
    specify { expect(to_cdn_gigabytes(1000**3,   :B)).to  eq 1.0 }
    specify { expect(to_cdn_gigabytes(1000**2,   :KB)).to eq 1.0 }
    specify { expect(to_cdn_gigabytes(1000,      :MB)).to eq 1.0 }
    specify { expect(to_cdn_gigabytes(1   ,      :GB)).to eq 1.0 }
    specify { expect(to_cdn_gigabytes(1.0/1000,  :TB)).to eq 1.0 }
    specify { expect(to_cdn_gigabytes(121248.05, :Mbit)).to eq 15.15600625 }
    specify { expect { to_cdn_gigabytes(4, :KiB) }.to raise_error(ArgumentError) }
  end
end
