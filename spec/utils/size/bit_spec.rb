require 'spec_helper'

describe Utils::Size::Bit do
  include described_class

  context '.to_terabits' do
    specify { expect(to_terabits(1000**4, :bit)).to  eq 1.0 }
    specify { expect(to_terabits(1000**3, :kbit)).to eq 1.0 }
    specify { expect(to_terabits(1000**2, :Mbit)).to eq 1.0 }
    specify { expect(to_terabits(1000,    :Gbit)).to eq 1.0 }
    specify { expect(to_terabits(1,       :Tbit)).to eq 1.0 }
    specify { expect { to_terabits(4, :KB) }.to raise_error(ArgumentError) }
  end

  context '.to_gigabits' do
    specify { expect(to_gigabits(1000**3,  :bit)).to  eq 1.0 }
    specify { expect(to_gigabits(1000**2,  :kbit)).to eq 1.0 }
    specify { expect(to_gigabits(1000,     :Mbit)).to eq 1.0 }
    specify { expect(to_gigabits(1   ,     :Gbit)).to eq 1.0 }
    specify { expect(to_gigabits(1.0/1000, :Tbit)).to eq 1.0 }
    specify { expect { to_gigabits(4, :KB) }.to raise_error(ArgumentError) }
  end

  context '.to_megabits' do
    specify { expect(to_megabits(1000**2,     :bit)).to  eq 1.0 }
    specify { expect(to_megabits(1000,        :kbit)).to eq 1.0 }
    specify { expect(to_megabits(1,           :Mbit)).to eq 1.0 }
    specify { expect(to_megabits(1.0/1000,    :Gbit)).to eq 1.0 }
    specify { expect(to_megabits(1.0/1000**2, :Tbit)).to eq 1.0 }
    specify { expect { to_megabits(4, :KB) }.to raise_error(ArgumentError) }
  end

  context '.to_kilobits' do
    specify { expect(to_kilobits(1000,        :bit)).to  eq 1.0 }
    specify { expect(to_kilobits(1,           :kbit)).to eq 1.0 }
    specify { expect(to_kilobits(1.0/1000,    :Mbit)).to eq 1.0 }
    specify { expect(to_kilobits(1.0/1000**2, :Gbit)).to eq 1.0 }
    specify { expect(to_kilobits(1.0/1000**3, :Tbit)).to eq 1.0 }
    specify { expect { to_kilobits(4, :KB) }.to raise_error(ArgumentError) }
  end

  context '.to_bits' do
    specify { expect(to_bits(1,           :bit)).to  eq 1.0 }
    specify { expect(to_bits(1.0/1000,    :kbit)).to eq 1.0 }
    specify { expect(to_bits(1.0/1000**2, :Mbit)).to eq 1.0 }
    specify { expect(to_bits(1.0/1000**3, :Gbit)).to eq 1.0 }
    specify { expect(to_bits(1.0/1000**4, :Tbit)).to eq 1.0 }
    specify { expect { to_bits(4, :GB) }.to raise_error(ArgumentError) }
  end

  context '.bits_to_human_size' do
    specify { expect(bits_to_human_size(1       + 0.001, :bit)).to  eq 1.001 }
    specify { expect(bits_to_human_size(1000    + 1,     :kbit)).to eq 1.001 }
    specify { expect(bits_to_human_size(1000**2 + 10**3, :Mbit)).to eq 1.001 }
    specify { expect(bits_to_human_size(1000**3 + 10**6, :Gbit)).to eq 1.001 }
    specify { expect(bits_to_human_size(1000**4 + 10**9, :Tbit)).to eq 1.001 }
  end

  context 'suitable_unit_for_bits' do
    specify { expect(suitable_unit_for_bits(100)).to              eq :bit  }
    specify { expect(suitable_unit_for_bits(1000)).to             eq :kbit  }
    specify { expect(suitable_unit_for_bits(1000000)).to          eq :Mbit  }
    specify { expect(suitable_unit_for_bits(1000000000)).to       eq :Gbit  }
    specify { expect(suitable_unit_for_bits(1000000000000)).to    eq :Tbit  }
    specify { expect(suitable_unit_for_bits(1000000000000000)).to eq :Tbit  }
    specify { expect { suitable_unit_for_bits(-1) }.to  raise_error(ArgumentError) }
    specify { expect { suitable_unit_for_bits(1.0) }.to raise_error(ArgumentError) }
  end

  context 'bits_per_sec_to_human_readable' do
    specify { expect(bits_per_sec_to_human_readable(1000)).to eq '1.0 kbit/s' }
  end
end
