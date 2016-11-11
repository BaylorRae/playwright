module Playwright
  module DSL
    class SceneDSL
      attr_reader :scenes

      def initialize(context)
        @context = context
        @scenes = []
      end

      def method_missing(name, *args, &block)
        @context.send(name, args, &block)
      end

      def self.find(&block)
        context = eval("self", block.binding)
        dsl = new(context)
        dsl.instance_eval(&block)
        dsl.scenes
      end

      def scene(klass, options)
        @scenes << Struct.new(:klass, :from, :to).new(klass, options[:from], options[:to])
      end
    end
  end
end
