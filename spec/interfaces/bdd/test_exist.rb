require 'spec_helper'
module Cudd
  describe Interface::BDD, 'exist' do

    subject{ (x & y).exist(g) }

    context 'when g is a Hash' do
      let(:g){ {x => true} }

      it_behaves_like "a BDD"

      it{ should eq(y) }
    end

    context 'when g is a cube bdd' do
      let(:g){ x }

      it_behaves_like "a BDD"

      it { should eq(y) }
    end

  end
end
