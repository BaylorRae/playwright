module Playwright
    module ClassMethods # :nodoc:
      def self.extended(base)
        base.class_eval do
          @narrators = []
        end
      end

      def narrators
        @narrators ||= superclass.narrators.dup
      end
    end
end
