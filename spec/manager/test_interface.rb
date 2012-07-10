module Cudd
  describe Manager, "#interface" do

    it 'serves the BDD interface without error' do
      with_manager do |m|
        manager = m
        i = m.interface(:BDD)
        i.should be_a(Manager)
        i.should be_a(Interface::BDD)
      end
    end

  end
end