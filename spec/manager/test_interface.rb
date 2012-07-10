module Cudd
  describe Manager, "#interface" do

    it 'serves itself as Root interface' do
      with_manager do |m|
        i = m.interface(:Root)
        i.should be_a(Manager)
        i.should be_a(Interface::Root)
        i.should eq(m)
      end
    end

    it 'serves the BDD interface without error' do
      with_manager do |m|
        manager = m
        i = m.interface(:BDD)
        i.should be_a(Manager)
        i.should be_a(Interface::Root)
        i.should be_a(Interface::BDD)
      end
    end

  end
end