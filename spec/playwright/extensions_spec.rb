require "spec_helper"

module Playwright
  describe ClassMethods do
    context "narrators" do
      let(:narrator) { double(:narrator) }

      before do
        stub_const('Foo', Class)
        stub_const('Bar', Foo)
        class Foo
          extend ClassMethods
        end

        class Bar < Foo
        end
      end

      it "accesses the narrators array" do
        expect(Foo.narrators).to eq([])
      end

      it "creates a copy for child classes" do
        Foo.narrators << narrator
        expect(Bar.narrators).to eq([narrator])
      end

      it "child classes don't affect parents" do
        Bar.narrators << Narrator
        expect(Foo.narrators).to eq([])
      end
    end
  end
end
