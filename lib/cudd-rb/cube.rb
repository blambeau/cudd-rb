module Cudd
  class Cube

    attr_reader :interface

    def initialize(interface, a012)
      @interface = interface
      @a012      = a012.freeze
    end

    def self.new(interface, arg)
      return arg if arg.is_a?(Cube)
      if arg.is_a?(BDD)
        super(interface, interface.bdd2cube(arg))
      else
        a012 = Array.new(interface.size, 2)
        enum = arg.is_a?(Hash) ? arg.each_pair : arg.each_with_index
        enum.each do |k,v|
          k,v = v,k unless arg.is_a?(Hash)
          index = [k, v].find{|x| x.is_a?(Cudd::BDD) }.index rescue k
          a012[index] = truth_to_012(v)
        end
        super(interface, a012)
      end
    end

    def hash
      @hash ||= to_a012.hash + 37*interface.hash
    end

    def ==(other)
      return nil unless other.is_a?(Cube) && other.interface==interface
      to_a012 == other.to_a012
    end

    def to_cube
      self
    end

    def to_a012
      @a012
    end

    def to_bdd
      interface.cube2bdd(to_a012)
    end

    def to_truths
      to_a012.map{|x| Cube.arg012_to_truth(x)}
    end

    def to_hash
      h = {}
      to_a012.each_with_index do |val,index|
        truth = Cube.arg012_to_truth(val)
        h[interface.ith_var(index)] = truth unless truth.nil?
      end
      h
    end

    def to_bool_expr
      buf = ""
      to_a012.each_with_index do |val, index|
        next if val == 2
        name = interface.ith_var(index).var_name
        buf << " & " unless buf.empty?
        buf << "!" if val==0
        buf << name.to_s
      end
      buf
    end
    alias :to_s :to_bool_expr

  private

    def self.arg012_to_truth(arg012)
      arg012 <= 1 ? (arg012 == 1) : nil
    end

    def self.truth_to_012(truth)
      case truth
      when Cudd::BDD  then truth.is_complement? ? 0 : 1
      when Integer    then (truth >= 0 and truth <= 1) ? truth : 2
      when TrueClass  then 1
      when FalseClass then 0
      when NilClass   then 2
      else
        raise ArgumentError, "Invalid truth value #{truth}"
      end
    end

  end # class Cube
end # module Cudd