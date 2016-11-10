require "spec_helper"

module Playwright
  describe Stage do
    class UserFinder
      def self.bob
        @bob ||= Class.new
      end

      def self.alice
        @alice ||= Class.new
      end
    end

    class ExampleStage < Stage
      actors do
        actor(:actor_1) { UserFinder.bob }
        actor(:actor_2) { UserFinder.alice }
      end

      prop_collection :shoes
      prop_collection(:pets) { |p| p.name }
    end

    subject { ExampleStage.new }

    context "actors" do
      it "returns available actors" do
        expect(subject.actors).to eq([UserFinder.bob, UserFinder.alice])
      end

      it "adds an accessor for the actor" do
        expect(subject.actor_1).to eq(UserFinder.bob)
      end
    end

    context "scenes" do
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
