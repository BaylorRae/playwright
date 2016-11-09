require "spec_helper"

module Playwright
  describe Props do

    it "is an array" do
      expect(Props.new).to be_kind_of(Array)
    end

  end
end
