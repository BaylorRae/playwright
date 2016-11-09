require "spec_helper"

module Playwright
  describe Stage do

    class ExampleStage < Stage
      prop_collection :shoes
      prop_collection :pets, proc { |a, b| a.name == b.name }
    end

    subject { ExampleStage.new }

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
        expect(subject.pets.include_query).to_not be_nil
      end
    end

  end
end
