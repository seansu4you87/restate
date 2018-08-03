module Restate::Async
  # NOTE(yu) Using Sidekiq for per instance job processing with sweepers to catch failures
  #
  # One benefit of the lease system is that order is preserved.  However, that doesn't matter to us.  We only care that
  # a single instance transitions along its state machine in order.  In which order the many instances walk along their
  # state machine does not concern us.
  #
  # Since the requirements are relaxed, we can just simply use sidekiq, and enqueue a worker per instance to run the
  # transition.  The problem here is that Redis is not good enough for reliable processing.  What we can do is create
  # sweeper jobs that look for stale instances, and boots them up again.
  #
  # The sweeper will do something like:
  # - look for instances with stale `updated_at` and instance should be processing (some combo of boolean conditions)
  # - kick off a worker for all of these instances
  #
  # Pros:
  # - easier to implement
  # - easier to reason about
  #
  # Cons:
  # - requires clockwork process, or need to build a system for regularly scheduled jobs
  #
  # Overall this seems like the better solution, at least for now.  It's much easier to implement and simpler to reason
  # about.
  class TransitionWorker
  end

  # NOTE(yu) Sharded consumers ala Kafka
  #
  # One way to handle concurrent processing, is to treat the instances table like a feed
  # Query on:
  # - status (HOLD, IN_PROGRESS, COMPLETE)
  # - updated_at ordered by least recently updated
  # - shard_id
  #
  # The shards allow a lease monitor to distribute a set of shards over a set of leases, and make sure that some kind
  # of lease worker is working on a lease.
  #
  # We will create many virtual shards (1024, or 2048).  Each lease is a "physical" shard, responsible for a set of
  # shards.  There will be a "leases" table where this information can change:
  #
  # leases
  # - id: Integer
  # - token: UUID
  # - shards: Integer[]
  # - taken_at: Timestamp
  #
  # Leases can be deleted at anytime, and the number of leases is the amount of parallelism in the system
  #
  # Open Questions
  # - Can we do a long poll query, to prevent excessive reads on the instances table?
  #
  # Pros:
  # - in order processing
  # - adjustable concurrency
  #
  # Cons:
  # - db read thrashing?
  # - complex to implement
  class LeaseWorker
  end
end
