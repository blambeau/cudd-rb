module Cudd
  module Interface
    module BDD

      ### BDD CREATION ###################################################################

      def bdd(pointer, &error_handler)
        return pointer if Cudd::BDD===pointer
        if FFI::Pointer::NULL==pointer
          raise Cudd::Error, "NULL pointer for BDD" unless error_handler
          error_handler.call
        end
        m = self
        pointer.tap do |p|
          p.instance_eval{ @manager = m }
          p.extend(Cudd::BDD).ref
        end
      end

      ### REFERENCE COUNT ################################################################

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
        recursive ? Wrapper.RecursiveDeref(native_manager, f) : Wrapper.Deref(f)
        f
      end

      ### VARS ###########################################################################

      # Returns the variable names
      def var_names
        @var_names ||= []
        (@var_names.size...size).each do |i|
          @var_names[i] = :"v#{i}"
        end if @var_names.size < size
        @var_names
      end

      # Sets the variable names
      def var_names=(names)
        @var_names = names
      end

      # Returns the variable name of a given bdd
      def var_name(bdd)
        return :zero if bdd==zero
        return :one  if bdd==one
        var_names[var_index(bdd)]
      end

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
        return nil if bdd==zero or bdd==one
        Wrapper.NodeReadIndex(bdd)
      end

      # Returns the BDD variable with index i.
      #
      # @param [Integer] i a variable index
      # @see Cudd_bddIthVar
      def ith_var(i)
        bdd Wrapper.bddIthVar(native_manager, i)
      end

      # Returns the ith-vars denoted by `arg` as an Array of BDDs.
      #
      # Example:
      #   x, y, z = manager.ith_vars(0, 1, 2)
      #   x, y, z = manager.ith_vars(0..2)
      #   x, y, z = manager.ith_vars([0, 1, 2])
      #
      def ith_vars(*args)
        args = args.first if args.size==1
        Array(args).map(&:to_i).map{|i| ith_var(i)}
      end

      # Returns a new BDD variable.
      #
      # @see Cudd_bddNewVar
      def new_var(name = nil)
        var = bdd Wrapper.bddNewVar(native_manager)
        var_names[var_index(var)] = name if name
        var
      end

      # Creates `count` new variables and returns them as an Array.
      #
      # Example:
      #   x, y, z = manager.new_vars(3)
      #
      def new_vars(first, *args)
        _, first = args.unshift(first), args unless args.empty?
        case first
        when Integer    then (0...first).map{ new_var }
        when Enumerable then first.map{|x| new_var(x) }
        else
          [ new_var(first) ]
        end
      end

      ### CONSTANTS ######################################################################

      # Returns the bdd ONE
      #
      # @see Cudd_ReadOne
      def one
        @one ||= bdd Wrapper.ReadOne(native_manager)
      end

      # Returns the bdd ZERO
      #
      # @see Cudd_ReadLogicZero
      def zero
        @zero ||= bdd Wrapper.ReadLogicZero(native_manager)
      end

      # Returns true if `bdd` is in complemented form, false otherwise
      def is_complement?(bdd)
        (bdd.address & 1)==1
      end

      ### BOOLEAN ALGEBRA ################################################################

      # Returns the if-then-else of three BDDs.
      #
      # @see Cudd_bddIte
      def ite(f, g, h)
        bdd Wrapper.bddIte(native_manager, f, g, h)
      end

      # Returns the negation of a BDD.
      #
      # @see Cudd_bddNot
      def not(f)
        bdd Wrapper.bddNot(native_manager, f)
      end

      # Returns the conjunction of two BDDs.
      #
      # @see Cudd_bddAnd
      def and(f, g)
        bdd Wrapper.bddAnd(native_manager, f, g)
      end

      # Returns the disjunction of two BDDs.
      #
      # @see Cudd_bddOr
      def or(f, g)
        bdd Wrapper.bddOr(native_manager, f, g)
      end

      # Returns the exclusive NAND of two BDDs.
      #
      # @see Cudd_bddNand
      def nand(f, g)
        bdd Wrapper.bddNand(native_manager, f, g)
      end

      # Returns the NOR of two BDDs.
      #
      # @see Cudd_bddNor
      def nor(f, g)
        bdd Wrapper.bddNor(native_manager, f, g)
      end

      # Returns the exclusive OR of two BDDs.
      #
      # @see Cudd_bddXor
      def xor(f, g)
        bdd Wrapper.bddXor(native_manager, f, g)
      end

      # Returns the exclusive NOR of two BDDs.
      #
      # @see Cudd_bddXnor
      def xnor(f, g)
        bdd Wrapper.bddXnor(native_manager, f, g)
      end

      ### SUPPORT ########################################################################

      # Finds the variables on which a `bdd` depends. Returns it as a BDD cube (a
      # product of the variables)
      #
      # @see Cudd_Support
      def support(bdd)
        Wrapper.Support(native_manager, bdd)
      end

      ### COERCIONS from & to Cubes ######################################################

      # Coerces `arg` to a cube.
      #
      # Example (suppose three BDD variables: x, y and z):
      #
      #   cube([1, 0, 2])              # => [1, 0, 2]
      #   cube([1, 0])                 # same
      #   cube([true, false])          # same
      #   cube([x, !y])                # same
      #   cube(x => true, y => false)  # same
      #
      def cube(arg, as = :cube)
        cube = Cube.new(self, arg)
        cube.send(:"to_#{as}")
      rescue NoMethodError
        raise ArgumentError, "Invalid 'as' option `#{as}`"
      end

      # Converts a cube array to a bdd
      #
      # @see Cudd_CubeArrayToBdd
      def cube2bdd(cube_array)
        with_ffi_pointer(:int, cube_array.size) do |ptr|
          ptr.write_array_of_int(cube_array)
          bdd Wrapper.CubeArrayToBdd(native_manager, ptr) do
            raise Cudd::Error, "Cudd_CubeArrayToBdd failed on `#{cube_array.inspect}`"
          end
        end
      end

      # Converts a bdd to a cube array
      #
      # @see Cudd_BddToCubeArray
      def bdd2cube(bdd)
        s = size
        with_ffi_pointer(:int, s) do |ptr|
          if Wrapper.BddToCubeArray(native_manager, bdd, ptr)==1
            ptr.read_array_of_int(s)
          else
            raise NotACubeError
          end
        end
      end

      # Converts a bdd to a disjunctive normal form
      def bdd2dnf(bdd)
        return "true"  if bdd==one
        return "false" if bdd==zero
        buf, size = "", 0
        each_cube(bdd) do |cube|
          size += 1
          buf << " | " unless buf.empty?
          buf << "(" << cube.to_bool_expr << ")"
        end
        size == 1 ? buf[1...-1] : buf
      end

      ### EVALUATION & SATISFIABILITY ####################################################

      # Returns the value of a BDD for a given variable assignment `input`.
      #
      # @see Cudd_Eval
      def eval(f, cube)
        with_ffi_pointer(:int, size) do |ptr|
          ptr.write_array_of_int(cube(cube, :a012))
          bdd Wrapper.Eval(native_manager, f, ptr)
        end
      end

      # Returns true if `bdd` is satisfiable, false otherwise.
      def satisfiable?(bdd)
        !(zero == bdd)
      end

      # Returns true if `bdd` is satisfied by a given assignment, false otherwise.
      def satisfied?(bdd, cube)
        one == eval(bdd, cube)
      end

      # Returns one satisfying cube for `bdd`.
      def one_cube(bdd)
        each_cube(bdd).first
      end

      # Yields each cube that satisfies `bdd` in turn.
      def each_cube(bdd)
        return self.enum_for(:each_cube, bdd) unless block_given?
        return unless satisfiable?(bdd)
        size, gen = self.size, nil
        with_ffi_pointer(:pointer) do |cube_pointer|
          with_ffi_pointer(:double) do |value_pointer|
            gen = Wrapper.FirstCube(native_manager, bdd, cube_pointer, value_pointer)
            begin
              yield cube(cube_pointer.read_pointer.read_array_of_int(size))
            end until Wrapper.NextCube(gen, cube_pointer, value_pointer)==0
          end
        end
      ensure
        Wrapper.GenFree(gen) if gen
      end

      # Returns an array with each cube satisfying `bdd`.
      def all_cubes(bdd)
        each_cube(bdd).to_a
      end

    end # module BDD
  end # module Interface
end # module Cudd
