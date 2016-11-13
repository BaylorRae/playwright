require "spec_helper"

module Playwright
  describe Stage do
    before do
      stub_const('BOB', Class.new)
      stub_const('ALICE', Class.new)
      stub_const('Scene1', Scene)
      stub_const('Scene2', Scene)
      stub_const('ExampleStage', Stage)

      ExampleStage.class_eval do
        actors do
          actor(:actor_1) { BOB }
          actor(:actor_2) { ALICE }
        end

        scenes do
          scene :scene1, from: :actor_1, to: :actor_2
          scene :scene2, from: :actor_2, to: :actor_1
        end

        prop_collection :shoes
        prop_collection(:pets) { |p| p.name }
      end
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
          Scene1.new(subject, subject.actor_1, subject.actor_2),
          Scene2.new(subject, subject.actor_2, subject.actor_1)
        ])
      end

      it "creates a method to access the scene" do
        expect(subject.scene1).to eq(Scene1.new(subject, subject.actor_1, subject.actor_2))
      end
    end

    context "prop_collection" do
      it "creates a prop collection" do
        expect(subject.shoes.class).to eq(Props)
      end

      it "assigns a custom query" do
        expect(subject.pets.include_query).to_not be_nil
      end
    end
  end
end
