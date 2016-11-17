require 'active_support/hash_with_indifferent_access'

module Playwright
  module DSL
    # Defines an actor in a stage. The block is only evaluated once when the
    # method is called the first time.
    #
    #   class ExampleStage < Playwright::Stage
    #     actors do
    #       actor(:actor_name) { User.first! }
    #     end
    #   end
    class ActorDSL < BasicObject
      attr_reader :actors

      def initialize
        @actors = ::ActiveSupport::HashWithIndifferentAccess.new
      end

      def self.find(&block) # :nodoc:
        dsl = new
        dsl.instance_eval(&block)
        dsl.actors
      end

      def actor(name, &block)
        @actors[name] = block
      end
    end
  end
end
