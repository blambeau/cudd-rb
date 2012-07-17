require 'spec_helper'
module Cudd
  describe Interface::BDD, 'size' do

    after do
      interface.close if interface
    end
    subject{ interface.size }

    context 'when built without size' do
      let(:interface){ Cudd.manager.interface(:BDD) }

      it 'starts at zero by default' do
        subject.should eq(0)
      end

      it 'counts the number of declared variables' do
        interface.new_var
        interface.new_var
        subject.should eq(2)
      end
    end

    context 'when built with an initialize bdd size' do
      let(:interface){ Cudd.manager(:numVars => 10).interface(:BDD) }

      it 'starts at ten by default' do
        subject.should eq(10)
      end
    end

  end
end
