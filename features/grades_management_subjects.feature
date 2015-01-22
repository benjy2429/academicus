Feature: Grades Management - Subjects
  As a user
  I want to add, edit and remove subjects
  So I can organise my grades by subjects

Scenario: Visit subject page of a year
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And I am on the Years page for "Degree"
  When I touch "Year 1"
  Then I should see navbar with title "Year 1"

Scenario: Visit new subject page
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "Add new subject"
  Then I should see navbar with title "Add Subject"

Scenario: Cannot add subject without a name
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "Add new subject"
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a name"

Scenario: Cannot add a subject with a name longer than 30 characters
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "Add new subject"
  And I enter "1234567890123456789012345678901" into the "Name" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The name must be less than 30 characters"

Scenario: Cannot add subject without a year weighting
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "Add new subject"
  And I enter "Name" into the "Name" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a year weighting"

Scenario: Cannot add a subject with a weighting above 100%
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "Add new subject"
  And I enter "COM4510" into the "Name" input field
  And I clear "Weighting"
  And I enter "101" into the "Weighting" input field
  Then I should not see "101"
  And I should see "10"

Scenario: Cannot add subject without a target grade
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "Add new subject"
  And I enter "Name" into the "Name" input field
  And I enter "100" into the "Weighting" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a target grade"

Scenario: Cannot add a subject with a target grade above 100%
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "Add new subject"
  And I enter "COM4510" into the "Name" input field
  And I scroll down
  And I clear "Target"
  And I enter "101" into the "Target" input field
  Then I should not see "101"
  And I should see "10"

Scenario: Cannot add a subject with a teacher name longer than 20 characters
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "Add new subject"
  And I enter "COM4510" into the "Name" input field
  And I enter "0" into the "Weighting" input field
  And I enter "70" into the "Target" input field
  And I enter "123456789012345678901" into the "Teacher Name" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The teacher name must be less than 20 characters"

Scenario: Cannot add a subject with a name longer than 50 characters
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "Add new subject"
  And I enter "COM4510" into the "Name" input field
  And I enter "0" into the "Weighting" input field
  And I enter "70" into the "Target" input field
  And I enter "123456789012345678901234567890123456789012345678901" into the "Teacher Email" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The teacher email must be less than 50 characters"

Scenario: Add subject
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "Add new subject"
  And I enter "COM4510" into the "Name" input field
  And I enter "0" into the "Weighting" input field
  And I enter "70" into the "Target" input field
  And I enter "Mr. Teacher" into the "Teacher Name" input field
  And I enter "teacher@schoolmail.com" into the "Teacher Email" input field
  And I touch navbar button "Done"
  Then I should be on the Subjects page for "Year 1"
  And I should see "COM4510"

Scenario: Cannot add a subject if the total weighting is above 100%
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "99"% and a target of "70"%
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "Add new subject"
  And I enter "Test Subject" into the "Name" input field
  And I enter "2" into the "Weighting" input field
  And I enter "70" into the "Target" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The year weighting is too high. The weighting for all subjects in a year should total 100%"

Scenario: Visit edit subject page
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"% and a teacher name of "Mr. Teacher" and a teacher email of "teacher@schoolmail.com"
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "COM4510"
  Then I should see navbar with title "Edit Subject"
  And I should see "COM4510"
  And I should see "0"
  And I should see "70"
  And I should see "Mr. Teacher"
  And I should see "teacher@schoolmail.com"

Scenario: Edit subject
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "COM4510"
  And I clear "Name"
  And I fill in "Name" with "Maths"
  And I touch navbar button "Done"
  Then I should be on the Subjects page for "Year 1"
  And I should see "Maths"
  And I should not see "COM4510"

Scenario: Delete Year
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And I am on the Subjects page for "Year 1"
  When I touch navbar button "Edit"
  And I touch "Delete COM4510"
  And I touch "Delete"
  Then I should not see "COM4510"

