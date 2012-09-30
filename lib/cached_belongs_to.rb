require "cached_belongs_to/version"
require 'active_record'

module CachedBelongsTo
  module ClassMethods
    def cached_belongs_to(*args)
    end
  end
end

ActiveRecord::Base.extend(CachedBelongsTo::ClassMethods)
