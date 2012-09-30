Given /^model "(.*?)" exists with attributes:$/ do |model_class_name, attributes|
  klass = Class.new(ActiveRecord::Base)
  Object.const_set model_class_name, klass

  ActiveRecord::Schema.define(:version => 0) do
    create_table model_class_name.tableize, :force => true do |t|
      attributes.hashes.each do |row|
        t.send(row["type"], row["attribute"])
      end
    end
  end
end

Given /^a (.*?) exists:$/ do |model_name, table|
  @models ||= {}
  @models[model_name] = model_name.constantize.new
  table.rows_hash.each do |attribute, value|
    @models[model_name].send("#{attribute}=", value)
  end
  @models[model_name].save!
end

Given /^that (.*?) belongs to that (.*?)$/ do |child, parent|
  @models[parent].send(child.underscore.pluralize).send(:push, @models[child])

  #@models[child].send("#{parent.underscore}=", @models[parent])
end

When /^I save the (.*?)$/ do |model_name|
  @models[model_name].save!
end

When /^I change the (.*?)'s name to "(.*?)"$/ do |model_name, new_name|
  @models[model_name].name = new_name
end

Given /^(.*?) has many (.*?)$/ do |parent, child|
  parent.constantize.send(:has_many, child.underscore)
end
