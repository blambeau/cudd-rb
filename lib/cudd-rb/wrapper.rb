module Cudd
  module Wrapper
    extend FFI::Library
    ffi_lib ['cudd', 'libcudd'] + Dir[File.expand_path('../../../ext/*', __FILE__)]

    ONE_POINTER    = [ :pointer ]
    TWO_POINTERS   = [ :pointer, :pointer ]
    THREE_POINTERS = [ :pointer, :pointer, :pointer ]
    FOUR_POINTERS  = [ :pointer, :pointer, :pointer, :pointer ]
    FIVE_POINTERS  = [ :pointer, :pointer, :pointer, :pointer, :pointer ]

    def self.cudd_function(name, signature, return_type = :pointer)
      attach_function name, :"Cudd_#{name}", signature, return_type
    end

    cudd_function :Init,           Array.new(4, :uint) << :ulong
    cudd_function :Quit,           ONE_POINTER,  :void

    cudd_function :Ref,            ONE_POINTER,  :void
    cudd_function :Deref,          ONE_POINTER,  :void
    cudd_function :RecursiveDeref, TWO_POINTERS, :void

    cudd_function :ReadSize,       ONE_POINTER,  :int
    cudd_function :NodeReadIndex,  ONE_POINTER,  :int

    cudd_function :ReadOne,        ONE_POINTER
    cudd_function :ReadZero,       ONE_POINTER
    cudd_function :ReadLogicZero,  ONE_POINTER

    cudd_function :bddIthVar,      [ :pointer, :int ]
    cudd_function :bddNewVar,      ONE_POINTER
    cudd_function :bddIte,         FOUR_POINTERS
    cudd_function :bddNot,         TWO_POINTERS
    cudd_function :bddAnd,         THREE_POINTERS
    cudd_function :bddOr,          THREE_POINTERS
    cudd_function :bddNand,        THREE_POINTERS
    cudd_function :bddNor,         THREE_POINTERS
    cudd_function :bddXor,         THREE_POINTERS
    cudd_function :bddXnor,        THREE_POINTERS

    cudd_function :Support,        TWO_POINTERS

    cudd_function :BddToCubeArray, THREE_POINTERS, :int
    cudd_function :CubeArrayToBdd, TWO_POINTERS

    cudd_function :Eval,           THREE_POINTERS
    cudd_function :FirstCube,      FOUR_POINTERS
    cudd_function :NextCube,       THREE_POINTERS, :int
    cudd_function :GenFree,        ONE_POINTER, :int

  end # module Wrapper
end # module Cudd
