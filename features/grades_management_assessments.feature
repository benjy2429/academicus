Feature: Grades Management - Assessments
  As a user
  I want to add, edit and remove assessments
  So I can organise my grades by assessment

Scenario: Visit assessment page of a subject
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And I am on the Subjects page for "Year 1"
  When I touch "COM4510"
  Then I should see navbar with title "COM4510"

Scenario: Subject target and current grade is shown but not subject details
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"% and a teacher name of "Mr. Teacher" and a teacher email of "teacher@schoolmail.com"
  And I am on the Subjects page for "Year 1"
  When I touch "COM4510"
  Then I should see "70%"
  And I should see "Subject Completed:  0%"
  And I should not see text containing "Mr. Teacher"
  And I should not see text containing "teacher@schoolmail.com"

Scenario: Can see the subject details when the header is expanded
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"% and a teacher name of "Mr. Teacher" and a teacher email of "teacher@schoolmail.com"
  And I am on the Assessments page for "COM4510"
  When I touch "Show subject details"
  Then I should see "Subject Completed:  0%"
  And I should see "Teacher Name: Mr. Teacher"
  And I should see "Teacher Email:"
  And I should see "teacher@schoolmail.com"
  And I should see a "Hide subject details" button

Scenario: Teacher email is a link
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"% and a teacher name of "Mr. Teacher" and a teacher email of "teacher@schoolmail.com"
  And I am on the Assessments page for "COM4510"
  When I touch "Show subject details"
  And I wait
  And I wait
  And I touch "teacher@schoolmail.com"
  Then I should see navbar with title "New Message"

Scenario: The weighting error is visible with no assessments
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And I am on the Assessments page for "COM4510"
  When I touch "Show subject details"
  Then I should see "The assessment weightings for this subject do not total to 100%"

Scenario: Cannot add an assessment without a name
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And I am on the Assessments page for "COM4510"
  When I touch navbar button "Edit"
  And I touch "Add new assessment"
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a name"

Scenario: Cannot add an assessment with a name longer than 30 characters
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And I am on the Assessments page for "COM4510"
  When I touch navbar button "Edit"
  And I touch "Add new assessment"
  And I enter "1234567890123456789012345678901" into the "Name" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The name must be less than 30 characters"

Scenario: Cannot add an assessment without a subject weighting
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And I am on the Assessments page for "COM4510"
  When I touch navbar button "Edit"
  And I touch "Add new assessment"
  And I enter "Name" into the "Name" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a subject weighting"

Scenario: Cannot add an assessment with a weighting above 100%
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And I am on the Assessments page for "COM4510"
  When I touch navbar button "Edit"
  And I touch "Add new assessment"
  And I enter "Exam" into the "Name" input field
  And I clear "Weighting"
  And I enter "101" into the "Weighting" input field
  Then I should not see "101"
  And I should see "10"

Scenario: Add assessment
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And I am on the Assessments page for "COM4510"
  When I touch navbar button "Edit"
  And I touch "Add new assessment"
  And I enter "Exam" into the "Name" input field
  And I enter "0" into the "Weighting" input field
  And I scroll down
  And I wait
  And I touch "Deadline"
  And I change the date picker date to "01-01-2015"
  And I touch navbar button "Done"
  Then I should be on the Assessments page for "COM4510"
  And I should see "Exam"
  And I should see "1"
  And I should see "Jan"

Scenario: Cannot add an assessment if the total weighting is above 100%
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Test Assessment" with a weighting of "99"% due on "01-01-2015"
  And I am on the Assessments page for "COM4510"
  When I touch navbar button "Edit"
  And I touch "Add new assessment"
  And I enter "Report" into the "Name" input field
  And I enter "2" into the "Weighting" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The subject weighting is too high. The weighting for all assessments in a subject should total 100%"

Scenario: Adding assessments that total 100% weighting removes the weighting error
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Test Assessment" with a weighting of "99"% due on "01-01-2015"
  And I am on the Assessments page for "COM4510"
  When I touch navbar button "Edit"
  And I touch "Add new assessment"
  And I enter "Report" into the "Name" input field
  And I enter "1" into the "Weighting" input field
  And I touch navbar button "Done"
  And I touch "Show subject details"
  Then I should not see "The assessment weightings for this subject do not total to 100%"

Scenario: Visit edit assessment page
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Exam" with a weighting of "0"% due on "01-01-2015"
  And I am on the Assessments page for "COM4510"
  When I touch navbar button "Edit"
  And I touch "Exam"
  Then I should see navbar with title "Edit Assessment"
  And I should see "Exam"
  And I should see "0.00"
  And I scroll down
  And I wait
  And I should see text containing "Thu, 1/1/15"

Scenario: Edit assessment
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Exam" with a weighting of "0"% due on "01-01-2015"
  And I am on the Assessments page for "COM4510"
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
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Quiz" with a weighting of "0"% due on "02-02-2015 12:00"
  And I am on the Assessments page for "COM4510"
  When I touch navbar button "Edit"
  And I touch the delete assessment button for "Quiz"
  And I touch "Delete"
  Then I should not see "Quiz"


# --- ADD GRADE PAGE ---

Scenario: Visit the add grade page for an assessment
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Quiz" with a weighting of "0"% due on "02-02-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  Then I should see navbar with title "Add Grade"

Scenario: Cannot add a grade without a final grade
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Quiz" with a weighting of "0"% due on "02-02-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a final grade"

Scenario: Cannot add a grade with a final grade above 100%
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Quiz" with a weighting of "0"% due on "02-02-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I clear "Final Grade"
  And I enter "101" into the "Final Grade" input field
  Then I should not see "101"
  And I should see "10"

Scenario: Cannot add a grade with positive feedback longer than 300 characters
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Quiz" with a weighting of "0"% due on "02-02-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I enter "0" into the "Final Grade" input field
  And I scroll down
  And I wait
  And I enter "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901" into the "Positive Feedback" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The positive feedback must be less than 300 characters"

Scenario: Cannot add a grade with negative feedback longer than 300 characters
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Quiz" with a weighting of "0"% due on "02-02-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I enter "0" into the "Final Grade" input field
  And I scroll down
  And I wait
  And I enter "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901" into the "Negative Feedback" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The negative feedback must be less than 300 characters"

Scenario: Cannot add a grade with notes longer than 300 characters
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Quiz" with a weighting of "0"% due on "02-02-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I enter "0" into the "Final Grade" input field
  And I scroll down
  And I wait
  And I enter "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901" into the "Notes" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The notes must be less than 300 characters"

Scenario: Can swipe on the rating to increase the value
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Quiz" with a weighting of "0"% due on "02-02-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I swipe right on number 2
  Then I should see a "★" button

Scenario: Can swipe on the rating to decrease the value
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Quiz" with a weighting of "0"% due on "02-02-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I touch "1 Star"
  And I swipe left on number 2
  Then I should not see a "★" button 

Scenario: Add grade to an assessment
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has no assessments
  And "COM4510" has an assessment called "Quiz" with a weighting of "50"% due on "02-02-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I fill in "Final Grade" with "50"
  And I touch "1 Star"
  And I fill in "Positive Feedback" with "Very interesting"
  And I fill in "Negative Feedback" with "Too hard"
  And I fill in "Notes" with "Useful link: google.com"
  And I touch navbar button "Done"
  And I touch "OK"
  Then I should be on the Assessments page for "COM4510"
  And I should see "Quiz"
  And I should see "50%"
  And I should see "Completed"
  And I should not see text containing "Due"
  And I should see "25%"

Scenario: Remove grade from an assessment
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Quiz" with a weighting of "50"% due on "02-02-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I fill in "Final Grade" with "50"
  And I touch navbar button "Done"
  And I touch "OK"
  And I touch "Quiz"
  And I touch "Remove Grade"
  Then I should be on the Assessments page for "COM4510"
  And I should see "Quiz"
  And I should not see "50%"
  And I should not see "Completed"
  And I should see text containing "Due"

Scenario: Completing a subject changes the labels on the page
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has no assessments
  And "COM4510" has an assessment called "Quiz" with a weighting of "100"% due on "01-01-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I fill in "Final Grade" with "50"
  And I touch navbar button "Done"
  And I touch "OK"
  And I touch "Show subject details"
  Then I should see "Final Grade"
  And I should not see "Current Grade"
  And I should see "50%"
  And I should see "Subject Completed: 100%"

Scenario: Final grade under target appears
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has no assessments
  And "COM4510" has an assessment called "Quiz" with a weighting of "100"% due on "01-01-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I fill in "Final Grade" with "50"
  And I touch navbar button "Done"
  And I touch "OK"
  Then I should see "Awww man!"
  And I should see text containing "It looks like your final grade for this subject is a little short of your target"

Scenario: Final grade above target appears
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has no assessments
  And "COM4510" has an assessment called "Quiz" with a weighting of "100"% due on "01-01-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I fill in "Final Grade" with "90"
  And I touch navbar button "Done"
  And I touch "OK"
  Then I should see "Woo hoo!"
  And I should see text containing "Way to go, you've finished the subject and met your goal!"

Scenario: Grade under target appears
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has no assessments
  And "COM4510" has an assessment called "Quiz" with a weighting of "70"% due on "01-01-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I fill in "Final Grade" with "50"
  And I touch navbar button "Done"
  And I touch "OK"
  Then I should see "Oh no!"
  And I should see text containing "It looks like you fell short of your target this time."

Scenario: Grade above target appears
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has no assessments
  And "COM4510" has an assessment called "Quiz" with a weighting of "70"% due on "01-01-2015"
  And I am on the Assessments page for "COM4510"
  When I touch "Quiz"
  And I fill in "Final Grade" with "90"
  And I touch navbar button "Done"
  And I touch "OK"
  Then I should see "Nice work!"
  And I should see text containing "You met your target for this assessment."

