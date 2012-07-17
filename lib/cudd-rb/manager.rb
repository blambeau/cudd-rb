require_relative 'interfaces/root'
module Cudd
  class Manager
    include Interface::Root

    # Options passed at construction.
    attr_reader :options

    # Creates a manager instance.
    #
    # @api private
    def initialize(*args)
      args.each do |arg|
        @options        = arg if arg.is_a?(Hash)
        @root_manager   = arg if arg.is_a?(Manager)
        @native_manager = arg if arg.is_a?(FFI::Pointer)
      end
    end

    # Creates a root manager by invoking `Cudd_Init`
    #
    # @api private
    def self.root(options)
      options    = options.dup
      bdd_vars   = (options[:numVars]   ||= 0)
      zdd_vars   = (options[:numVarsZ]  ||= 0)
      num_slots  = (options[:numSlots]  ||= 256)
      cache_size = (options[:cacheSize] ||= 262144)
      max_mem    = (options[:maxMemory] ||= 0)
      native_manager = Wrapper.Init(bdd_vars, zdd_vars, num_slots, cache_size, max_mem)
      raise Cudd::Error, "Unable to create a manager" unless native_manager
      Manager.new(options, native_manager).tap do |m|
        ObjectSpace.define_finalizer(m, lambda{|d| d.close})
      end
    end

    # Closes this manager by invoking `Cudd_Quit`.
    def close
      Wrapper.Quit(@native_manager) if @native_manager
    ensure
      @native_manager = nil
    end

    # Is this manager alive?
    #
    # A manager is alive between its creation (via `Cudd.manager`) and an invocation to
    # `close`, either explicitely of implicitely (garbage collected by ruby).
    #
    # @api public
    def alive?
      !@native_manager.nil?
    end

    # Returns true if this manager has already been closed, false otherwise.
    #
    # @api public
    def closed?
      @native_manager.nil?
    end

    # Returns the native manager, that is, a FFI::Pointer to the CUDD's
    # `DdManager`.
    #
    # @api public
    def native_manager
      @native_manager
    end

  private

    # @api private
    def root_manager
      @root_manager || self
    end

  end # class Manager
end # module Cudd
require_relative 'interfaces/bdd'
