# Cached belongs_to

[![Build Status](https://secure.travis-ci.org/crowdint/cached_belongs_to.png)](http://travis-ci.org/crowdint/cached_belongs_to)

Back in the 80's disk space was precious. That's why we came out with table "normalization" for relational databases.

While this concept is still valid, disk space has become ridicously cheap, and,
there's a lot of cases where performance is more important than disk space.

## Can't you just use eager loading?

You could! But, eager loading still loads the models into memory. Such a memory waste, specially if the parent models are big.

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

# About the Author

[Crowd Interactive](http://www.crowdint.com) is an American web design and development company that happens to work in Colima, Mexico.
We specialize in building and growing online retail stores. We don’t work with everyone – just companies we believe in. Call us today to see if there’s a fit.
Find more info [here](http://www.crowdint.com)!
