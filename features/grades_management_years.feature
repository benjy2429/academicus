Feature: Grades Management - Years
  As a user
  I want to add, edit and remove years
  So I can organise my grades into the different time periods that they were achieved

Scenario: Visit years page of a qualification
  Given I am on the Qualifications page
  And I have a qualification called "Degree"
  When I touch "Degree"
  Then I should see navbar with title "Degree"

Scenario: Cannot add year without a name
  Given I have a qualification called "Degree"
  And I am on the Years page for "Degree"
  When I touch navbar button "Edit"
  And I touch "Add new year"
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a name"

Scenario: Cannot add a year with a name longer than 15 characters
  Given I have a qualification called "Degree"
  And I am on the Years page for "Degree"
  When I touch navbar button "Edit"
  And I touch "Add new year"
  And I enter "1234567890123456" into the "Name" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The name must be less than 15 characters"

Scenario: Cannot add a year with a start date after the end date
  Given I have a qualification called "Degree"
  And I am on the Years page for "Degree"
  When I touch navbar button "Edit"
  And I touch "Add new year"
  And I enter "Year 1" into the "Name" input field
  And I touch "Start Date"
  And I change the date picker date to "01-01-2015"
  And I touch "End Date"
  And I change the date picker date to "01-01-2014"
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The start date must be before the end date"

Scenario: Add year
  Given I have a qualification called "Degree"
  And I am on the Years page for "Degree"
  When I touch navbar button "Edit"
  And I touch "Add new year"
  And I enter "Year 1" into the "Name" input field
  And I touch "Start Date"
  And I change the date picker date to "01-01-2014"
  And I touch "End Date"
  And I change the date picker date to "01-01-2015"
  And I touch navbar button "Done"
  Then I should be on the Years page for "Degree"
  And I should see "Year 1"

Scenario: Edit year
  Given I have a qualification called "Degree"
  And I am on the Years page for "Degree"
  And I have a year called "Year 1"
  When I touch navbar button "Edit"
  And I touch "Year 1"
  And I clear "Name"
  And I fill in "Name" with "Year 2"
  And I touch navbar button "Done"
  Then I should be on the Years page for "Degree"
  And I should see "Year 2"
  And I should not see "Year 1"

Scenario: Delete Year
  Given I have a qualification called "Degree"
  And I am on the Years page for "Degree"
  And I have a year called "Year 2"
  When I touch navbar button "Edit"
  And I touch "Delete Year 2"
  And I touch "Delete"
  Then I should not see "Year 2"
  