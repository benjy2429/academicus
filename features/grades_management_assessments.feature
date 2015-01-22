Feature: Grades Management - Assessments
  As a user
  I want to add, edit and remove assessments
  So I can organise my grades by assessment





Scenario: Subject target grade is shown
  Given I have a qualification called "Degree"
  And "Degree" has a year called "Year 1"
  And "Year 1" has a subject called "Target Subject" with a target of "70"%
  When I touch "Target Subject"
  Then I should see "70%"

Scenario: Cannot add an assessment without a name
  Given I have a qualification called "Degree"
  And "Degree" has a year called "Year 1"
  And "Year 1" has a subject called "COM4510"
  When I touch "COM4510"
  And I touch navbar button "Edit"
  And I touch "Add new assessment"
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a name"

Scenario: Cannot add an assessment with a name longer than 30 characters
  Given I have a qualification called "Degree"
  And "Degree" has a year called "Year 1"
  And "Year 1" has a subject called "COM4510"
  When I touch "COM4510"
  And I touch navbar button "Edit"
  And I touch "Add new assessment"
  And I enter "1234567890123456789012345678901" into the "Name" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The name must be less than 30 characters"

Scenario: Cannot add an assessment with a weighting above 100%
  Given I have a qualification called "Degree"
  And "Degree" has a year called "Year 1"
  And "Year 1" has a subject called "COM4510"
  When I touch "COM4510"
  And I touch navbar button "Edit"
  And I touch "Add new assessment"
  And I enter "Exam" into the "Name" input field
  And I clear "Weighting"
  And I enter "101" into the "Weighting" input field
  Then I should not see "101"
  And I should see "10"

Scenario: Add assessment
  Given I have a qualification called "Degree"
  And "Degree" has a year called "Year 1"
  And "Year 1" has a subject called "COM4510"
  When I touch "COM4510"
  And I touch navbar button "Edit"
  And I touch "Add new assessment"
  And I enter "Exam" into the "Name" input field
  And I scroll down
  And I wait
  And I touch "Deadline"
  And I change the date picker date to "01-01-2015"
  And I touch navbar button "Done"
  Then I should be on the Assessments page for "COM4510"
  And I should see "Exam"
  And I should see "1"
  And I should see "Jan"

Scenario: Edit assessment
  Given I have a qualification called "Degree"
  And "Degree" has a year called "Year 1"
  And "Year 1" has a subject called "COM4510"
  And "COM4510" has an assessment called "Exam"
  When I touch navbar button "Edit"
  And I touch "Exam"
  When I clear "Name"
  And I enter "Quiz" into the "Name" input field
  And I scroll down
  And I wait
  And I touch "Deadline"
  And I change the date picker date to "02-02-2015"
  And I touch navbar button "Done"
  Then I should be on the Assessments page for "COM4510"
  And I should see "Quiz"
  And I should see "2"
  And I should see "Feb"
  And I should not see "Exam"
  And I should not see "1"
  And I should not see "Jan"

Scenario: Delete Assessment
  Given I have a qualification called "Degree"
  And "Degree" has a year called "Year 1"
  And "Year 1" has a subject called "COM4510"
  And "COM4510" has an assessment called "Quiz"
  When I touch navbar button "Edit"
  And I touch the delete assessment button for "Quiz"
  And I touch "Delete"
  Then I should not see "Quiz"

Scenario: Add grade to an assessment
  Given I have a qualification called "Degree"
  And "Degree" has a year called "Year 1"
  And "Year 1" has a subject called "COM4510"
  And "COM4510" has an assessment called "Graded Assessment" with a weighting of "20"%
  When I touch list item number 1
  And I fill in "Final Grade" with "50"
  And I touch navbar button "Done"
  Then I should be on the Assessments page for "COM4510"
  And I should see "Graded Assessment"
  And I should see "50%"
  And I should see "Completed"
  And I should not see "0 days remaining"
  And I should see "10%"
