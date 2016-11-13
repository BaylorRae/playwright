require "spec_helper"
require "playwright/dsl/scene_dsl"

module Playwright
  module DSL
    describe SceneDSL do
      let(:sender) { double(:sender) }
      let(:receiver) { double(:receiver) }

      before do
        stub_const('ExampleScene', Class.new)
      end

      context "scene" do
        it "adds scene with actors" do
          subject.scene(ExampleScene, from: sender, to: receiver)
          expect(subject.scenes).to eq({
            "example_scene" => SceneDSL::SceneWithActors.new(ExampleScene, sender, receiver)
          })
        end

        it "adds scene from string" do
          subject.scene("example_scene", from: sender, to: receiver)
          expect(subject.scenes).to eq({
            "example_scene" => SceneDSL::SceneWithActors.new(ExampleScene, sender, receiver)
          })
        end

        it "adds scene from symbol" do
          subject.scene(:example_scene, from: sender, to: receiver)
          expect(subject.scenes).to eq({
            example_scene: SceneDSL::SceneWithActors.new(ExampleScene, sender, receiver)
          })
        end
      end
    end
  end
end
