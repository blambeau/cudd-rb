module Cudd
  class Assignment

    attr_reader :interface
    protected :interface

    def initialize(interface, values)
      @interface = interface
      @values    = values2array012(values)
    end

    def to_a
      @values
    end

    def to_hash
      {}.tap do |h|
        to_a.each_with_index do |value, index|
          h[ @interface.ith_var(index) ] = (value==1) if value < 2
        end
      end
    end

    def hash
      to_a.hash + 37*interface.hash
    end

    def ==(other)
      return nil unless other.is_a?(Assignment)
      interface == other.interface && to_a==other.to_a
    end

    def <=>(other)
      return nil unless interface == other.interface
      to_s <=> other.to_s
    end

    def to_s
      to_a.map{|x| x<2 ? x.to_s : '-' }.join
    end

  private

    IntegerLike = proc{|arg| arg.respond_to? :to_i}

    def values2array012(values)
      return values.to_a if values.is_a?(Assignment)
      result = Array.new(@interface.size, 2)
      case values
      when Array
        values.each_with_index do |val,index|
          result[index] = val2assignment012(val)
        end
      when Hash
        values.each_pair do |var,val|
          result[var2index(var)] = val2assignment012(val)
        end
      else
        raise ArgumentError, "Invalid assignment values `#{values.inspect}`"
      end
      result
    end

    def val2assignment012(val)
      case val
      when TrueClass   then 1
      when FalseClass  then 0
      when NilClass    then 2
      when IntegerLike then val.to_i
      else
        raise ArgumentError, "Invalid assignment value `#{val}`"
      end
    end

    def var2index(var)
      case var
      when BDD         then var.var_index
      when IntegerLike then var.to_i
      else
        raise ArgumentError, "Invalid variable `#{var}`"
      end
    end

  end # class Assignment
end # module Cudd