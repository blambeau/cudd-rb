require 'cudd-rb'

Cudd.manager do |m|
  bdd = m.interface(:BDD)

  x = bdd.new_var
  y = bdd.new_var

  #l = FFI::MemoryPointer.new(:int).write_array_of_int([0])
  Cudd::Wrapper.ShortestPath(bdd.native_manager, x, nil, nil, nil)
end
