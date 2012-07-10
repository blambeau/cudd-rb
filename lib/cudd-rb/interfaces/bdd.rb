module Cudd
  module Interface
    module BDD

      # Returns the bdd ZERO
      #
      # @see Cudd_ReadZero
      def zero
        @zero ||= _bdd(Wrapper.ReadZero(_ddManager))
      end

      # Returns the bdd ONE
      #
      # @see Cudd_ReadOne
      def one
        @one ||= _bdd(Wrapper.ReadOne(_ddManager))
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