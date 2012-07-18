module Cudd
  module Interface
    module BDD

      ### REFERENCE COUNT ################################################################

      # Increases the reference count of `f` and returns it.
      #
      # @see Cudd_Ref
      def ref(f)
        Wrapper.Ref(f)
        f
      end

      # Decreases the reference count of `f` and returns it.
      #
      # Uses `Cudd_RecursiveDeref` if `recursive` is true (defauts), decreasing
      # reference counts of all children of `f`. Uses `Cudd_Deref` otherwise
      # (use only if your are sure).
      #
      # @see Cudd_Deref, Cudd_RecursiveDeref
      def deref(f, recursive = true)
        if recursive
          Wrapper.RecursiveDeref(native_manager, f)
        else
          Wrapper.Deref(f)
        end
        f
      end

      ### VARS ###########################################################################

      # Returns the number of BDD variables in use
      #
      # @see Cudd_ReadSize
      def size
        Wrapper.ReadSize(native_manager)
      end
      alias :bdd_count :size

      # Returns the variable index of a given node.
      #
      # @see Cudd_NodeReadIndex
      def var_index(bdd)
        Wrapper.NodeReadIndex(bdd)
      end

      # Returns the BDD variable with index i.
      #
      # @param [Integer] i a variable index
      # @see Cudd_bddIthVar
      def ith_var(i)
        _bdd Wrapper.bddIthVar(native_manager, i)
      end

      # Returns the ith-vars denoted by `arg` as an Array of BDDs.
      #
      # Example:
      #   x, y, z = manager.ith_vars(0, 1, 2)
      #   x, y, z = manager.ith_vars(0..2)
      #   x, y, z = manager.ith_vars([0, 1, 2])
      #
      def ith_vars(*args)
        args = args.first if args.size==1
        Array(args).map(&:to_i).map{|i| ith_var(i)}
      end

      # Returns a new BDD variable.
      #
      # @see Cudd_bddNewVar
      def new_var
        _bdd Wrapper.bddNewVar(native_manager)
      end

      # Creates `count` new variables and returns them as an Array.
      #
      # Example:
      #   x, y, z = manager.new_vars(3)
      #
      def new_vars(count)
        (0...count).map{ new_var }
      end

      ### CONSTANTS ######################################################################

      # Returns the bdd ONE
      #
      # @see Cudd_ReadOne
      def one
        _bdd Wrapper.ReadOne(native_manager)
      end

      # Returns the bdd ZERO
      #
      # @see Cudd_ReadLogicZero
      def zero
        _bdd Wrapper.ReadLogicZero(native_manager)
      end

      ### BOOLEAN ALGEBRA ################################################################

      # Returns the negation of a BDD.
      #
      # @see Cudd_bddNot
      def not(f)
        _bdd Wrapper.bddNot(native_manager, f)
      end

      # Returns the conjunction of two BDDs.
      #
      # @see Cudd_bddAnd
      def and(f, g)
        _bdd Wrapper.bddAnd(native_manager, f, g)
      end

      # Returns the disjunction of two BDDs.
      #
      # @see Cudd_bddOr
      def or(f, g)
        _bdd Wrapper.bddOr(native_manager, f, g)
      end

      ### EVALUATION & SATISFIABILITY ####################################################

      # Builds an Assignment instance from an Array of truth values of a Hash.
      #
      # Example:
      #   interface.assignment(x => true, y => false)
      #   interface.assignment([1, 0])
      #
      def assignment(input)
        Assignment.new(self, input)
      end

      # Returns the value of a BDD for a given variable assignment `input`.
      #
      # @see Cudd_Eval
      def eval(f, assignment)
        assignment, res = assignment(assignment), nil
        with_ffi_pointer(:int, size) do |ptr|
          ptr.write_array_of_int(assignment.to_a)
          res = _bdd Wrapper.Eval(native_manager, f, ptr)
        end
        res
      end

      # Returns true if `bdd` is satisfiable, false otherwise.
      def satisfiable?(bdd)
        !(zero == bdd)
      end

      # Returns true if `bdd` is satisfied by a given assignment, false otherwise.
      def satisfied?(bdd, assignment)
        one == eval(bdd, assignment)
      end

      # Yields each assignment that satisfies `bdd` in turn.
      def each_sat(bdd)
        return self.enum_for(:each_sat, bdd) unless block_given?
        return unless satisfiable?(bdd)
        size, gen = self.size, nil
        with_ffi_pointer(:pointer) do |cube_pointer|
          with_ffi_pointer(:double) do |value_pointer|
            gen = Wrapper.FirstCube(native_manager, bdd, cube_pointer, value_pointer)
            begin
              ints = cube_pointer.read_pointer.read_array_of_int(size)
              yield Assignment.new(self, ints)
            end until Wrapper.NextCube(gen, cube_pointer, value_pointer)==0
          end
        end
      ensure
        Wrapper.GenFree(gen) if gen
      end

      # Returns the largest cube of `bdd` as a BDD
      #
      # @see Cudd_LargestCube
      def largest_cube(bdd)
        _bdd Wrapper.LargestCube(native_manager, bdd, nil)
      end

    private

      def with_ffi_pointer(type = :int, size = 1, &bl)
        FFI::MemoryPointer.new(type, size, &bl)
      end

      def _bdd(pointer)
        m = self
        pointer.tap do |p|
          p.instance_eval{ @manager = m }
          p.extend(Cudd::BDD).ref
        end
      end

    end # module BDD
  end # module Interface
end # module Cudd
