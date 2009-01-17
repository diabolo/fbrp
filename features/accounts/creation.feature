Feature: Account Creation   
   
  As a site owner 
  I want users to be able to create an account
  So that users are encouraged to return to the site
   
  Scenario: We can create users for our features
    Given there are 4 users

  Scenario: There is a signup page
    Given I visit signup
     Then I should see a form
    
   
  Scenario: Anonymous user can create an account
    Given I am logged out
     When I signup as Fred
     Then I should see a confirmation
      And there should be an account for Fred 

  Scenario: Anonymous user can not duplicate a un-activated account
    Given I am logged out
      And a registered user Fred exists
     When I signup as Fred
     Then I should see an error
      And I should not be logged in
      And Fred's details should be unchanged
     
  Scenario: Anonymous user can not duplicate an activated account
    Given I am logged out
      And an activated user Fred exists
     When I signup as Fred
     Then I should see an error
      And I should not be logged in
      And Fred's details should be unchanged

  Scenario: Anonymous user can not create an account without ...
    Given I am logged out 
     When I signup as Fred without password
     Then I should see an error
      And I should not be logged in
    
    More Examples: 
      |user | field |
      |Fred | login |
      |Fred | password_confirmation |
    
     
  Scenario: Anonymous user can not create an account with mismatched password & password_confirmation
    Given I am logged out
     When I signup as Fred with wrong confirmation
     Then I should see an error
      And I should not be logged in
