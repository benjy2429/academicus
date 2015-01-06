Feature: Grades Management - Years
  As a user
  I want to add, edit and remove years
  So I can organise my grades into the different time periods that they were achieved

Scenario: Visit years page of a qualification
  Given I am on the Qualifications page
  And I have a qualification called "Degree"
  When I touch "Degree"
  Then I should see navbar with title "Degree"

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

  