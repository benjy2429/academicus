Feature: Portfolio - Personal
  As a user
  I want to add personal information about myself
  So that I can generate a portfolio

Scenario: View portfolio page
  Given I am on the Reminders page
  When I touch the Portfolio tab
  Then I should be on the Portfolio page

Scenario: Visit the personal page
  Given I am on the Portfolio page
  When I touch "Personal"
  Then I should be on the Personal page

Scenario: Cannot enter a name over 30 characters
  Given I am on the Portfolio page
  When I touch "Personal"
  And I enter "1234567890123456789012345678901" into the "Name" input field
  And I touch navbar button "Save"
  Then I should see "Whoops!"
  And I should see "The name must be less than 30 characters"

Scenario: Cannot enter a telephone number over 30 characters
  Given I am on the Portfolio page
  When I touch "Personal"
  And I enter "1234567890123456" into the "Telephone" input field
  And I touch navbar button "Save"
  Then I should see "Whoops!"
  And I should see "The telephone number must be less than 15 characters"

Scenario: Cannot enter a name over 30 characters
  Given I am on the Portfolio page
  When I touch "Personal"
  And I scroll down
  And I wait
  And I enter "123456789012345678901234567890123456789012345678901" into the "Email Address" input field
  And I touch navbar button "Save"
  Then I should see "Whoops!"
  And I should see "The email must be less than 50 characters"

Scenario: Cannot enter a name over 30 characters
  Given I am on the Portfolio page
  When I touch "Personal"
  And I scroll down
  And I wait
  And I enter "123456789012345678901234567890123456789012345678901" into the "Website" input field
  And I touch navbar button "Save"
  Then I should see "Whoops!"
  And I should see "The website must be less than 50 characters"

Scenario: No camera brings up an error message
  Given I am on the Portfolio page
  When I touch "Personal"
  And I scroll down
  And I wait
  And I touch "No Photo Selected"
  And I wait
  Then I should see "Hmm..."
  And I should see "Your camera is unavailable at the moment"

Scenario: Can select a photo from the photo library
  Given I am on the Portfolio page
  When I touch "Personal"
  And I scroll down
  And I wait
  And I touch "No Photo Selected"
  And I wait
  And I touch "OK"
  And I touch "Select from existing photos"
  And I wait
  Then I should see navbar with title "Photos"

Scenario: Tapping the address field opens the address search page
  Given I am on the Portfolio page
  When I touch "Personal"
  And I touch "No Location Selected"
  Then I should see navbar with title "Address"

Scenario: Can search for address locations
  Given I am on the Portfolio page
  When I touch "Personal"
  And I touch "No Location Selected"
  And I enter "apple inc" into the search bar
  Then I should see "Apple Inc."
  And I should see "Cupertino, 95014, United States"

Scenario: Can view address location search results on a map
  Given I am on the Portfolio page
  When I touch "Personal"
  And I touch "No Location Selected"
  And I enter "apple inc" into the search bar
  And I touch the "Apple Inc." accessory button
  Then I should see a map

Scenario: Can add an address
  Given I am on the Portfolio page
  When I touch "Personal"
  And I touch "No Location Selected"
  And I enter "apple inc" into the search bar
  And I touch "Apple Inc."
  Then I should see "Apple Inc., Cupertino, 95014, United States"
  And I should not see "No Location Selected"

Scenario: Can remove an address
  Given I am on the Portfolio page
  When I touch "Personal"
  And I touch "Apple Inc., Cupertino, 95014, United States"
  And I touch navbar button "Remove"
  Then I should not see "Apple Inc., Cupertino, 95014, United States"
  And I should see "No Location Selected"

Scenario: Can add and save personal information
  Given I am on the Portfolio page
  When I touch "Personal"
  And I enter "Bob Smith" into the "Name" input field
  And I scroll down
  And I wait
  And I enter "01234567890" into the "Telephone" input field
  And I enter "test@test.com" into the "Email Address" input field
  And I enter "www.website.com" into the "Website" input field
  And I touch navbar button "Save"
  And I touch "Personal"
  Then I should see "Bob Smith"
  And I should see "01234567890"
  And I should see "test@test.com"
  And I should see "www.website.com"

