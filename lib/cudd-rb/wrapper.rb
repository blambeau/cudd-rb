module Cudd
  module Wrapper
    extend FFI::Library
    ffi_lib ['cudd', 'libcudd'] + Dir[File.expand_path('../../../ext/*', __FILE__)]

    attach_function :Init, :Cudd_Init, [:uint, :uint, :uint, :uint, :ulong], :pointer
    attach_function :Quit, :Cudd_Quit, [:pointer], :void

    attach_function :Ref,   :Cudd_Ref, [:pointer], :void
    attach_function :Deref, :Cudd_Deref, [:pointer], :void
    attach_function :RecursiveDeref, :Cudd_RecursiveDeref, [:pointer, :pointer], :void

    attach_function :ReadZero, :Cudd_ReadZero, [ :pointer ], :pointer
    attach_function :ReadOne,  :Cudd_ReadOne,  [ :pointer ], :pointer

    attach_function :bddIthVar, :Cudd_bddIthVar, [ :pointer, :int ], :pointer
    attach_function :bddNewVar, :Cudd_bddNewVar, [ :pointer ], :pointer
    attach_function :bddNot,    :Cudd_bddNot,    [ :pointer, :pointer ], :pointer
    attach_function :bddAnd,    :Cudd_bddAnd,    [ :pointer, :pointer, :pointer ], :pointer
    attach_function :bddOr,     :Cudd_bddOr,     [ :pointer, :pointer, :pointer ], :pointer

    attach_function :ref,   :Cudd_Ref,   [ :pointer ], :void
    attach_function :deref, :Cudd_Deref, [ :pointer ], :void

  end # module Wrapper
end # module Cudd
