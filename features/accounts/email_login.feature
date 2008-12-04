Story: Logging in using email address
  As a registered user
  I want to log in to my account using my email address
  So that I don't have to remember my login id
  
  Scenario: User can login
    Given an activated user Fred exists
    When I login as Fred with my email address
    Then I should be logged in
    And I should see a confirmation
 
