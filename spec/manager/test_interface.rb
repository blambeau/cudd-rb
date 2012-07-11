require 'spec_helper'
module Cudd
  describe Manager, "#interface" do

    it 'serves itself as Root interface' do
      with_manager do |m|
        i = m.interface(:Root)

        i.should be_a(Manager)
        i.should be_root_manager

        i.should be_a(Interface::Root)
        i.should eq(m)
      end
    end

    it 'serves the BDD interface without error' do
      with_manager do |m|
        manager = m
        i = m.interface(:BDD)

        i.should be_a(Manager)
        i.should_not be_root_manager

        i.should be_a(Interface::Root)
        i.should be_a(Interface::BDD)
      end
    end

    it 'always serves the same Root' do
      with_manager do |m|
        root1 = m.interface(:Root)
        bdd1  = m.interface(:BDD)
        bdd1.interface(:Root).should eq(root1)
      end
    end

    it 'always serves the same names interface' do
      with_manager do |m|
        bdd1 = m.interface(:BDD)
        bdd2 = m.interface(:BDD)
        bdd3 = bdd1.interface(:BDD)
        bdd1.should eq(bdd2)
        bdd2.should eq(bdd3)
      end
    end

  end
end
