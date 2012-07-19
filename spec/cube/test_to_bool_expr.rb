require 'spec_helper'
module Cudd
  describe Cube, 'to_bool_expr' do

    subject{ c.to_bool_expr }

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

  end
end