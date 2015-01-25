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
  Then I should see navbar with title "Add Qualification"

Scenario: Cannot add qualifictaion without a name
  Given I am on the Qualifications page
  When I touch navbar button "Edit"
  And I touch "Add new qualification"
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a name"

Scenario: Cannot add qualifictaion without an institution
  Given I am on the Qualifications page
  When I touch navbar button "Edit"
  And I touch "Add new qualification"
  And I enter "Name" into the "Name" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide an institution"

Scenario: Cannot add qualifictaion with a name longer than 30 characters
  Given I am on the Qualifications page
  When I touch navbar button "Edit"
  And I touch "Add new qualification"
  And I enter "1234567890123456789012345678901" into the "Name" input field
  And I enter "Institution" into the "Institution" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The name must be less than 30 characters"

Scenario: Cannot add qualification with an institution longer than 50 characters
  Given I am on the Qualifications page
  When I touch navbar button "Edit"
  And I touch "Add new qualification"
  And I enter "Name" into the "Name" input field
  And I enter "123456789012345678901234567890123456789012345678901" into the "Institution" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The institution must be less than 50 characters"

Scenario: Add qualification
  Given I am on the Qualifications page
  When I touch navbar button "Edit"
  And I touch "Add new qualification"
  And I enter "Degree" into the "Name" input field
  And I enter "University" into the "Institution" input field
  And I touch navbar button "Done"
  Then I should be on the Qualifications page
  And I should see "Degree"
  And I should see "University"

Scenario: Visit edit qualification screen
  Given I am on the Qualifications page
  And I have a qualification called "Degree" at "University"
  When I touch navbar button "Edit"
  And I touch "Degree"
  Then I should see navbar with title "Edit Qualification"
  And I should see "Degree"
  And I should see "University"

Scenario: Edit qualification
  Given I am on the Qualifications page
  And I have a qualification called "Degree" at "University"
  When I touch navbar button "Edit"
  And I touch "Degree"
  And I clear "Name"
  And I fill in "Name" with "A-Level"
  And I clear "Institution"
  And I fill in "Institution" with "College"
  And I touch navbar button "Done"
  Then I should be on the Qualifications page
  And I should see "A-Level"
  And I should see "College"
  And I should not see "Degree"
  And I should not see "University"

Scenario: Delete qualification
  Given I am on the Qualifications page
  And I have a qualification called "A-Level" at "College"
  When I touch navbar button "Edit"
  And I touch "Delete A-Level, College"
  And I touch "Delete"
  Then I should not see "A-Level"
  And I should not see "College"

