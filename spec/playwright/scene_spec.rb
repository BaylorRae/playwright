require "spec_helper"

module Playwright
  describe Scene do
    let(:sender) { double(:sender) }
    let(:receiver) { double(:receiver) }

    class ExampleScene < Scene
      sender_accessor :example_sender
      receiver_accessor :example_receiver
    end

    subject { ExampleScene.new(sender, receiver) }

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
  end
end
