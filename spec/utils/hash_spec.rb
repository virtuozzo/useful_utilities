require 'spec_helper'

describe Utils::Hash do
  context '.sum_values' do
    let(:list) { [] }
    subject    { described_class.sum_values(*list) }

    it 'sum values of identical keys' do
      list << { a: 2, b: 3 }
      list << { a: 5, b: 3.5 }

      expect(subject).to eq(a: 7, b: 6.5)
    end

    it 'check if hash has key before adding to result hash' do
      list << { a: 2, b: 3 }
      list << { b: 4, c: 5 }
      list << { a: 2, c: 7 }

      expect(subject).to eq(a: 4, b: 7, c: 12)
    end
  end

  it '.group_by_keys' do
    first  = { a: 2, b: 3 }
    second = { b: 2, c: 4 }

    expect(described_class.group_by_keys(first, second)).to eq(a: [2], b: [3, 2], c: [4])
  end
end
