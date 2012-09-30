# CachedBelongsTo

Back in the 80's disk space was precious. That's why we came out with the term
"normalization" in the database.

While this concept is still valid, disk space has become ridicously cheap, and,
there's a lot of cases where performance is more important than disk space.

## Installation

Add this line to your application's Gemfile:

    gem 'cached_belongs_to'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cached_belongs_to

## Usage

Just use it as you would use `belongs_to`. Add the `:caches` option to specify the
fields in the association that you want to cache.

    #
    # table: authors
    #
    # name:string
    #
    class Author
      has_many :books
    end

    class Book
      cached_belongs_to :author, :caches => :name
    end

You will need a database field in the books table to hold the cached value:

    class AddCachedBelongsToBooks < ActiveRecord::Migration
      def change
        add_column :books, :author_name, :string
      end
    end

And, that's it. Everytime you hange the Author, it will come back and update
the cached fields on the Book model.

So, now on your views you can just call:

    book.author_name

And won't pay the price of loading the whole Author model in memory, nor the query
time.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
