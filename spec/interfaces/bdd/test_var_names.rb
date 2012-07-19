require 'spec_helper'
module Cudd
  describe Interface::BDD, 'var_names' do

    subject{ bdd_interface.var_names }

    context 'when no variables have been declared at all' do
      it{ should eq([]) }
    end

    context 'when some variables have been declared but not named' do
      before{ x; y }
      it{ should eq([ :v0, :v1 ]) }
    end

    context 'when some variables have even been named' do
      before{ 
        x; y
        bdd_interface.var_names = [ :x ]
      }
      it{ should eq([ :x, :v1 ]) }
    end

  end
end
