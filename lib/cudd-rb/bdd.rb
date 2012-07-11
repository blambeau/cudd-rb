module Cudd
  module BDD

    attr_reader :manager

    def zero?
      self == manager.zero
    end
    alias false? :zero?

    def satisfiable?
      !zero?
    end

    def one?
      self == manager.one
    end
    alias :tautology? :one?
    alias :true? :one?

    def ref
      manager.ref(self)
    end

    def deref(recursive = true)
      manager.deref(self, recursive)
    end

    def &(other)
      manager.and(self, other)
    end

    def |(other)
      manager.or(self, other)
    end

    def !
      manager.not(self)
    end

  end # module BDD
end # module Cudd
