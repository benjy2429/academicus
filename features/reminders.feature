Feature: Reminders
  As a user
  I want to quickly see my assignments
  So I can see which are due soon and which require grades

Scenario: I can see upcoming assessments
  Given I am on the Reminders page
  And I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Upcoming Assessment" due in "1" days
  Then I should see "Upcoming Assessment"
  And I should see "COM4510"
  And I should see "Due tomorrow"

Scenario: I can see the deadline date of an assignment
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Upcoming Assessment" with a weighting of "0"% due on "01-01-2015"
  And I am on the Reminders page
  Then I should see "1"
  And I should see "Jan"

Scenario: I can see past assignments
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Past Assessment" due in "-1" days
  And I am on the Reminders page
  And I touch "Past Deadlines"
  Then I should see "Past Assessment"
  And I should see "COM4510"
  And I should see "No rating"

Scenario: I can swipe to switch between upcoming and past assessments
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Upcoming Assessment" due in "1" days
  And "COM4510" has an assessment called "Past Assessment" due in "-1" days
  And I am on the Reminders page
  And I swipe left
  Then I should see "Past Assessment"
  And I should see "COM4510"
  And I should see "No rating"
  And I should not see "Upcoming Assessment"
  And I should not see "Due tomorrow"

Scenario: Adding a grade to an upcoming assessment moves it to the past deadlines section
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Add Grade Assessment" due in "1" days
  And I am on the Reminders page
  When I touch "Add Grade Assessment"
  And I enter "50" into the "Final Grade" input field
  And I touch "2 Stars"
  And I touch navbar button "Done"
  And I touch "Past Deadlines"
  Then I should see "Add Grade Assessment"
  And I should see "COM4510"
  And I should see "★★☆☆☆"
  And I should see "50%"

Scenario: I can see graded and ungraded past deadlines
  Given I have a qualification called "Degree" at "University"
  And "Degree" has a year called "Year 1" between "01-01-2014" and "12-12-2014"
  And "Year 1" has a subject called "COM4510" with a weighting of "0"% and a target of "70"%
  And "COM4510" has an assessment called "Has Grade Assessment" due in "-1" days
  And "COM4510" has an assessment called "No Grade Assessment" due in "-1" days
  And I am on the Reminders page
  And I touch "Past Deadlines"
  When I touch "Has Grade Assessment"
  And I enter "100" into the "Final Grade" input field
  And I touch "5 Stars"
  And I touch navbar button "Done"
  And I touch "Past Deadlines"
  Then I should see "Has Grade Assessment"
  And I should see "No Grade Assessment"
  And I should see "COM4510"
  And I should see "★★★★★"
  And I should see "Graded"
  And I should see "Awaiting Grade"

