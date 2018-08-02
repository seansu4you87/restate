class Restate::Command::PersistingGraphAsMachine
  # Graph -> Machine

  attr_reader :graph

  def initialize(graph)
    @graph = graph
  end

  def execute!
    # TODO(yu): Idempotence
  end
end
