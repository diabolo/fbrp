Given /^I am a registered user$/ do  
  Given "a registered user Fred exists"
end

Given /^I am an activated user$/ do  
  Given "an activated user Fred exists"
end

When /^I activate myself$/ do  
  get "/activate/#{@user.activation_code }"  
  
  # Have to do this otherwise variable won't show that its state has changed
  @user.reload
end               


When /^I activate myself without an activation code$/ do  
  get '/activate/'
  # Have to do this otherwise variable won't show that its state has changed
  @user.reload
end                
    
When /^I activate myself with a bogus activation code$/ do  
  bogus_code = "jhadasj637687ea"
  get "/activate/#{@bogus_code }"
  # Have to do this otherwise variable won't show that its state has changed
  @user.reload
end                

Then /^I should be activated$/ do 
  @user.state.should == 'active'
end

Then /^I should not be activated$/ do 
  @user.state.should_not == 'active'
end
