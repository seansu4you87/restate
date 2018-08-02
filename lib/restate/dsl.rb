module Restate::DSL
  def restate(name, &blk)
    @restate_temporary_graph = Restate::Graph.new
    instance_eval(&blk)
    PersistingGraphAsMachine(@restate_temporary_graph, name)
  end

  def state(name, neighbors = [])
    neighbors = [neighbors] unless neighbors.is_a? Array
    neighbors.each do |neighbor|
      @restate_temporary_graph.add_edge(name, neighbor)
    end
  end
end

