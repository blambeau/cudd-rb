require 'spec_helper'
module Cudd
  describe Interface::BDD, 'restrict' do

    subject{ f.restrict(g) }

    context 'when g is a cube' do
      let(:f){ x & y   }
      let(:g){ {x => true} }

      it_behaves_like "a BDD"

      it{ should eq(f.cofactor(g)) }
    end

    context 'when it is a complex bdd' do
      let(:f){ (x & y) | z }
      let(:g){ x.xor(y)    }

      it_behaves_like "a BDD"

      it { should eq(z) }
    end

  end
end
