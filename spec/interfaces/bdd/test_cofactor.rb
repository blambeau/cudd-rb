require 'spec_helper'
module Cudd
  describe Interface::BDD, 'cofactor' do

    subject{ (x & y).cofactor(cube) }

    context 'with x as cube' do
      let(:cube){ x }

      it_behaves_like "a BDD"

      it{ should eq(y) }
    end

    context 'with !x as cube' do
      let(:cube){ !x }

      it_behaves_like "a BDD"

      it{ should eq(zero) }
    end

    context 'with a {x => true} as cube' do
      let(:cube){ { x => true } }

      it_behaves_like "a BDD"

      it{ should eq(y) }
    end

  end
end
