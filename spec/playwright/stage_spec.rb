require "spec_helper"

module Playwright
  describe Stage do
    BOB = Class.new
    ALICE = Class.new

    class Scene1 < Playwright::Scene; end
    class Scene2 < Playwright::Scene; end

    class ExampleStage < Stage
      actors do
        actor(:actor_1) { BOB }
        actor(:actor_2) { ALICE }
      end

      scenes do
        scene Scene1, from: :actor_1, to: :actor_2
        scene Scene2, from: :actor_2, to: :actor_1
      end

      prop_collection :shoes
      prop_collection(:pets) { |p| p.name }
    end

    subject { ExampleStage.new }

    context "actors" do
      it "returns available actors" do
        expect(subject.actors).to eq([BOB, ALICE])
      end

      it "adds an accessor for the actor" do
        expect(subject.actor_1).to eq(BOB)
      end
    end

    context "scenes" do
      it "has a collection of scenes" do
        expect(subject.scenes).to eq([
          Scene1.new(subject.actor_1, subject.actor_2),
          Scene2.new(subject.actor_2, subject.actor_1)
        ])
      end
    end

    context "current_scene" do
      it "gets the current scene" do
        expect(subject.current_scene).to eq(Scene1.new(subject.actor_1, subject.actor_2))
      end
    end

    context "next_scene" do
      it "changes to the next scene" do
        subject.next_scene
        expect(subject.current_scene).to eq(Scene2.new(subject.actor_2, subject.actor_1))
      end

      it "doesn't change past the last scene" do
        2.times { subject.next_scene }
        expect(subject.current_scene).to eq(Scene2.new(subject.actor_2, subject.actor_1))
      end
    end

    context "prop_collection" do
      it "creates a prop collection" do
        expect(subject.shoes.class).to eq(Props)
      end

      it "assigns a custom query" do
        pet = double(:pet, name: "pet-1")
        expect(subject.pets.include_query.call(pet)).to eq('pet-1')
      end
    end

  end
end
