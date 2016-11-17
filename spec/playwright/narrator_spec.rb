require "spec_helper"
require 'pry'

module Playwright
  describe Narrator do
    let(:stage) { double(:stage) }

    before do
      stub_const('BOB', double(:bob))
      stub_const('ALICE', double(:alice))

      stub_const('TestStage', Stage)
      stub_const('ChildStage', TestStage)

      class TestStage < Stage; end
      class ChildStage < TestStage; end

      @narrator = Narrator.find_or_create(TestStage)
    end

    let(:subject) { @narrator }

    context "find_or_create" do
      it "assigns the narrator to the class" do
        expect(TestStage.narrators).to eq([subject])
      end

      it "uses an existing narrator on multiple calls" do
        5.times { Narrator.find_or_create(TestStage) }
        expect(TestStage.narrators).to eq([subject])
      end

      it "creates a new copy for child classes" do
        Narrator.find_or_create(ChildStage)
        expect(ChildStage.narrators).to_not eq(TestStage.narrators)
      end
    end

    context "add_actors" do
      before do
        subject.add_actors do
          actor(:bob) { BOB }
          actor(:alice) { ALICE }
        end
      end

      it "adds actors from the dsl" do
        expect(subject.actors).to eq({
          "bob" => BOB,
          "alice" => ALICE
        })
      end

      it "memoizes the actor getter" do
        expect(BOB).to_not receive(:call)
        expect(ALICE).to_not receive(:call)
        5.times { subject.actors }
      end
    end

    context "has_actor?" do
      it "returns true if actor is registered" do
        allow(subject).to receive(:actors).and_return({
          bob: BOB
        })
        expect(subject.has_actor?(:bob)).to be_truthy
      end

      it "returns false if actor is not registered" do
        allow(subject).to receive(:actors).and_return({})
        expect(subject.has_actor?(:bob)).to be_falsey
      end
    end

    context "get_actor" do
      it "finds an existing actor" do
        allow(subject).to receive(:actors).and_return({ bob: BOB })
        expect(subject.get_actor(:bob)).to eq(BOB)
      end

      it "raises an error if the actor doesn't exist" do
        allow(subject).to receive(:has_actor?).with(:bob) { false }
        expect do
          subject.get_actor(:bob)
        end.to raise_error(ActorNotRegistered)
      end
    end

    context "add_scenes" do
      before do
        stub_const('Scene1', Scene)
        class Scene1 < Scene; end

        allow(subject).to receive(:actors).and_return({
          bob: BOB,
          alice: ALICE
        })

        subject.add_scenes do
          scene :scene1, from: :bob, to: :alice
        end
      end

      it "adds scenes from dsl" do
        expect(subject.scenes(stage)).to eq({
          "scene1" => Scene1.new(stage, BOB, ALICE)
        })
      end

      it "memoizes the scenes" do
        5.times { subject.scenes(stage) }
      end
    end

    context "has_scene?" do
      it "returns true if scene is registered" do
        allow(subject).to receive(:scenes).and_return({
          scene1: double
        })
        expect(subject.has_scene?(stage, :scene1)).to be_truthy
      end

      it "returns false if scene is not registered" do
        allow(subject).to receive(:scenes).and_return({})
        expect(subject.has_scene?(stage, :scene1)).to be_falsey
      end
    end

    context "get_scene" do
      before do
        stub_const('Scene1', Scene)
        class Scene1 < Scene; end
      end

      it "finds a scene by name" do
        allow(subject).to receive(:scenes).and_return({
          scene1: Scene1.new(stage, BOB, ALICE)
        })
        expect(subject.get_scene(stage, :scene1)).to eq(Scene1.new(stage, BOB, ALICE))
      end

      it "raises an error if the scene doesn't exist" do
        allow(subject).to receive(:has_scene?).with(stage, :scene1) { false }
        expect do
          subject.get_scene(stage, :scene1)
        end.to raise_error(SceneNotRegistered)
      end
    end
  end
end
