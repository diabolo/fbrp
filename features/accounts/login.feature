Story: Logging in
  As a registered user
  I want to log in to my account
  So that I can manage my details
 

  Scenario: User can login
    Given an activated user Fred exists    
     When I login as Fred
     Then I should be logged in as Fred
      And I should see a confirmation
  
  Scenario: User logins when other users exist 
    Given an activated user Fred exists    
      And an activated user Bill exists    
     When I login as Fred
     Then I should be logged in as Fred
      And I should not be logged in as Bill
      And I should have my user id in my session store

  Scenario: Logged-in user who fails logs in should be logged out
    Given an activated user Fred exists    
     When I login as Fred
     Then I should be logged in as Fred
     When I login as someone else and fail
     Then I should not be logged in
      And I should see an error
      And I should not have an auth_token cookie
      And I should not have a user id in my session store
    
  Scenario: Anonymous user can log out.
    Given I am an anonymous user
     When I logout
     Then I should not be logged in
      And I should not have an auth_token cookie
      And I should not have a user id in my session store

  Scenario: Log-in with bogus info should fail until it doesn't
  # TODO These stories rely on a user called 'fred' with a password 'fredpass'. 
  # It might be a good idea to remove this coupling

    Given an activated user Fred exists    
     When I login as Fred with password
     Then my login status should be out
    
    More Examples: 
      | user | login | pass     | status |
      | Fred | Fred  | haxor3   | out    |
      | bill | bill  | haxor3   | out    |
      | Fred | Fred  | peeppass | out    |
      | Fred | Fred  | Fredpass | in     |
    
  Scenario: Logged in user can log out.
    Given an activated user Fred exists    
     When I login as Fred
     Then I should be logged in as Fred
     When I logout
     Then I should see a confirmation
      And I should not be logged in
      And I should not have an auth_token cookie
      And I should not have a user id in my session store
