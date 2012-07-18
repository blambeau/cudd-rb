require 'cudd-rb'

class Eqn

  attr_reader :interface, :consistency, :solutions

  def initialize(interface)
    @interface = interface
    @eqn = interface.zero
  end

  def add_equation(left, right)
    oldeqn = @eqn
    @eqn = @eqn.or(left.xor(right))
    [left, right, oldeqn].each{|x| x.deref}
  end

  def solve(unknowns)
    ycube = unknowns.inject(interface.one){|memo,y| (memo & y) }
    ysize = unknowns.size
    FFI::MemoryPointer.new(:pointer, 1) do |indexes|
      solutions   = FFI::MemoryPointer.new(:pointer, ysize)
      consistency = Cudd::Wrapper.SolveEqn(interface.native_manager, @eqn, ycube, solutions, indexes, ysize)
      Cudd::Wrapper.VerifySol(interface.native_manager, @eqn, solutions, indexes.read_pointer, ysize)
      @solutions   = solutions.read_array_of_pointer(ysize).map{|sol| interface.bdd(sol)}
      @consistency = interface.bdd(consistency)
    end
  end

end

Cudd.manager do |manager|
  bdd = manager.interface(:BDD)
  
  eqn = Eqn.new(bdd)

  p, g, q = bdd.new_vars(3)
  suspected, diagnosed, removed = bdd.new_vars(3)

  eqn.add_equation p,     suspected
  eqn.add_equation q,     removed
  eqn.add_equation p & g, suspected & diagnosed
  eqn.add_equation g,     diagnosed
  
  eqn.solve([p, g, q])

  puts "Consistency condition ------------"
  puts eqn.consistency.each_sat.map(&:to_a).join(" or ")

  puts "Solutions ------------"
  eqn.solutions.each do |sol|
    puts sol.each_sat.map(&:to_s).join(" or ")
  end
end

