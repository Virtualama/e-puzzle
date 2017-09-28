describe MetaRepo do

  let(:any_class){
    Class.new do
      def initialize x
        @value = x.to_h
      end

      def to_h
        @value
      end
    end
  }

  let(:any_collection){
    double('collection')
  }

  it 'accepts any class to map & collection to store' do
    created_repo = MetaRepo.for any_class, any_collection

    expect(created_repo.collection).to eq(any_collection)
    expect(created_repo.mapped_class).to eq(any_class)
  end

  it 'cannot be instantiated, they are just classes' do
    created_repo = MetaRepo.for any_class, any_collection
    expect {
      created_repo.new
    }.to raise_error(StandardError, /cannot be instantiated/)
  end


  it 'save method is delegated to collection' do
    created_repo = MetaRepo.for any_class, any_collection

    object_to_save = double('instance')
    object_serialization = { param: 'value' }
    expect(object_to_save).to receive(:to_h).and_return(object_serialization)
    expect(any_collection).to receive(:insert_one).with(object_serialization)

    created_repo.save object_to_save
  end

  it 'find method is delegated to collection' do
    empty_array = []
    expect(any_collection).to receive(:find).and_return(empty_array)

    created_repo = MetaRepo.for any_class, any_collection

    expect(created_repo.find({})).to eq(empty_array)
  end


  it 'found elements are mapped to repo class instances' do
    repo_contents = [
      { key: :any },
      { key: :object },
      { key: :in },
      { key: :repo }
    ]

    expect(any_collection).to receive(:find).and_return(repo_contents)

    created_repo = MetaRepo.for any_class, any_collection

    found_elements = created_repo.find({})

    expect(found_elements.length).to eq(repo_contents.length)
    found_elements.all?{ |x|
      expect(x).to be_a(any_class)
    }
  end

  it 'update method is delegated to collection' do
    expect(any_collection).to receive(:update_one).with({id: :id_to_update}, {'$set' => :changes}).and_return(:nothing)

    created_repo = MetaRepo.for any_class, any_collection

    expect(created_repo.update(:id_to_update, :changes)).to eq(:nothing)
  end

  it 'delete method is delegated to collection' do
    expect(any_collection).to receive(:delete_one).with(id: :id_to_delete).and_return(:deleted_element)

    created_repo = MetaRepo.for any_class, any_collection

    expect(created_repo.delete(:id_to_delete)).to eq(:deleted_element)
  end

  it 'all is an alias to find all' do
    created_repo = MetaRepo.for any_class, any_collection

    expect(created_repo).to receive(:find).with({})

    created_repo.all
  end

  it 'clear method is delegated to collection' do
    expect(any_collection).to receive(:drop)

    created_repo = MetaRepo.for any_class, any_collection

    created_repo.clear
  end

  it 'can have defined aditional methods upon creation' do
    created_repo = MetaRepo.for any_class, any_collection do |created_repo|
      meth :any_method do |any_param|
      end
    end

    expect(created_repo.methods).to include(:any_method)
  end

  it 'can have defined aditional methods after creation' do
    created_repo = MetaRepo.for any_class, any_collection

    created_repo.meth :any_method do |any_param|
    end

    expect(created_repo.methods).to include(:any_method)
  end

end
