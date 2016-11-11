module Playwright
  module DSL
    class SceneDSL
      attr_reader :scenes
      SceneWithActors = Struct.new(:klass, :from, :to)

      def initialize(context)
        @context = context
        @scenes = []
      end

      def method_missing(name, *args, &block)
        @context.send(name, args, &block)
      rescue NoMethodError
        super
      end

      def respond_to_missing?(name, include_private)
        @context.respond_to?(name, include_private)
      end

      def self.find(&block)
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
