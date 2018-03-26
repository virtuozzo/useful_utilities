require 'spec_helper'

describe UsefulUtilities::AR, type: :helper do
  describe '.count' do
    let(:counter) { described_class.count(Count, :i, :summary) }

    it 'returns proper raw sql' do
      expect(counter).to eq 'COUNT(counts.i) AS summary'
    end
  end

  describe '.boolean_to_float' do
    delegate :boolean_to_float, to: :described_class

    it 'returns 1.0 for true' do
      expect(boolean_to_float(true)).to eq 1.0
    end

    it 'returns 0.0 for false' do
      expect(boolean_to_float(false)).to eq 0.0
    end

    it 'returns 0.0 for nil' do
      expect(boolean_to_float(nil)).to eq 0.0
    end
  end

  describe '.deep_validation' do
    let(:record) { Count.new }

    subject      { deep_validation(record); record.errors }

    it { is_expected.to include :i }

    it 'includes self error' do
      record.i = 2

      is_expected.to be_empty
    end

    context 'with nested records' do
      let(:record) { create :count }

      before { create_list :nested_count, 5, count: record }

      it { is_expected.to be_empty }

      it 'includes error messages from nested associations' do
        record.nested_counts.each { |nested| nested.y = nil; nested.save }

        is_expected.to include :nested_counts
        expect(subject[:nested_counts].first).to match(/can't be blank/)
      end
    end

    describe '.by_polymorphic' do
      let(:resources_class) { Count }

      it 'putted scope' do
        result = by_polymorphic(resources_class.all, :target, NestedCount.all).to_sql

        expect(result).to eq(resources_class.where(target_type: 'NestedCount', target_id: NestedCount.all).to_sql)
      end

      it 'putted record' do
        result = by_polymorphic(resources_class.all, :target, create(:nested_count, id: 2)).to_sql

        expect(result).to eq(resources_class.where(target_type: 'NestedCount', target_id: 2).to_sql)
      end

      it 'putted scope of polymorhic records' do
        result = by_polymorphic(resources_class.all, :target, NestedCountChild.all).to_sql

        expect(result).to eq(resources_class.where(target_type: 'NestedCount', target_id: NestedCountChild.all).to_sql)
      end

      it 'putted polymorhic record' do
        result = by_polymorphic(resources_class.all, :target, create(:nested_count_child, id: 3)).to_sql

        expect(result).to eq(resources_class.where(target_type: 'NestedCount', target_id: 3).to_sql)
      end
    end
  end

  describe '.to_polymorphic_type' do
    specify { expect(to_polymorphic_type(Count)).to eq Count }
    specify { expect(to_polymorphic_type(NestedCountChild)).to eq NestedCount }
    specify { expect(to_polymorphic_type(NestedCountChild.new)).to eq NestedCount }
  end

  describe '.[]' do
    specify { expect(helper[NestedCountChild, :id]).to eq 'nested_counts.id' }
    specify { expect(helper[Count.all, :name]).to eq('counts.name') }
  end

  describe '.desc' do
    specify { expect(desc(Count, :id)).to eq('counts.id DESC') }
    specify { expect(desc(NestedCountChild, :id)).to eq('nested_counts.id DESC') }
  end

  it '.sql_sum' do
    expect(sql_sum(Count, :hit, :hits)).to eq('SUM(COALESCE(counts.hit, 0)) AS hits')
  end

  describe '.sum_by_columns' do
    context 'no records' do
      subject(:array_sum) { sum_by_columns(Count, %i(i)) }

      its(:i) { is_expected.to be_zero }
    end

    context 'records exist' do
      let(:expected_i)       { 7 * 3 }

      before { create_list :count, 3, i: 7 }

      it 'works with plain params' do
        sum = sum_by_columns(Count, :i)

        expect(sum[:i]).to eq expected_i
      end

      it 'works with hash params' do
        sum = sum_by_columns(Count, i: :my_i)

        expect(sum[:my_i]).to eq expected_i
      end

      it 'works with hash params in an array' do
        sum = sum_by_columns(Count, [i: :my_i])

        expect(sum[:my_i]).to eq expected_i
      end
    end
  end

  describe '.delete_dependents' do
    let(:count) { create :count }

    specify do
      expect(delete_dependents(count, NestedCount, DeeperNestedCount).gsub(/\s/, '')).
        to eq("DELETE deeper_nested_counts
                 FROM deeper_nested_counts
           INNER JOIN nested_counts
                   ON deeper_nested_counts.nested_count_id = nested_counts.id
                WHERE nested_counts.count_id = #{count.id}".gsub(/\s/, ''))
    end
  end
end
