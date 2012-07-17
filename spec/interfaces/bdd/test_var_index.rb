require 'spec_helper'
module Cudd
  describe Interface::BDD, 'var_index' do

    let(:interface){ Cudd.manager(:numVars => 2).interface(:BDD) }
    let(:x){ interface.ith_var(0) }
    let(:y){ interface.ith_var(1) }

    after do
      interface.close if interface
    end

    it 'returns 0 on x' do
      interface.var_index(x).should eq(0)
      x.var_index.should eq(0)
    end

    it 'returns 1 on y' do
      interface.var_index(y).should eq(1)
      y.var_index.should eq(1)
    end

  end
end
