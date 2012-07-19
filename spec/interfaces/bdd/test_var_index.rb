require 'spec_helper'
module Cudd
  describe Interface::BDD, 'var_index' do

    it 'returns nil on zero' do
      zero.var_index.should be_nil
    end

    it 'returns nil on one' do
      one.var_index.should be_nil
    end

    it 'returns 0 on x' do
      x.var_index.should eq(0)
    end

    it 'returns 1 on y' do
      y.var_index.should eq(1)
    end

    it 'returns 2 on z' do
      z.var_index.should eq(2)
    end

  end
end
