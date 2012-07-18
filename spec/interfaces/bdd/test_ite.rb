require 'spec_helper'
module Cudd
  describe Interface::BDD, 'ite' do

    subject{ bdd_interface.ite(x,y,z) }

    it_behaves_like "a BDD"

    it 'is equal (x & y) | (!x & z)' do
      subject.should eq((x & y) | (!x & z))
    end

    it 'is equal to x.ite(y, z)' do
      subject.should eq(x.ite(y,z))
    end

  end
end
