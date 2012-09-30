require 'spec_helper'

describe CachedBelongsTo do
  let(:book_class) do
    klass = Class.new(ActiveRecord::Base)
    Object.const_set 'PostgreSQLAdapter', klass
    klass
  end

  it "Adds the cached_belongs_to class method to ActiveRecord models" do
    book_class.should respond_to(:cached_belongs_to)
  end
end
