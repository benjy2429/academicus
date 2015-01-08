Feature: Grades Mangement - Qualifications
  As a user
  I want to add, edit and remove qualifications
  So I can organise my grades by the qualification they belong to

Scenario: View qualifications
  Given I am on the Reminders page
  When I touch the Grades tab
  Then I should be on the Qualifications page

Scenario: Visit new qualification page
  Given I am on the Qualifications page
  When I touch navbar button "Edit"
  And I touch "Add new qualification"
  Then I should be on the New Qualification page

Scenario: Cannot add qualifictaion without name
  Given I am on the Qualifications page
  When I touch navbar button "Edit"
  And I touch "Add new qualification"
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a name"

Scenario: Add qualification
  Given I am on the Qualifications page
  When I touch navbar button "Edit"
  And I touch "Add new qualification"
  And I enter "Degree" into the "Name" input field
  And I touch navbar button "Done"
  Then I should be on the Qualifications page
  And I should see "Degree"

Scenario: Edit qualification
  Given I am on the Qualifications page
  And I have a qualification called "Degree"
  When I touch navbar button "Edit"
  And I touch "Degree"
  And I clear "Name"
  And I fill in "Name" with "A-Level"
  And I touch navbar button "Done"
  Then I should be on the Qualifications page
  And I should see "A-Level"
  And I should not see "Degree"

Scenario: Delete qualification
  Given I am on the Qualifications page
  And I have a qualification called "A-Level"
  When I touch navbar button "Edit"
  And I touch "Delete A-Level"
  And I touch "Delete"
  Then I should not see "A-Level"