require 'playwright/dsl/actor_dsl'
require 'playwright/dsl/scene_dsl'
require 'playwright/extensions'

module Playwright
  class Narrator
    include DSL

    attr_reader :owner_class

    def self.find_or_create(owner_class)
      # get narrator from existing class
      if owner_class.respond_to?(:narrators) && narrator = owner_class.narrators.first

        # child classes should have their own narrator
        if narrator.owner_class != owner_class
          narrator = narrator.dup
          narrator.owner_class = owner_class
        end
      else
        narrator = new(owner_class)
      end

      return narrator
    end

    def initialize(owner_class) # :nodoc:
      self.owner_class = owner_class
      @actors = {}
    end

    def owner_class=(owner_class) # :nodoc:
      @owner_class = owner_class
      owner_class.class_eval do
        extend ClassMethods
      end

      owner_class.narrators << self
    end

    def add_actors(&block) # :nodoc:
      @actors = ActorDSL.find(&block)
    end

    def add_scenes(&block) # :nodoc
      @scenes = SceneDSL.find(&block)
    end

    def actors
      return @loaded_actors if @loaded_actors
      @loaded_actors = @actors.each do |key, value|
        @actors[key] = value.call
      end
    end

    def has_actor?(name)
      actors.has_key?(name)
    end

    def get_actor(name)
      raise ActorNotRegistered unless has_actor?(name)
      actors[name]
    end

    def scenes(stage)
      return @loaded_scenes if @loaded_scenes
      @loaded_scenes = @scenes.each do |key, value|
        @scenes[key] = value.init(self, stage)
      end
    end

    def has_scene?(stage, name)
      scenes(stage).has_key?(name)
    end

    def get_scene(stage, name)
      raise SceneNotRegistered unless has_scene?(stage, name)
      scenes(stage)[name]
    end
  end
end
