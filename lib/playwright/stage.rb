module Playwright
  class Stage
    def scenes
      @scenes ||= []
    end

    def add_scene(sender, receiver)
      scenes << Scene.new(sender, receiver)
    end

    def self.prop_collection(name, &block)
      define_method name do
        props = Props.new(block)
        props
      end
    end
  end
end
