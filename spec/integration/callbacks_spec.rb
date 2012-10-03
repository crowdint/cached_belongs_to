require 'spec_helper'

describe "Callbacks" do
  before do
    klass = Class.new(ActiveRecord::Base)
    suppress_warnings { Object.const_set 'Author', klass }

    klass = Class.new(ActiveRecord::Base)
    suppress_warnings { Object.const_set 'Book', klass }

    Book.send(:cached_belongs_to, :author, :caches => :name)
    Author.send(:has_many, :books)

    @author = Author.create :name => 'John Mellencamp'
    @book = Book.create :title => 'Treasure Island'

    @author.books << @book
  end

  describe "child callback" do
    specify do
      @book.reload.author_name.should == 'John Mellencamp'
    end
  end

  describe "parent callback" do
    specify do
      @author.name = 'Dick Tracy'
      expect { @author.save; @book.reload }.to change(@book, :author_name).to('Dick Tracy')
    end
  end
end
