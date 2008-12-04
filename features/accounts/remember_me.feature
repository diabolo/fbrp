Story: Remember Me
  As a registered user
  I want to log in to my account and choose whether to be remembered
  So that I can safe having to login every time

  
  Scenario: User logins and chooses not to be remembered 
    Given I am an activated user
     When I login asking not to be remembered
     Then I should be logged in
      And I should see a confirmation
      And I should not have an auth_token cookie

  Scenario: User logins and chooses to be remembered
    Given I am an activated user
     When I login asking to be remembered
     Then I should be logged in
      And I should see a confirmation
      And I should have an auth_token cookie
