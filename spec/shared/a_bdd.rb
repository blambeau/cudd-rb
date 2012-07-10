shared_examples_for "a BDD" do

  it 'is a FFI::Pointer' do
    subject.should be_a(FFI::Pointer)
  end

  it 'includes the Cudd::BDD module' do
    subject.should be_a(Cudd::BDD)
  end

  it 'has a manager, which is a Cudd::Manager' do
    subject.manager.should be_a(Cudd::Manager)
  end

end