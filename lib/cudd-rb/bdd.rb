module Cudd
  module BDD

    attr_reader :manager

    def zero?
      self == manager.zero
    end

    def satisfiable?
      !zero?
    end

    def one?
      self == manager.one
    end
    alias :tautology? :one?

  end # module BDD
end # module Cudd
