module Cudd
  class Manager

    # Options passed at construction.
    attr_reader :options

    # Creates a manager instance.
    #
    # @api private
    def initialize(options)
      @options   = options.dup
      bdd_vars   = (@options[:numVars]   ||= 0)
      zdd_vars   = (@options[:numVarsZ]  ||= 0)
      num_slots  = (@options[:numSlots]  ||= 256)
      cache_size = (@options[:cacheSize] ||= 262144)
      max_mem    = (@options[:maxMemory] ||= 0)
      @ddManager = Wrapper.Init(bdd_vars, zdd_vars, num_slots, cache_size, max_mem)
      raise Cudd::Error, "Unable to create a manager" unless @ddManager
      ObjectSpace.define_finalizer(self, lambda{|d| d.close})
    end

    # Closes this manager by invoking `Cudd_Quit`.
    def close
      Wrapper.Quit(@ddManager) if @ddManager
    ensure
      @ddManager = nil
    end

    # Is this manager alive?
    #
    # A manager is alive between its creation (via `Cudd.manager`) and an invocation to
    # `close`, either explicitely of implicitely (garbage collected by ruby).
    #
    # @api public
    def alive?
      !@ddManager.nil?
    end

    # Returns true if this manager has already been closed, false otherwise.
    #
    # @api public
    def closed?
      @ddManager.nil?
    end

    # Returns an extension interface for a given name.
    def interface(name)
      mod = Cudd::Interface.const_get(name)
      dup.extend(mod)
    end

    private

      def _ddManager
        @ddManager
      end

  end # class Manager
end # module Cudd
require_relative 'interfaces/bdd'