require 'spec_helper'
require 'timecop'

describe Utils::Time do
  describe '.assume_utc' do
    let(:time) { ::Time.new(2007, 11, 1, 15, 25, 0, '+09:00') }
    let(:utced_time) { described_class.assume_utc(time) }

    specify { expect(time).not_to be_utc }
    specify { expect(time.ctime).to eq utced_time.ctime }
    specify { expect(utced_time).to be_utc }
  end

  describe '.beginning_of_next_hour' do
    subject { described_class.beginning_of_next_hour(::Time.new(2014, 1, 22, 19, 55)) }

    it { is_expected.to eq ::Time.new(2014, 1, 22, 20, 00, 0) }
  end

  describe '.beginning_of_next_day' do
    let(:late_hour) { described_class.beginning_of_next_day(::Time.new(2014, 1, 22, 23, 55)) }
    let(:early_hour) { described_class.beginning_of_next_day(::Time.new(2014, 1, 22, 00, 55)) }
    let(:next_day_midnight) { ::Time.new(2014, 1, 23, 00, 00, 00) }

    specify { expect(late_hour).to eq next_day_midnight }
    specify { expect(early_hour).to eq next_day_midnight }
  end

  describe '.beginning_of_next_month' do
    subject { described_class.beginning_of_next_month(::Time.new(2014, 1, 22, 19, 55)) }

    it { is_expected.to eq ::Time.new(2014, 2, 1) }
  end

  describe '.each_hour_from' do
    delegate :each_hour_from, to: :described_class

    context 'without `till` argument' do
      around { |example| ::Timecop.freeze(build_time(18, 29)) { example.run } }

      it 'method yields with beginning of 2 hours' do
        expect { |block| each_hour_from(build_time(16, 23), &block) }.
          to yield_successive_args(
            [build_time(16), build_time(17)],
            [build_time(17), build_time(18)]
          )
      end

      it 'a start date is equal to beginning of a current hour' do
        expect { |block| described_class.each_hour_from(build_time(18, 12), &block) }.not_to yield_control
      end
    end

    context 'with `till` argument' do
      it 'yields with beginning of 3 hours' do
        expect { |block| each_hour_from(build_time(16, 23), build_time(18, 45), &block) }.
          to yield_successive_args(
            [build_time(16), build_time(17)],
            [build_time(17), build_time(18)],
            [build_time(18), build_time(19)]
          )
      end
    end

    def build_time(hours, minutes = 0)
      ::Time.new(2014, 2, 17, hours, minutes)
    end
  end

  describe '.each_day_from' do
    delegate :each_day_from, to: :described_class

    it 'yields with beginning of 3 hours' do
      expect { |block| each_day_from(build_time(16, 23), build_time(18, 01), &block) }.
        to yield_successive_args(
          [build_time(16), build_time(17)],
          [build_time(17), build_time(18)],
          [build_time(18), build_time(19)]
        )
    end

    def build_time(date, hour = 0)
      ::Time.new(2014, 2, date, hour, 0, 0)
    end
  end

  describe '.diff_in_hours' do
    let(:end_date)   { Time.new(2016, 1, 2, 20, 10) }
    let(:start_date) { Time.new(2016, 1, 1, 20, 40) }

    subject          { described_class.diff_in_hours(end_date, start_date) }

    it { is_expected.to eq 23 }

    context 'end_date is older than start_date' do
      subject { described_class.diff_in_hours(start_date, end_date) }

      it 'returns diff as positive number' do
        is_expected.to eq 24
      end
    end
  end
end
