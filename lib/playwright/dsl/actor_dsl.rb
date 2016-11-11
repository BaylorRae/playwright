module Playwright
  module DSL
    class ActorDSL
      attr_reader :actors

      def initialize(context)
        @context = context
        @actors = {}
      end

      def method_missing(name, *args, &block)
        @context.send(name, args, &block)
      end

      def self.find(&block)
        context = eval("self", block.binding)
        dsl = new(context)
        dsl.instance_eval(&block)
        dsl.actors
      end

      def actor(name, &block)
        @actors[name] = yield
      end
    end
  end
end
