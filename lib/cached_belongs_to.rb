require "cached_belongs_to/version"
require 'active_record'

module CachedBelongsTo
  module ClassMethods
    #
    # Creates a many to one association between two models. Works
    # exactly as ActiveRecord's belongs_to, except that it adds
    # caching to it.
    #
    # Usage:
    #
    #   class Book < ActiveRecord::Base
    #     cached_belongs_to :author, :caches => :name
    #   end
    #
    def cached_belongs_to(*args)
      caches = Array(args[1].delete(:caches))
      klass  = args[0]

      belongs_to(*args)
      children_callback_name = "cached_belongs_to_#{name.underscore}_callback".to_sym
      create_cached_belongs_to_child_callbacks(caches, klass, children_callback_name)
      create_cached_belongs_to_parent_callbacks(caches, klass, children_callback_name)
    end

    private
    def create_cached_belongs_to_child_callbacks(caches, klass, children_callback_name)
      define_method children_callback_name do
        caches.each do |attr|
          send("#{klass}_#{attr}=", send(klass).send(attr)) if send(klass)
        end
      end

      before_save children_callback_name
    end

    def create_cached_belongs_to_parent_callbacks(caches, parent_class_name, children_callback_name)
      method_name = "cached_belongs_to_#{parent_class_name}_callback".to_sym
      has_many_association = self.name.underscore.pluralize.to_sym
      parent_class = parent_class_name.to_s.camelize.constantize

      parent_class.send(:define_method, method_name) do
        send(has_many_association).reload.each do |child|
          caches.each do |attr|
            child.send(children_callback_name)
            child.save
          end
        end
      end

      parent_class.send(:after_save, method_name)
    end
  end
end

ActiveRecord::Base.extend(CachedBelongsTo::ClassMethods)
