require "spec_helper"

module Playwright
  describe Scene do
    let(:sender) { double(:sender) }
    let(:receiver) { double(:receiver) }
    let(:stage) { double(:stage) }

    class ExampleScene < Scene
      sender_accessor :example_sender
      receiver_accessor :example_receiver
    end

    subject { ExampleScene.new(stage, sender, receiver) }

    context "sender_accessor" do
      it "aliases the sender method" do
        expect(subject.example_sender).to eq(sender)
      end
    end

    context "receiver_accessor" do
      it "aliases the receiver method" do
        expect(subject.example_receiver).to eq(receiver)
      end
    end

    context "==" do
      let(:otherScene) { Scene.new(subject.stage, sender, receiver) }

      it "should match identical object" do
        expect(subject == otherScene).to be_truthy
      end

      it "compares stages" do
        otherScene.stage = Stage.new
        expect(subject == otherScene).to be_falsey
      end

      it "compares sender" do
        otherScene.sender = double(:sender)
        expect(subject == otherScene).to be_falsey
      end

      it "compares receiver" do
        otherScene.receiver = double(:receiver)
        expect(subject == otherScene).to be_falsey
      end

      it "checks for same type" do
        expect(subject == double(:scene, stage: subject.stage, sender: sender, receiver: receiver)).to be_falsey
      end
    end
  end
end
