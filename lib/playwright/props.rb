module Playwright
  # == Playwright::Props
  #
  # Props are a collection of items that are used during the test. They are
  # accessible through the Stage and can be a unique list which is filtered
  # with the +find_or_add+ method. You can specify a lambda to specify how it
  # compares existing items.
  #
  #     first_product = Product.first
  #     products = Playwright::Props.new(Proc.new { |p| p.id })
  #
  #     2.times { products.find_or_add(first_product) }
  #
  #     products #=> [first_product]
  class Props < Array
    attr_accessor :include_query # :nodoc:

    # Creates a new prop collection with an optional lambda to determine if it
    # has already been added from +find_or_add+
    def initialize(include_query = nil)
      @include_query = include_query
    end

    # Finds the first item in the array or adds it to the end.
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
