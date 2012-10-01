require "cached_belongs_to/version"
require 'active_record'

module CachedBelongsTo
  module ClassMethods
    def cached_belongs_to(*args)
      caches = Array(args[1].delete(:caches))
      klass  = args[0]

      belongs_to(*args)
      children_hook_name = "cached_belongs_to_#{name.underscore}_after_save".to_sym
      create_cached_belongs_to_child_hooks(caches, klass, children_hook_name)
      create_cached_belongs_to_parent_hooks(caches, klass, children_hook_name)
    end

    def create_cached_belongs_to_child_hooks(*args, caches, klass, children_hook_name)
      define_method children_hook_name do
        caches.each do |attr|
          send("#{klass}_#{attr}=", send(klass).send(attr)) if send(klass)
        end
      end

      before_save children_hook_name
    end

    def create_cached_belongs_to_parent_hooks(caches, parent_class_name, children_hook_name)
      method_name = "cached_belongs_to_#{parent_class_name}_after_save".to_sym
      has_many_association = self.name.underscore.pluralize.to_sym
      parent_class = parent_class_name.to_s.camelize.constantize

      parent_class.send(:define_method, method_name) do
        send(has_many_association).reload.each do |child|
          caches.each do |attr|
            child.send(children_hook_name)
            child.save
          end
        end
      end

      parent_class.send(:after_save, method_name)
    end
  end
end

ActiveRecord::Base.extend(CachedBelongsTo::ClassMethods)
