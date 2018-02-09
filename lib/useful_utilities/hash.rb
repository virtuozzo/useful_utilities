module UsefulUtilities
  module Hash
    extend self

    def sum_values(*list)
      collect_keys(*list).inject({}) do |result, key|
        result[key] = 0
        list.each { |item| result[key] += item[key] if item.has_key?(key) }

        result
      end
    end

    def group_by_keys(*list)
      collect_keys(*list).inject({}) do |result, key|
        result[key] = []
        list.each { |item| result[key] << item[key] if item.has_key?(key) }

        result
      end
    end

    private

    def collect_keys(*list)
      list.inject([]) { |result, item| result |= item.keys }
    end
  end
end
