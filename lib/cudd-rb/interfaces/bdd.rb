module Cudd
  module Interface
    module BDD

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

      # Returns the BDD variable with index i.
      #
      # @param [Integer] i a variable index
      # @see Cudd_bddIthVar
      def ith_var(i)
        _bdd Wrapper.bddIthVar(native_manager, i)
      end

      # Returns a new BDD variable.
      #
      # @see Cudd_bddNewVar
      def new_var
        _bdd Wrapper.bddNewVar(native_manager)
      end

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

      # Returns the value of a BDD for a given variable assignment `input`.
      #
      # @see Cudd_Eval
      def eval(f, input)
        assignment = Assignment.new(self, input)
        assignment.with_memory_pointer do |ptr|
          _bdd Wrapper.Eval(native_manager, f, ptr)
        end
      end

    private

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
