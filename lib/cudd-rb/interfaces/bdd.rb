module Cudd
  module Interface
    module BDD

      ### BDD CREATION ###################################################################

      def bdd(pointer)
        return pointer if Cudd::BDD===pointer
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
        if recursive
          Wrapper.RecursiveDeref(native_manager, f)
        else
          Wrapper.Deref(f)
        end
        f
      end

      ### VARS ###########################################################################

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
      def new_var
        bdd Wrapper.bddNewVar(native_manager)
      end

      # Creates `count` new variables and returns them as an Array.
      #
      # Example:
      #   x, y, z = manager.new_vars(3)
      #
      def new_vars(count)
        (0...count).map{ new_var }
      end

      ### CONSTANTS ######################################################################

      # Returns the bdd ONE
      #
      # @see Cudd_ReadOne
      def one
        bdd Wrapper.ReadOne(native_manager)
      end

      # Returns the bdd ZERO
      #
      # @see Cudd_ReadLogicZero
      def zero
        bdd Wrapper.ReadLogicZero(native_manager)
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

      ### COERCIONS to CubeArray #########################################################

      TRUTH_VALUES_TO_012 = {true => 1, false => 0, nil => 2, 1 => 1, 0 => 0}

      # Coerces `arg` to a cube array
      def cube(arg)
        return bdd2cube(arg) if arg.is_a?(Cudd::BDD)
        cube = Array.new(size, 2)
        case arg
        when Array
          (0...size).each do |i|
            cube[i] = TRUTH_VALUES_TO_012[arg[i]] || 2
          end
        when Hash
          arg.each_pair do |k,v|
            next unless truth012 = TRUTH_VALUES_TO_012[v]
            cube[k.is_a?(Cudd::BDD) ? k.index : k.to_i] = truth012
          end
        else
          raise ArgumentError, "Unable to coerce `#{arg}` to a cube"
        end
        cube
      end

      # Converts a cube array to a bdd
      #
      # @see Cudd_CubeArrayToBdd
      def cube2bdd(cube_array)
        with_ffi_pointer(:int, cube_array.size) do |ptr|
          ptr.write_array_of_int(cube_array)
          pointer = Wrapper.CubeArrayToBdd(native_manager, ptr)
          raise "Cudd_CubeArrayToBdd failed" unless pointer
          bdd pointer
        end
      end

      # Converts a bdd to a cube array
      #
      # @see Cudd_BddToCubeArray
      def bdd2cube(bdd)
        s = size
        with_ffi_pointer(:int, s) do |ptr|
          res = Wrapper.BddToCubeArray(native_manager, bdd, ptr)
          raise "Cudd_BddToCubeArray failed" unless res==1
          ptr.read_array_of_int(s)
        end
      end

      ### EVALUATION & SATISFIABILITY ####################################################

      # Returns the value of a BDD for a given variable assignment `input`.
      #
      # @see Cudd_Eval
      def eval(f, cube)
        with_ffi_pointer(:int, size) do |ptr|
          ptr.write_array_of_int(cube(cube))
          bdd Wrapper.Eval(native_manager, f, ptr)
        end
      end

      # Returns true if `bdd` is satisfiable, false otherwise.
      def satisfiable?(bdd)
        !(zero == bdd)
      end

      # Returns true if `bdd` is satisfied by a given assignment, false otherwise.
      def satisfied?(bdd, cube)
        one == eval(bdd, cube(cube))
      end

      # Returns one satisfying assignment for `bdd`.
      def one_sat(bdd)
        each_sat(largest_cube(bdd)).to_a.first
      end

      # Yields each assignment that satisfies `bdd` in turn.
      def each_sat(bdd)
        return self.enum_for(:each_sat, bdd) unless block_given?
        return unless satisfiable?(bdd)
        size, gen = self.size, nil
        with_ffi_pointer(:pointer) do |cube_pointer|
          with_ffi_pointer(:double) do |value_pointer|
            gen = Wrapper.FirstCube(native_manager, bdd, cube_pointer, value_pointer)
            begin
              yield cube_pointer.read_pointer.read_array_of_int(size)
            end until Wrapper.NextCube(gen, cube_pointer, value_pointer)==0
          end
        end
      ensure
        Wrapper.GenFree(gen) if gen
      end

      # Returns an array with each assignement satisfying `bdd`.
      def all_sat(bdd)
        each_sat(bdd).to_a
      end

      # Returns the largest cube of `bdd` as a BDD
      #
      # @see Cudd_LargestCube
      def largest_cube(bdd)
        bdd Wrapper.LargestCube(native_manager, bdd, nil)
      end

    end # module BDD
  end # module Interface
end # module Cudd
