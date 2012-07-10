module Cudd
  module Interface
    module BDD

      # Returns the bdd ZERO
      #
      # @see Cudd_ReadZero
      def zero
        @zero ||= _bdd(Wrapper.ReadZero(native_manager))
      end

      # Returns the bdd ONE
      #
      # @see Cudd_ReadOne
      def one
        @one ||= _bdd(Wrapper.ReadOne(native_manager))
      end

      # Returns the BDD variable with index i.
      #
      # @param [Integer] i a variable index
      # @see Cudd_bddIthVar
      def ith_var(i)
        _bdd(Wrapper.bddIthVar(native_manager, i))
      end

      # Returns a new BDD variable.
      #
      # @see Cudd_bddNewVar
      def new_var
        _bdd(Wrapper.bddNewVar(native_manager))
      end

    private

      def _bdd(pointer)
        m = self
        pointer.instance_eval{ @manager = m }
        pointer.extend(Cudd::BDD)
      end

    end # module BDD
  end # module Interface
end # module Cudd