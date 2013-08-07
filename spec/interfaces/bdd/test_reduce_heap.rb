require 'spec_helper'
module Cudd
  describe Interface::BDD, 'ReduceHeap' do

    subject{ bdd_interface.reduce_heap(heuristic, minsize) }

    context 'with random heuristic an no minsize' do
      let(:heuristic){ :random }
      let(:minsize){ 0 }

      before do
        bdd_interface.and(x,y)
      end

      it 'should work' do
        subject
        subject.should eq(1)
      end
    end

  end
end
