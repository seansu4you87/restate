module Restate::DSL
  class Graph
    class Node
      attr_reader :name

      def initialize(name)
        @name      = name
        @neighbors = {}
      end

      def add_neighbor(neighbor)
        @neighbors[neighbor.name] = neighbor
      end

      def neighbors
        @neighbors.values
      end
    end

    def initialize
      @nodes = {}
    end

    def add_edge(name_1, name_2)
      @nodes[name_1] ||= Node.new(name_1)
      @nodes[name_2] ||= Node.new(name_2)
      @nodes[name_1].add_neighbor(@nodes[name_2])
      true
    end

    def nodes
      @nodes.values
    end
  end

  def restate(name, &blk)
    @current_graph = Graph.new
    instance_eval(&blk)
    PersistingGraphAsMachine(@current_graph, name)
  end

  def state(name, neighbors = [])
    neighbors = [neighbors] unless neighbors.is_a? Array
    neighbors.each do |neighbor|
      @current_graph.add_edge(name, neighbor)
    end
  end
end

