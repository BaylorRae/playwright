require "spec_helper"

module Playwright
  describe Stage do
    before do
      stub_const('BOB', double(:bob))
      stub_const('ALICE', double(:alice))
      stub_const('Scene1', Scene)
      stub_const('Scene2', Scene)
      stub_const('ExampleStage', Stage)

      class Scene1 < Scene; end
      class Scene2 < Scene; end

      class ExampleStage < Stage
        actors do
          actor(:actor_1) { BOB }
          actor(:actor_2) { ALICE }
        end

        scenes do
          scene :scene1, from: :actor_1, to: :actor_2
          scene Scene2, from: :actor_2, to: :actor_1
        end

        prop_collection :shoes
        prop_collection(:pets) { |p| p.name }
      end
    end

    after do
      ExampleStage.narrators.clear
    end

    subject { ExampleStage.new }

    context "actors" do
      it "returns available actors" do
        expect(subject.actors).to eq({
          "actor_1" => BOB,
          "actor_2" => ALICE
        })
      end

      it "adds an accessor for the actor" do
        expect(subject.actor_1).to eq(BOB)
      end
    end

    context "scenes" do
      it "has a collection of scenes" do
        expect(subject.scenes).to eq({
          "scene1" => Scene1.new(subject, BOB, ALICE),
          "scene2" => Scene2.new(subject, ALICE, BOB)
        })
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

    context "method_missing" do
      it "raises an exception if no actors or scenes are found" do
        expect do
          subject.foobar
        end.to raise_error(NoMethodError)
      end
    end
  end
end
