module Playwright
  class Scene
    attr_reader :stage
    attr_accessor :sender, :receiver

    def initialize(stage, sender, receiver)
      @stage = stage
      @sender = sender
      @receiver = receiver
    end

    def self.sender_accessor(name)
      define_method(name, instance_method(:sender))
    end

    def self.receiver_accessor(name)
      define_method(name, instance_method(:receiver))
    end

    def ==(other) # :nodoc:
      return false unless other.is_a?(Scene)
      stage == other.stage && sender == other.sender && receiver == other.receiver
    end
  end
end
