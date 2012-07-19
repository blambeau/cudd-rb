module Cudd
  module BDD

    def self.define_delegate_method(from, to = from)
      define_method from do |*args, &bl|
        manager.send(to, *([self] + args), &bl)
      end
    end

    def self.define_delegate_methods(*methods)
      methods = methods.first if methods.size==1 && methods.first.is_a?(Hash)
      methods.each do |m|
        define_delegate_method *Array(m)
      end
    end

    attr_reader :manager

    define_delegate_methods(:var_index, :var_name)
    alias :index :var_index
    alias :name  :var_name

    def zero?
      self == manager.zero
    end
    alias :false? :zero?
    alias :contradiction? :zero?

    def one?
      self == manager.one
    end
    alias :true? :one?
    alias :tautology? :one?

    define_delegate_methods(:ref, :deref)
    define_delegate_methods(:is_complement?)

    define_delegate_methods(:ite)
    define_delegate_methods(:and, :or, :not, :nand, :nor, :xor, :xnor)
    define_delegate_methods(:& => :and, :| => :or, :! => :not)
    define_delegate_methods(:* => :and, :+ => :or, :~ => :not)

    define_delegate_methods(:cofactor, :restrict, :minimize, :li_compaction)
    define_delegate_methods(:exist_abstract, :univ_abstract, :exist, :univ, :forall)

    define_delegate_methods(:eval, :satisfiable?, :satisfied?)
    define_delegate_methods(:each_cube, :one_cube, :all_cubes)

    define_delegate_methods(:support)

    define_delegate_methods(:to_cube => :bdd2cube, :to_dnf => :bdd2dnf)

    def hash
      address.hash
    end

    def ==(other)
      address==other.address
    end
    alias :eql? :==

    def to_s
      "BDD(#{address})"
    end
    alias :inspect :to_s

  end # module BDD
end # module Cudd
