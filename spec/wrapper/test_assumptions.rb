module Cudd
  describe Wrapper do

    let(:manager){
      Wrapper.Init(0,0,Cudd::UNIQUE_SLOTS,Cudd::CACHE_SLOTS,0)
    }
    
    after do
      Wrapper.Quit(manager) if manager
    end

    it 'returns equal, yet different objects for multiple invocations to ReadZero' do
      x = Wrapper.ReadZero(manager)
      y = Wrapper.ReadZero(manager)
      x.should eq(y)
      x.object_id.should_not eq(y.object_id)
    end

    it 'returns equal, yet different objects for multiple invocations to ReadOne' do
      x = Wrapper.ReadOne(manager)
      y = Wrapper.ReadOne(manager)
      x.should eq(y)
      x.object_id.should_not eq(y.object_id)
    end

  end
end