Feature: Portfolio - Personal
  As a user
  I want to change the settings of the app
  So that I can customise it to my preferences

Scenario: View settings page
  Given I am on the Reminders page
  When I touch the Settings tab
  Then I should see navbar with title "Settings"

Scenario: Pressing a number key updates the passcode label
  Given I am on the Settings page
  When I toggle the "Passcode Lock" switch
  And I press "1"
  Then I should see "● ○ ○ ○"

Scenario: Pressing the delete key updates the passcode label
  Given I am on the Settings page
  When I toggle the "Passcode Lock" switch
  And I press "1"
  And I press "X"
  Then I should see "○ ○ ○ ○"

Scenario: Cannot add a passcode if the confirmation is incorrect
  Given I am on the Settings page
  When I toggle the "Passcode Lock" switch
  And I press "1"
  And I press "2"
  And I press "3"
  And I press "4"
  And I press "4"
  And I press "3"
  And I press "2"
  And I press "1"
  Then I should not be on the Settings page
  And I should see "Confirm New Passcode"
  And I should see "○ ○ ○ ○"

Scenario: Add a passcode
  Given I am on the Settings page
  When I toggle the "Passcode Lock" switch
  And I press "1"
  And I press "2"
  And I press "3"
  And I press "4"
  And I press "1"
  And I press "2"
  And I press "3"
  And I press "4"
  Then I should be on the Settings page

Scenario: Change passcode
  Given I enter the passcode "1" "2" "3" "4"
  And I am on the Settings page
  When I touch "Change Passcode"
  And I press "1"
  And I press "2"
  And I press "3"
  And I press "4"
  And I press "2"
  And I press "5"
  And I press "8"
  And I press "0"
  And I press "2"
  And I press "5"
  And I press "8"
  And I press "0"
  Then I should be on the Settings page

Scenario: Cannot remove passcode if it is entered wrong
  Given I enter the passcode "2" "5" "8" "0"
  And I am on the Settings page
  When I toggle the "Passcode Lock" switch
  And I press "1"
  And I press "2"
  And I press "3"
  And I press "4"
  Then I should not be on the Settings page
  And I should see "Confirm Existing Passcode"
  And I should see "○ ○ ○ ○"

Scenario: Remove passcode
  Given I enter the passcode "2" "5" "8" "0"
  And I am on the Settings page
  When I toggle the "Passcode Lock" switch
  And I press "2"
  And I press "5"
  And I press "8"
  And I press "0"
  Then I should be on the Settings page

Scenario: Visit the about page
  Given I am on the Settings page
  And I scroll down
  And I wait
  When I touch "About"
  Then I should be on the About page
  And I should see text starting with "Version: "
  And I see the "logoView"

Scenario: Ask a question
  Given I am on the About page
  When I touch "Ask us a question"
  And I wait
  Then I should see navbar with title "Academicus Query"

Scenario: Report a bug
  Given I am on the About page
  When I touch "Report a bug"
  And I wait
  Then I should see navbar with title "Academicus Bug Report"

Scenario: Submit a suggestion
  Given I am on the About page
  When I touch "Suggestions"
  And I wait
  Then I should see navbar with title "Academicus Suggestion"

Scenario: Visit the FAQ's
  Given I am on the About page
  When I touch "FAQ\'s"
  Then I should see "Coming Soon!"
  And I should see "The FAQ\'s are coming soon."

