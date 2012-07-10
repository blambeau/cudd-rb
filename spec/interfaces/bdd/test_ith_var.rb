module Cudd
  describe Interface::BDD, 'ith_var' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      interface.close if interface
    end

    subject{ interface.ith_var(0) }

    it_behaves_like "a BDD"

    it 'is not one' do
      subject.should_not be_one
    end

    it 'is not zero' do
      subject.should_not be_zero
    end

    it 'is equal to itself' do
      subject.should eq(interface.ith_var(0))
    end

    it 'is not equal to another one' do
      subject.should_not eq(interface.ith_var(1))
    end
  end
end