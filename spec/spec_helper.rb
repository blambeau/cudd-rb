$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'cudd-rb'

require_relative 'shared/a_bdd'

module Helpers

  def with_manager(&bl)
    Cudd.manager(&bl)
  end

  def bdd_interface
    @bdd_interface ||= Cudd.manager.interface(:BDD)
  end

  def one
    bdd_interface.one
  end

  def zero
    bdd_interface.zero
  end

  def x
    bdd_interface.ith_var(0)
  end

  def y
    bdd_interface.ith_var(1)
  end

  def z
    bdd_interface.ith_var(2)
  end

  def assignment(values)
    bdd_interface.assignment(values)
  end

end

RSpec.configure do |c|
  c.include(Helpers)
  c.after(:all){ bdd_interface.close if @bdd_interface }
end
