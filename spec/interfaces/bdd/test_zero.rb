module Cudd
  describe Interface::BDD, 'zero' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      interface.close if interface
    end

    subject{ interface.zero }

    it_behaves_like "a BDD"

    it 'is zero' do
      subject.should be_zero
    end

    it 'is not one' do
      subject.should_not be_one
    end
  end
end