require "spec_helper"

module Playwright
  describe Props do

    it "is an array" do
      expect(subject).to be_kind_of(Array)
    end

    context "find_or_add_by" do
      let(:users) { [double(:bob, name: "bob"), double(:alice, name: "alice"), double(:leo, name: "leo")] }

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

      it "finds an item from an expression" do
        users.each { |u| subject << u }

        subject.include_query = Proc.new { |a, b| a.name == b.name }
        subject.find_or_add_by(double(:duplicate_alice, name: "alice"))

        expect(subject).to eq(users)
      end
    end

  end
end
