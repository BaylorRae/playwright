module Playwright
  module DSL
    # Defines an actor in a stage. The block is only evaluated once when the
    # method is called the first time.
    #
    #   class ExampleStage < Playwright::Stage
    #     actors do
    #       actor(:buyer) { User.first! }
    #       actor(:seller) { User.first! }
    #     end
    #
    #     scenes do
    #       scene PurchaseProduct, from: :buyer, to: :seller
    #     end
    #   end
    class SceneDSL
      attr_reader :scenes
      SceneWithActors = Struct.new(:klass, :from, :to)

      def initialize(context) # :nodoc:
        @context = context
        @scenes = []
      end

      def method_missing(name, *args, &block) # :nodoc:
        @context.send(name, args, &block)
      rescue NoMethodError
        super
      end

      def respond_to_missing?(name, include_private) # :nodoc:
        @context.respond_to?(name, include_private)
      end

      def self.find(&block) # :nodoc:
        context = eval('self', block.binding)
        dsl = new(context)
        dsl.instance_eval(&block)
        dsl.scenes
      end

      def scene(klass, options)
        @scenes << SceneWithActors.new(klass, options[:from], options[:to])
      end
    end
  end
end
