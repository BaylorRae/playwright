module Playwright
  class Stage
    def scenes
      @scenes ||= []
    end

    def add_scene(sender, receiver)
      scenes << Scene.new(sender, receiver)
    end
  end
end
