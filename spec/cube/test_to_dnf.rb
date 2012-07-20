require 'spec_helper'
module Cudd
  describe Cube, 'to_dnf' do

    subject{ c.to_dnf }

    before{ x; y; z  }

    context 'on singleton' do
      let(:c){ cube(x => true) }

      it 'uses default names' do
        subject.should eq("v0")
      end
    end

    context 'on negative singleton' do
      let(:c){ cube(x => false) }

      it 'uses default names' do
        subject.should eq("!v0")
      end
    end

    context 'on unnamed variables' do
      let(:c){ cube(x => true, y => false) }

      it 'uses default names' do
        subject.should eq("v0 & !v1")
      end
    end

    context 'on named variables' do
      let(:u){ bdd_interface.new_var(:u) }
      let(:v){ bdd_interface.new_var(:v) }
      let(:c){ cube(u => true, v => false) }

      it 'uses provided names' do
        subject.should eq("u & !v")
      end
    end

    context 'on variables that respond to to_dnf' do
      let(:var){ Object.new }
      let(:u){ bdd_interface.new_var(var) }
      let(:c){ cube(u => true) }

      it 'uses provided names' do
        def var.to_dnf; "foo"; end
        subject.should eq("foo")
      end
    end

  end
end