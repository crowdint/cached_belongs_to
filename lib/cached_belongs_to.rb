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

      association = belongs_to(*args)
      children_callback_name = "cached_belongs_to_#{name.demodulize.underscore}_callback".to_sym
      create_cached_belongs_to_child_callbacks(caches, children_callback_name, association)
      create_cached_belongs_to_parent_callbacks(caches, children_callback_name, association)
    end

    private
    def create_cached_belongs_to_child_callbacks(caches, children_callback_name, association)
      klass = association.name
      define_method children_callback_name do
        caches.each do |attr|
          send("#{klass}_#{attr}=", send(klass).send(attr)) if send(klass)
        end
      end

      before_save children_callback_name
    end

    def create_cached_belongs_to_parent_callbacks(caches, children_callback_name, association)
      parent_class_name = association.name
      method_name = "cached_belongs_to_#{parent_class_name}_callback".to_sym
      has_many_association = self.name.demodulize.underscore.pluralize.to_sym
      # What is this? I don't even...
      parent_class = association.klass.name.constantize

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
