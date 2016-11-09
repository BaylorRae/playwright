module Playwright
  class Stage
    def scenes
      @scenes ||= []
    end

    def add_scene(from, to)
      scenes << Scene.new(from, to)
    end
  end
end
