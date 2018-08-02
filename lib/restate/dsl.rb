module Restate::DSL
  CALLBACKS = {}

  def restate(name, &blk)
    raise ArgumentError, "State machine '#{name}' has been restated!" if CALLBACKS[name]

    CALLBACKS[name]           = {}
    @_restate_current_graph   = Restate::Graph.new
    @_restate_current_machine = name
    instance_eval(&blk)
    PersistingGraphAsMachine(@_restate_current_graph, name)
  end

  def state(name, neighbors = [])
    neighbors = [neighbors] unless neighbors.is_a? Array
    neighbors.each do |neighbor|
      @_restate_current_graph.add_edge(name, neighbor)
    end
  end

  def at(name, &blk)
    CALLBACKS[@_restate_current_machine][name] = blk
  end
end

# Proof of concept code

include Restate::DSL

restate :transaction do
  state :pending, :generated
  state :generated, :signed
  state :signed, :broadcasted
  state :broadcasted, :confirmed
  state :confirmed, :finalized
  state :finalized

  at :pending do |model_id|
    puts "generating transaction for #{model_id}"
    :generated
  end

  at :generated do |model_id|
    puts "signing transaction for #{model_id}"
    :signed
  end

  at :signed do |model_id|
    puts "broadcasting transaction for #{model_id}"
    :broadcasted
  end

  at :broadcasted do |model_id|
    puts "confirming transaction for #{model_id}"
    :confirmed
  end

  at :confirmed do |model_id|
    puts "finalizing transaction for #{model_id}"
    :finalized
  end
end

tr = TransactionRequest.new
instance = Restate.make(:transaction, tr)

TransitioningInstance.execute!(instance)
TransitioningInstance.execute!(instance)
TransitioningInstance.execute!(instance)
TransitioningInstance.execute!(instance)
TransitioningInstance.execute!(instance)

puts "hello"
