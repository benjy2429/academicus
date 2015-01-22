Feature: Portfolio - Hobbies
  As a user
  I want to add my hobbies
  So that I can generate a portfolio

Scenario: Visit the hobbies page
  Given I am on the Portfolio page
  When I touch "Hobbies"
  Then I should be on the Hobbies page

Scenario: Can add and save personal information
  Given I am on the Portfolio page
  When I touch "Hobbies"
  And I enter "Making iOS Apps, Photography, Swimming" into the "Hobbies" input field
  And I touch navbar button "Save"
  And I touch "Hobbies"
  Then I should see "Making iOS Apps, Photography, Swimming"