module Playwright
  class Scene
    attr_accessor :sender, :receiver

    def initialize(sender, receiver)
      @sender = sender
      @receiver = receiver
    end

    def self.sender_accessor(name)
      define_method(name, instance_method(:sender))
    end

    def self.receiver_accessor(name)
      define_method(name, instance_method(:receiver))
    end

    def ==(other)
      return false unless other.is_a?(Scene)
      sender == other.sender && receiver == other.receiver
    end
  end
end
