module Playwright
  # == Playwright::Stage
  #
  # Stage encapsulates the Actors, Scenes and Props for a test.
  #
  # === Actors
  #
  # Every stage needs actors. Actors added to the stage are available as
  # instance methods and can be assigned a sender or receiver to a Scene.
  #
  #     class ActorStage < Playwright::Stage
  #       actors do
  #         actor(:actor_1) { User.first! }
  #       end
  #     end
  #
  #     stage = ActorStage.new
  #     stage.actor_1 #=> User
  #
  # === Scenes
  #
  # Scenes are the service layer in your tests. They are the middleware between
  # the test and the page object models.
  #
  #     class SceneStage < Playwright::Stage
  #       actors do
  #         actor(:actor_1) { User.first! }
  #         actor(:actor_2) { User.second! }
  #         actor(:actor_3) { User.last! }
  #       end
  #
  #       scenes do
  #         scene Scene1, from: :actor_1, to: actor_2
  #         scene Scene2, from: :actor_2, to: actor_3
  #       end
  #     end
  #
  #     stage = SceneStage.new
  #
  #     # current scene with actors
  #     scene = stage.current_scene
  #     scene.sender #=> stage.actor_1
  #     scene.receiver #=> stage.actor_2
  #
  #     # next scene with actors
  #     scene = stage.next_scene
  #     scene.sender #=> stage.actor_2
  #     scene.receiver #=> stage.actor_3
  #
  # === Full Example
  #
  #     class FulfillmentStage < Playwright::Stage
  #       actors do
  #         actor(:buyer)   { User.find_by(username: 'buyer') }
  #         actor(:seller)  { User.find_by(username: 'seller') }
  #         actor(:fulfillment_agency) { FulfillmentAgency.find_by(name: 'agency-1') }
  #       end
  #     
  #       scenes do
  #         scene PurchaseProduct, from: :buyer, to: :seller
  #         scene FulfillOrder, from: :seller, to: :fulfillment_agency
  #       end
  #     
  #       prop_collection(:products) { |p| p.id }
  #       prop_collection(:orders) { |o| o.invoice_number }
  #       prop_collection(:fulfillments) { |f| f.id }
  #     end
  class Stage

    def method_missing(name, *args, &block)
      narrator = self.class.narrator
      return narrator.get_actor(name) if narrator.has_actor?(name)
      return narrator.get_scene(self, name) if narrator.has_scene?(self, name)
      super
    end

    def actors
      self.class.narrator.actors
    end

    def scenes
      self.class.narrator.scenes(self)
    end

    def self.actors(&block)
      narrator.add_actors(&block)
    end

    def self.scenes(&block)
      narrator.add_scenes(&block)
    end

    def self.prop_collection(name, &block)
      define_method name do
        @props ||= {}
        @props[name] ||= Props.new(block)
      end
    end

    def self.narrator
      Narrator.find_or_create(self)
    end
  end
end
