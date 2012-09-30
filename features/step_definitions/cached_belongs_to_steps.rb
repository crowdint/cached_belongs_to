Given /^(.*?) cached_belongs_to (.*?) with cached: "(.*?)"$/ do |model1, model2, cached_attribute|
  model1.constantize.send(:cached_belongs_to, model2.underscore.to_sym, :caches => cached_attribute)
end

Then /^(.*?)'s author name should be "(.*?)"$/ do |model_name, author_name|
  @models[model_name].reload.author_name.should == author_name
end
