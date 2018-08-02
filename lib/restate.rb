require "restate/dsl"
require "restate/version"

module Restate
  class ValidatingGraph
    # asyclic
    # connected
  end
end

include Restate::DSL

restate :transaction do
  state :pending, :generated
  state :generated, :signed
  state :signed, :broadcasted
  state :broadcasted, :confirmed
  state :confirmed, :finalized
  state :finalized
end

puts "hello"
