require 'spec_helper'

module Rankat
  class Author < ActiveRecord::Base
    has_many :books
  end

  class Book < ActiveRecord::Base
    cached_belongs_to :author, :caches => :name
  end
end

describe "Callbacks" do
  before do
    @author = Rankat::Author.create :name => 'John Mellencamp'
    @book = Rankat::Book.new :title => 'Treasure Island'
    @book.author = @author
    @book.save!

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
