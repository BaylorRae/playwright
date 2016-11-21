# Playwright

[![Build Status](https://travis-ci.org/BaylorRae/playwright.svg?branch=master)](https://travis-ci.org/BaylorRae/playwright) [![Code Climate](https://codeclimate.com/github/BaylorRae/playwright/badges/gpa.svg)](https://codeclimate.com/github/BaylorRae/playwright) [![Test Coverage](https://codeclimate.com/github/BaylorRae/playwright/badges/coverage.svg)](https://codeclimate.com/github/BaylorRae/playwright/coverage)

Playwright is a foundational piece for building a test framework. It allows
test cases to be written as a play with all the moving parts to be categorized
as a `Stage`, `Scene`, `Props` or `Actor`.

### What are `Stage`, `Scene` or `Actor`?

Each test contains a single `Stage` which encapsulates one or many `Scene`s and
`Props`. There should only be one stage created in a test as it is the context
that everything should go through.

Once you have a `Stage` the next step is to create the `Scene`s that help build
the test or "story". A `Scene` is a service layer between your test and page
object models. It also groups two `Actor`s together that will "interact" as the
test runs. A `Stage` has multiple `Scene`s as there are generally more than one
action in a test.

An `Actor` will likely be a user in your system but it can be anything that
interacts another object type.

## Example

Let's imagine we have an platform with **sellers**, **buyers** and **fulfillment
agencies**. We need to create a test around fulfilling an order. You can teach
Playwright how to group actors together as **buyer** will only interact with
**seller** and **seller** will only interact with the **fulfillment agency**.

```ruby
stage = FulfillmentStage.new

# scenes
stage.scenes  #=> [PurchaseProduct, FulfillOrder]
stage.purchase_product #=> PurchaseProduct
stage.fulfill_order    #=> FulfillOrder

# actors
stage.actors #=> [:buyer, :seller, :fulfillment_agency]
stage.buyer   #=> User(username: 'buyer')
stage.seller  #=> User(username: 'seller')
stage.fulfillment_agency #=> FulfillmentAgency

# props
stage.products #=> [Product, Product, ...]
stage.orders #=> [Order, Order, ...]
stage.fulfillments #=> [OrderFulfillment, OrderFulfillment, ...]
```

The above code example is defined from the following.

```ruby
class FulfillmentStage < Playwright::Stage
  actors do
    actor(:buyer)   { User.find_by(username: 'buyer') }
    actor(:seller)  { User.find_by(username: 'seller') }
    actor(:fulfillment_agency) { FulfillmentAgency.find_by(name: 'agency-1') }
  end

  scenes do
    scene :purchase_product, from: :buyer, to: :seller
    scene :fulfill_order, from: :seller, to: :fulfillment_agency
  end

  prop_collection(:products) { |p| p.id }
  prop_collection(:orders) { |o| o.invoice_number }
  prop_collection(:fulfillments) { |f| f.id }
end

class PurchaseProduct < Playwright::Scene
  sender_accessor :buyer

  def purchase_product(product)
    LoginHelper.login_as(buyer)
    ProductPage.purchase(product.id)
    stage.orders.find_or_add(product.orders.last)
  end
end

class FulfillOrder < Playwright::Scene
  sender_accessor :seller
  receiver_accessor :fulfillment_agency

  def fulfill(order)
    LoginHelper.login_as(seller)
    OrderPage.fulfill_order(order.invoice_number)

    LoginHelper.login_as(fulfillment_agency)
    FulfillmentPage.ship_order(order.invoice_number)
    stage.fulfillments.find_or_add(order.fulfillments.last)
  end
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'playwright'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install playwright

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/baylorrae/playwright.

