module Cudd
  module BDD

    attr_reader :manager

    def zero?
      self == manager.zero
    end

    def one?
      self == manager.one
    end

  end # module BDD
end # module Cudd