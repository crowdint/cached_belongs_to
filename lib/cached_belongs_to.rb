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

      method_name = "cached_belongs_to_#{name.underscore}_after_save".to_sym
      define_method method_name do
        caches.each do |attr|
          send("#{klass}_#{attr}=", send(klass).send(attr)) if send(klass)
        end
      end

      before_save method_name
    end
  end
end

ActiveRecord::Base.extend(CachedBelongsTo::ClassMethods)
