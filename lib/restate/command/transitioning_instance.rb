class Restate::Command::TransitioningInstance
  include Restate::Database

  attr_reader :instance, current_state

  def initialize(instance_id, current_state_id)
    # TODO(yu) make this extremely idempotent
    # TODO(yu) make this ok to call when instance is at the last state
    # TODO(yu) make this ok to call when instance's current state isn't the current_state_id
    @instance      = maybe_fetch!(instance_id, Instance)
    @current_state = maybe_fetch!(current_state_id, State)
  end

  def execute!
    # TODO(yu) FOR UPDATE lock or optimistic locking?
    lock_instance do
      Database.transaction do
        next_state = attempt_transition
        validate_next!(next_state)
        update_state!(next_state)
        log_transition(next_state)
      end
    end
  end

  def maybe_fetch!(id, klass)
    case id
    when Integer
      klass[id]
    when klass
      id
    else
      raise ArgumentError, "No row in '#{klass}' found with '#{id}'"
    end
  end

  def lock_instance
    # code here
  end

  def attempt_transition
    # code here
  end

  def validate_next!(next_state)
    # code here
  end

  def update_state!(next_state)
    # code here
  end

  def log_transition(next_state)
    # code here
  end

end