require "cached_belongs_to/version"
require 'active_record'

module CachedBelongsTo
  module ClassMethods
    def cached_belongs_to(*args)
      caches = Array(args[1].delete(:caches))
      belongs_to(*args)
      create_cached_belongs_to_hooks(*args, caches)
    end

    def create_cached_belongs_to_hooks(*args, caches)
      klass = args[0]
      cached_attributes = args[1][:caches]


      define_method "cached_belongs_to_#{name.underscore}_after_save" do
        caches.each do |attr|
          send("#{klass}_#{attr}=", send(klass).send(attr)) if send(klass)
        end
        save
      end
    end
  end
end

ActiveRecord::Base.extend(CachedBelongsTo::ClassMethods)
