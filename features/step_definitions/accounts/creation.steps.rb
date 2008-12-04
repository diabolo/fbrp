When /^I fill in (.*) signup details$/ do |user| 
  fill_in(:login, :with => user) 
  fill_in(:email, :with => user + '@example.com') 
  fill_in(:password, :with => user + 'pass') 
  fill_in('user[password_confirmation]', :with => user + 'pass')
end           
  
When /^I signup as (\w*)$/ do |user| 
  When "I visit signup"
  When "I fill in #{user} signup details" 
  click_button
end

When /^I signup as (.*) with wrong confirmation$/ do |user|
  When "I visit signup"
  When "I fill in #{user} signup details" 
  fill_in('user[password_confirmation]', :with => 'poopypoop')
  click_button
end           

When /^I signup as (.*) without (.*)$/ do |user, field|
  When "I visit signup"
  When "I fill in #{user} signup details" 
  field == 'password_confirmation' ? fill_in('user[password_confirmation]', :with => '') : fill_in(field, :with => '')  
  click_button
end

Then /^there should be an account for Fred$/ do
  User.count.should == 1
end

# by default create named user with attributes done by convention
When /^I create a user with login (\w*)$/ do |login|
  @user = User.generate!(:login => login, 
                         :password => login + "pass", 
                         :password_confirmation => login + "pass",
                         :email => login + "@example.com") 
end

When /^I register a user with login (\w*)$/ do |login|
  @user = User.find_by_login(login)
  @user.register! 
  @user.state.should == 'pending'  
  @user
end

When /^I activate a user with login (\w*)$/ do |login|
  @user = User.find_by_login(login)
  @user.activate! 
  @user.state.should == 'active' 
  @user 
end

Given /^a registered user (\w*) exists$/ do |user|    
  When "I create a user with login #{user}"
   And "I register a user with login #{user}"
end             

Given /^an activated user (\w*) exists$/ do |user|    
  When "I create a user with login #{user}"
   And "I register a user with login #{user}"
   And "I activate a user with login #{user}" 
end              

Given /^an admin user (\w*) exists$/ do |user|    
  When "I create a user with login #{user}"
   And "I register a user with login #{user}"
   And "I activate a user with login #{user}" 
   @user.admin = true
   @user.save!
   @user.should be_admin
end             

Then /^Fred's details should be unchanged$/ do
  @user.should == User.find_by_login('Fred')  
end
