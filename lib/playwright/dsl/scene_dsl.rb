require 'active_support/inflector'

module Playwright
  module DSL
    # Defines an actor in a stage. The block is only evaluated once when the
    # method is called the first time.
    #
    #   class ExampleStage < Playwright::Stage
    #     actors do
    #       actor(:buyer) { User.first! }
    #       actor(:seller) { User.first! }
    #     end
    #
    #     scenes do
    #       scene PurchaseProduct, from: :buyer, to: :seller
    #     end
    #   end
    class SceneDSL
      attr_reader :scenes
      SceneWithActors = Struct.new(:klass, :from, :to) do
        def init(stage)
          klass.new(stage, stage.send(from), stage.send(to))
        end
      end

      def initialize # :nodoc:
        @scenes = {}
      end

      def self.find(&block) # :nodoc:
        dsl = new
        dsl.instance_eval(&block)
        dsl.scenes
      end

      def scene(klass, options)
        if klass.kind_of?(Class)
          accessor = klass.name.demodulize.underscore
        else
          accessor = klass.to_s
          klass = accessor.camelize.constantize
        end

        @scenes[accessor] = SceneWithActors.new(klass, options[:from], options[:to])
      end
    end
  end
end
