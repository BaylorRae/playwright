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
      @scenes ||= @@scenes.map do |scene|
        scene.klass.new(send(scene.from), send(scene.to))
      end
    end

    def current_scene
      @current_scene ||= scenes.first
    end

    def next_scene
      next_index = scenes.index(current_scene) + 1
      return if next_index > scenes.length - 1
      @current_scene = scenes[next_index]
    end

    def self.scenes(&block)
      @@scenes = SceneDSL.find(&block)
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
