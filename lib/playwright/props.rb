module Playwright
  class Props < Array
    attr_accessor :include_query

    def initialize(include_query = nil)
      @include_query = include_query
    end

    def find_or_add_by(item)
      self << item unless include?(item) || include_from_query?(item)
      item
    end

    private

    def include_from_query?(item)
      include_query && self.any? { |v| include_query.call(v) == include_query.call(item) }
    end
  end
end
