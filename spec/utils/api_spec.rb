require 'spec_helper'

describe Utils::Api do
  describe '#convert_limit', type: :helper do
    it 'returns false if value is infinity' do
      expect(convert_limit(Float::INFINITY)).to be false
    end

    it 'returns value if it is not infinity' do
      expect(convert_limit(5)).to eql 5
    end
  end
end
