module Cudd
  module Interface
    module BDD

      ### BDD CREATION ###################################################################

      # Coerce `pointer` to a BDD
      def bdd(pointer, &error_handler)
        return pointer if Cudd::BDD===pointer
        if FFI::Pointer::NULL==pointer
          raise Cudd::Error, "NULL pointer for BDD" unless error_handler
          error_handler.call
        end
        m = self
        pointer.tap do |p|
          p.instance_eval{ @manager = m }
          p.extend(Cudd::BDD)
        end
      end

      ### REFERENCE COUNT ################################################################

      # @see Cudd_Ref
      def ref(f)
        Wrapper.Ref(f)
        f
      end

      # @see Cudd_Deref, Cudd_RecursiveDeref
      #
      # Uses `Cudd_RecursiveDeref` if `recursive` is true (defauts), decreasing
      # reference counts of all children of `f`. Uses `Cudd_Deref` otherwise
      # (use only if your are sure).
      def deref(f, recursive = false)
        recursive ? Wrapper.RecursiveDeref(native_manager, f) : Wrapper.Deref(f)
        f
      end

      ### MEMORY MANAGEMENT ##############################################################

      def reduce_heap(heuristic, minsize)
        Wrapper.ReduceHeap(native_manager, heuristic, minsize)
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

      # @see Cudd_ReadSize
      def size
        Wrapper.ReadSize(native_manager)
      end
      alias :bdd_count :size

      # @see Cudd_NodeReadIndex
      def var_index(bdd)
        return nil if bdd==zero or bdd==one
        Wrapper.NodeReadIndex(bdd)
      end

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

      # @see Cudd_bddNewVar
      def new_var(name = nil)
        var = bdd Wrapper.bddNewVar(native_manager)
        var_names[var_index(var)] = name if name
        var
      end

      # Creates new variables and returns them as an Array.
      #
      # Example:
      #   x, y, z = manager.new_vars(3)
      #   x, y, z = manager.new_vars(:x, :y, :z)
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

      # @see Cudd_ReadOne
      def one
        @one ||= bdd Wrapper.ReadOne(native_manager)
      end

      # @see Cudd_ReadLogicZero
      def zero
        @zero ||= bdd Wrapper.ReadLogicZero(native_manager)
      end

      # @see Cudd_IsComplement
      def is_complement?(bdd)
        (bdd.address & 1)==1
      end

      ### BOOLEAN ALGEBRA ################################################################

      # @see Cudd_bddIte
      def ite(f, g, h)
        bdd Wrapper.bddIte(native_manager, f, g, h)
      end

      # @see Cudd_bddNot
      def not(f)
        bdd Wrapper.bddNot(native_manager, f)
      end

      # @see Cudd_bddAnd
      def and(f, g)
        bdd Wrapper.bddAnd(native_manager, f, g)
      end

      # @see Cudd_bddOr
      def or(f, g)
        bdd Wrapper.bddOr(native_manager, f, g)
      end

      # @see Cudd_bddNand
      def nand(f, g)
        bdd Wrapper.bddNand(native_manager, f, g)
      end

      # @see Cudd_bddNor
      def nor(f, g)
        bdd Wrapper.bddNor(native_manager, f, g)
      end

      # @see Cudd_bddXor
      def xor(f, g)
        bdd Wrapper.bddXor(native_manager, f, g)
      end

      # @see Cudd_bddXnor
      def xnor(f, g)
        bdd Wrapper.bddXnor(native_manager, f, g)
      end

      ### SUPPORT ########################################################################

      # @see Cudd_Support
      def support(bdd)
        Wrapper.Support(native_manager, bdd)
      end

      ### COFACTOR & GENERALIZED COFACTOR ################################################

      # @see Cudd_Cofactor
      def cofactor(bdd, cube)
        with_bdd_cube(cube) do |c|
          bdd Wrapper.Cofactor(native_manager, bdd, c)
        end
      end

      # @see Cudd_bddRestrict
      def restrict(f, g)
        with_bdd_cube(g) do |c|
          bdd Wrapper.bddRestrict(native_manager, f, c)
        end
      end

      ### ABSTRACTION ####################################################################

      # @see Cudd_bddExistAbstract
      def exist_abstract(bdd, cube)
        with_bdd_cube(cube) do |c|
          bdd Wrapper.bddExistAbstract(native_manager, bdd, c)
        end
      end
      alias :exist :exist_abstract

      # @see Cudd_bddUnivAbstract
      def univ_abstract(bdd, cube)
        with_bdd_cube(cube) do |c|
          bdd Wrapper.bddUnivAbstract(native_manager, bdd, c)
        end
      end
      alias :univ :univ_abstract
      alias :forall :univ_abstract

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

      # @see Cudd_CubeArrayToBdd
      def cube2bdd(cube_array)
        with_ffi_pointer(:int, cube_array.size) do |ptr|
          ptr.write_array_of_int(cube_array)
          bdd Wrapper.CubeArrayToBdd(native_manager, ptr) do
            raise Cudd::Error, "Cudd_CubeArrayToBdd failed on `#{cube_array.inspect}`"
          end
        end
      end

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
      def bdd2dnf(bdd, operators = {:not => :'!', :or => :'|', :and => :'&'})
        return "true"  if bdd==one
        return "false" if bdd==zero
        buf, size = "", 0
        each_cube(bdd) do |cube|
          size += 1
          buf << " #{operators[:or]} " unless buf.empty?
          buf << "(" << cube.to_dnf(operators) << ")"
        end
        size == 1 ? buf[1...-1] : buf
      end

      ### EVALUATION & SATISFIABILITY ####################################################

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

      # Returns the first cube satisfying `bdd`.
      def one_cube(bdd)
        each_cube(bdd).first
      end

      # @see Cudd_ForEachCube
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

      # Returns an array with all cubes satisfying `bdd`.
      def all_cubes(bdd)
        each_cube(bdd).to_a
      end

    private

      # Yields the block with a cube encoded by a BDD. If the latter must be
      # built, it is automatically referenced then dereferenced after the block
      # has been yield.
      def with_bdd_cube(cube)
        if cube.is_a?(Cudd::BDD)
          yield(cube)
        else
          cube = cube(cube, :bdd).ref
          res = yield(cube)
          cube.deref
          res
        end
      end

    end # module BDD
  end # module Interface
end # module Cudd
