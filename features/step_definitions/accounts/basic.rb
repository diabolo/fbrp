Given /^I am an anonymous user$/ do
  get '/logout'
  #TODO check user is logged out
end

Given /I am on the signup page/ do 
  visits "/signup"   
end
                
Given "no $resource with $attr: '$val' exists" do |resource, attr, val|
  klass, instance = parse_resource_args resource
  klass.destroy_all(attr.to_sym => val)
  instance = find_resource resource, attr.to_sym => val
  instance.should be_nil
  keep_instance! resource, instance
end

When /^I register an account as (.*)/ do |name|
  @user = User.generate
  put register_path(:user => @user)
end



# Then "$actor should see a <$container> containing a $type $attribute" do |_, container, attributes|


Then "$actor should see a <$container> containing a $attributes" do |_, container, attributes|
   attributes = attributes.to_hash_from_story
   response.should have_tag(container) do
     attributes.each do |tag, label|
       case tag
       when "textfield" then with_tag "input[type='text']";     with_tag("label", label)
       when "password"  then with_tag "input[type='password']"; with_tag("label", label)
       when "submit"    then with_tag "input[type='submit'][value='#{label}']"
       else with_tag tag, label
       end
     end
   end
 end


