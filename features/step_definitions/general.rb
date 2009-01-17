Given /there (?:is|are) (\d+)(?:\s*|\s*more\s*)(\S*)?$/ do |n, object|
  klass = object.singularize.classify.constantize
  n.to_i.times {klass.generate!}
  klass.count.should >= (n.to_i)
end

When /^I visit (.*)$/ do |url|
  visit url
end

Then /^I should see a confirmation$/ do
  response.should have_flash
  response.flash.keys == [:notice]
end

Then /^I should see an error$/ do
  response.should have_flash
  response.flash.keys == [:error]
end

Then /^I should see an error explanation$/ do 
  response.should have_tag("div.errorExplanation")
end

Then /^I should see a form$/ do 
  response.should have_tag("form")
end
