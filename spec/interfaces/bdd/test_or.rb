require 'spec_helper'
module Cudd
  describe Interface::BDD, 'or' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      subject.deref
      interface.close if interface
    end

    let(:x){ interface.new_var }
    let(:y){ interface.new_var }

    subject{ interface.or(x,y) }

    it_behaves_like "a BDD"

    it 'is equal to (x | y)' do
      subject.should eq(x | y)
    end
  end
end
