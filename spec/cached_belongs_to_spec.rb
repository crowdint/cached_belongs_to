require 'spec_helper'

describe CachedBelongsTo do
  let(:book_class) do
    klass = Class.new(ActiveRecord::Base)
    suppress_warnings { Object.const_set 'Book', klass }
    klass
  end

  let(:author_class) do
    klass = Class.new(ActiveRecord::Base)
    suppress_warnings { Object.const_set 'Author', klass }
    klass
  end

  before do
    author_class
  end

  it "Adds the cached_belongs_to class method to ActiveRecord models" do
    book_class.should respond_to(:cached_belongs_to)
  end

  context "cached_belongs_to" do
    before do
      book_class.send(:cached_belongs_to, :author, { :caches => :name })
    end

    it "creates the belongs_to association as usual" do
      book_class.new.should respond_to(:author)
    end

    it "defines the cached_belongs_to_book_after_save" do
      book_class.new.should respond_to(:cached_belongs_to_book_after_save)
    end

    it "defines the cached_belongs_to_author_after_save" do
      author_class.new.should respond_to(:cached_belongs_to_author_after_save)
    end
  end

  context "cached_belongs_to_book_after_save" do
    before do
      book_class.send(:cached_belongs_to, :author, { :caches => :name })
    end

    it "assigns all the cached values from the parent association to the cached attributes" do
      author = author_class.new :name => 'John Mellencamp'
      book   = book_class.new
      book.author = author

      book.stub(:author).and_return author

      book.cached_belongs_to_book_after_save
      book.author_name.should eq author.name
    end
  end

  context "cached_belongs_to_author_after_save" do
    before do
      book_class.send(:cached_belongs_to, :author, { :caches => :name })
      author_class.send(:has_many, :books)
    end

    it "assigns all the cached values from the parent association to the cached attributes" do
      author = author_class.new :name => 'John Mellencamp'
      book   = book_class.new

      author.stub_chain(:books, :reload).and_return([ book ])
      book.should_receive(:cached_belongs_to_book_after_save)
      book.should_receive :save

      author.cached_belongs_to_author_after_save
    end
  end
end
