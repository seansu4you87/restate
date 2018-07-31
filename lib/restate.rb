require "restate/version"

module Restate
  module DB
    class Machine; end
    class State; end
    class Transition; end
    class Instance; end
    class Log; end
  end

  module DSL
    class State; end
    class Transition; end
    class Graph
      class Node; end
      class Edge; end
    end
  end

  module Process
    class PickupWorker; end
    class LeaseWorker; end
  end
end
