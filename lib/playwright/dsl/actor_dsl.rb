module Playwright
  module DSL
    # Defines an actor in a stage. The block is only evaluated once when the
    # method is called the first time.
    #
    #   class ExampleStage < Playwright::Stage
    #     actors do
    #       actor(:actor_name) { User.first! }
    #     end
    #   end
    class ActorDSL
      attr_reader :actors

      def initialize(context) # :nodoc:
        @context = context
        @actors = {}
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
        dsl.actors
      end

      def actor(name, &block)
        @actors[name] = block
      end
    end
  end
end
