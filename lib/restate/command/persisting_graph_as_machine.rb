class Restate::Command::PersistingGraphAsMachine
  # Graph -> Machine

  attr_reader :graph

  def initialize(graph)
    @graph = graph
  end

  def execute!
    validate_graph!
    machine, dependencies = generate_models
    persist!(machine, dependencies)
  end

  private

  def generate_models
    # code here
  end

  def validate_graph!
    # code here
  end

  def persist!(machine, dependencies)
    # TODO(yu): Idempotence
    Restate::Database.tranasction do
      machine.save!
      dependencies.each { |d| d.save! }
    end
    machine
  rescue UniqueConstraintViolation
    fetched_machine, fetched_dependencies = fetch_models(machine.name)
    validate_idempotence!(fetched_machine)
    fetched_dependencies.each { |d| validate_idempotence!(d) }
    fetched_machine
  end

  def fetch_models(machine_name)
    # code here
  end

  def validate_idempotence!(model)
    # code here
  end
end
