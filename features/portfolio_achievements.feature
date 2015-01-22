Feature: Portfolio - Achievements
  As a user
  I want to add my achievements
  So that I can generate a portfolio

Scenario: Visit the achievements page
  Given I am on the Portfolio page
  When I touch "Achievements"
  Then I should be on the Achievements page

Scenario: Visit the new achievement page
  Given I am on the Portfolio page
  When I touch "Achievements"
  And I touch navbar button "Edit"
  And I touch "Add new achievement"
  Then I should see navbar with title "Add Achievement"

Scenario: Cannot add an achievement without a name
  Given I am on the Achievements page
  When I touch navbar button "Edit"
  And I touch "Add new achievement"
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a name"

Scenario: Cannot add an achievement with a name longer than 40 characters
  Given I am on the Achievements page
  When I touch navbar button "Edit"
  And I touch "Add new achievement"
  And I enter "12345678901234567890123456789012345678901" into the "Name" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The name must be less than 40 characters"

Scenario: Add achievement
  Given I am on the Achievements page
  When I touch navbar button "Edit"
  And I touch "Add new achievement"
  And I enter "Duke of Edinburgh Award" into the "Name" input field
  And I touch "Date Awarded"
  And I change the date picker date to "01-01-2015"
  And I enter "I got my Duke of Edinburgh gold award!" into the "Description" input field
  And I touch navbar button "Done"
  Then I should see "Duke of Edinburgh Award"
  And I should see "Achieved: 1 January 2015"

Scenario: Edit achievement
  Given I am on the Achievements page
  And I have an achievement called "Duke of Edinburgh Award" achieved on "01-01-2015"
  When I touch navbar button "Edit"
  And I touch "Duke of Edinburgh Award"
  And I clear "Name"
  And I fill in "Name" with "Test Achievement"
  And I touch "Date Awarded"
  And I change the date picker date to "12-12-2012"
  And I touch navbar button "Done"
  Then I should not see "Duke of Edinburgh Award"
  And I should not see "Achieved: 1 January 2015"
  And I should see "Test Achievement"
  And I should see "Achieved: 12 December 2012"

Scenario: Delete achievement
  Given I am on the Achievements page
  And I have an achievement called "Test Achievement" achieved on "12-12-2012"
  When I touch navbar button "Edit"
  And I touch "Delete Test Achievement"
  And I touch "Delete"
  Then I should not see "Test Achievement"
