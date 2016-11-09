require "spec_helper"

module Playwright
  describe Stage do
    it "has a collection of scenes" do
      expect(subject.scenes).to eq([])
    end

    it "adds a scene" do
      subject.add_scene("from-user", "to-user")

      expect(subject.scenes).to eq([
        Scene.new("from-user", "to-user")
      ])
    end
  end
end

