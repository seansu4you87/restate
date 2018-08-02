module Restate
end

require "restate/async"
require "restate/command"
require "restate/database"
require "restate/dsl"
require "restate/graph"
require "restate/version"

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
