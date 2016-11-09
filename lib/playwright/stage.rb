module Playwright
  class Stage
    def scenes
      @scenes ||= []
    end

    def add_scene(sender, receiver)
      scenes << Scene.new(sender, receiver)
    end

    def self.prop_collection(name)
      define_method name do
        Props.new
      end
    end
  end
end
