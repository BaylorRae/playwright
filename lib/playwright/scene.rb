module Playwright
  # == Playwright::Scene
  #
  # Scene is the service layer between your test and page object models. It
  # allows common interactions to be duplicated in tests without letting the
  # tests know too much about the page.
  #
  #     class PurchaseProduct < Playwright::Scene
  #       sender_accessor :buyer
  #     
  #       def purchase_product(product)
  #         LoginHelper.login_as(buyer)
  #         ProductPage.purchase(product.id)
  #         stage.orders.find_or_add(product.orders.last)
  #       end
  #     end
  class Scene
    attr_reader :stage
    attr_accessor :sender, :receiver

    def initialize(stage, sender, receiver)
      @stage = stage
      @sender = sender
      @receiver = receiver
    end

    # Aliases the +sender+ method to better describe who the action is coming
    # from.
    #
    #   class OrderScene < Playwright::Scene
    #     sender_accessor :buyer
    #
    #     def purchase_product(product)
    #       LoginHelper.login_as(buyer)
    #     end
    #   end
    def self.sender_accessor(name)
      define_method(name, instance_method(:sender))
    end


    # Aliases the +receiver+ method to better describe who is receiving the
    # action.
    #
    #   class OrderScene < Playwright::Scene
    #     receiver_accessor :seller
    #
    #     def deliver_order(order)
    #       LoginHelper.login_as(seller)
    #     end
    #   end
    def self.receiver_accessor(name)
      define_method(name, instance_method(:receiver))
    end

    def ==(other) # :nodoc:
      return false unless other.is_a?(Scene)
      stage == other.stage && sender == other.sender && receiver == other.receiver
    end
  end
end
