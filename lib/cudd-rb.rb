#
# A ruby bridge to the CU Decision Diagram package (CUDD).
#
module Cudd

  # initial size of subtables
  UNIQUE_SLOTS = 256

  # default size of the cache
  CACHE_SLOTS = 262144

  # Creates a manager instance.
  #
  # Recognized options match `Cudd_Init` arguments.
  # - :numVars  (defaults to 0)  initial number of BDD variables (subtables)
  # - :numVarsZ (defaults to 0)  initial number of ZDD variables (subtables)
  # - :numSlots (defaults to UNIQUE_SLOTS) initial size of the unique tables
  # - :cacheSize (defaults to CACHE_SLOTS) initial size of the cache
  # - :maxMemory (defaults to 0) target maximum memory occupation
  #
  # If a block is given, the manager is yield and automatically closed when the block
  # terminates (its result is returned). Otherwise, the manager is returned and its is
  # the responsibility of the caller to close it.
  #
  # @see Cudd_init
  def self.manager(opts = {})
    manager = Manager.new(opts.dup)
    if block_given?
      begin
        yield(manager)
      ensure
        manager.close if manager.alive?
      end
    else
      manager
    end
  end

end # module Cudd
require_relative "cudd-rb/version"
require_relative "cudd-rb/loader"
require_relative "cudd-rb/errors"
require_relative "cudd-rb/wrapper"
require_relative "cudd-rb/manager"
require_relative "cudd-rb/bdd"