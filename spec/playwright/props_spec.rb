require "spec_helper"

module Playwright
  describe Props do

    it "is an array" do
      expect(subject).to be_kind_of(Array)
    end

    context "find_or_add_by" do
      let(:users) { [double(:bob, name: "bob"), double(:alice, name: "alice"), double(:leo, name: "leo")] }

      let :user_props do
        props = Props.new -> (u) { u.name }
        users.each { |u| props << u }
        props
      end

      it "adds an item that doesn't exist" do
        subject.find_or_add_by("one")
        expect(subject).to eq(["one"])
      end

      it "doesn't add the item if already exists" do
        %w[one two three].each { |i| subject << i }
        subject.find_or_add_by("two")
        expect(subject).to eq(%w[one two three])
      end

      it "returns the value being passed in" do
        %w[one two three].each { |i| subject << i }
        expect(subject.find_or_add_by("two")).to eq("two")
      end

      it "matches based on custom expression" do
        marvin = double(:marvin, name: "marvin")
        user_props.find_or_add_by(marvin)
        expect(user_props).to eq(users << marvin)
      end

      it "doesn't duplicate from custom expression" do
        user_props.find_or_add_by(double(:duplicate_alice, name: "alice"))
        expect(user_props).to eq(users)
      end
    end

  end
end
