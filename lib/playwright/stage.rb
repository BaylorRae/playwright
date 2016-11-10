module Playwright
  class Stage
    def method_missing(name, *args)
      if @@actors.has_key?(name)
        return @@actors[name]
      end

      super
    end

    def actors
      @@actors.values
    end

    def self.actors(&block)
      @@actors = ActorDSL.find(&block)
    end

    def scenes
      @scenes ||= []
    end

    def add_scene(sender, receiver)
      scenes << Scene.new(sender, receiver)
    end

    def self.prop_collection(name, &block)
      define_method name do
        Props.new(block)
      end
    end

    private

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
