require 'playwright/dsl/actor_dsl'
require 'playwright/dsl/scene_dsl'

module Playwright
  class Stage
    include DSL

    def method_missing(name, *args)
      return @@actors[name].call if @@actors.key?(name)
      super
    end

    def respond_to_missing?(name, _)
      @@actors.key?(name)
    end

    def actors
      @actors ||= @@actors.values.map(&:call)
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
  end
end
