module Playwright
  class Props < Array
    attr_accessor :include_query

    def initialize(include_query = nil)
      @include_query = include_query
    end

    def find_or_add(item)
      self << item unless include?(item) || include_from_query?(item)
      item
    end

    private

    def include_from_query?(item)
      return if include_query.nil?
      item_value = include_query.call(item)
      any? { |v| include_query.call(v) == item_value }
    end
  end
end
