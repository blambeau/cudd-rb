module Cudd
  class Assignment

    IntegerLike = proc{|arg| arg.respond_to? :to_i}

    def initialize(interface, input)
      @interface = interface
      @input = input
    end

    def to_a
      result = Array.new(@interface.size, 2)
      case @input
      when Array
        @input.each_with_index do |val,index|
          result[index] = val2assignment012(val)
        end
      when Hash
        @input.each_pair do |var,val|
          result[var2index(var)] = val2assignment012(val)
        end
      else
        raise ArgumentError, "Invalid assignment input `#{@input.inspect}`"
      end
      result
    end

    def with_memory_pointer
      input, res = self.to_a, nil
      FFI::MemoryPointer.new(:int, input.size) do |ptr|
        ptr.write_array_of_int(input)
        res = yield(ptr)
      end
      res
    end

  private

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