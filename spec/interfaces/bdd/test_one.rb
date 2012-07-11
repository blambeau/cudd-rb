require 'spec_helper'
module Cudd
  describe Interface::BDD, 'one' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      interface.close if interface
    end

    subject{ interface.one }

    it_behaves_like "a BDD"

    it 'is one' do
      subject.should be_one
    end

    it 'is not zero' do
      subject.should_not be_zero
    end
  end
end
