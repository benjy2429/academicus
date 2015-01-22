Feature: Portfolio - Work Experience
  As a user
  I want to add my work experiences
  So that I can generate a portfolio

Scenario: Visit the work experience page
  Given I am on the Portfolio page
  When I touch "Work Experience"
  The I should be on the Work Experience page

Scenario: Visit the new work experience page
  Given I am on the Portfolio page
  When I touch "Work Experience"
  And I touch navbar button "Edit"
  And I touch "Add new work experience"
  Then I should see navbar with title "Add Work Experience"

Scenario: Cannot add an work experience without a job title
  Given I am on the Work Experience page
  When I touch navbar button "Edit"
  And I touch "Add new work experience"
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a job title"

Scenario: Cannot add an work experience without a company name
  Given I am on the Work Experience page
  When I touch navbar button "Edit"
  And I touch "Add new work experience"
  And I enter "Job Title" into the "Job Title" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "You must provide a company name"

Scenario: Cannot add an work experience with a job title longer than 40 characters
  Given I am on the Work experiences page
  When I touch navbar button "Edit"
  And I touch "Add new work experience"
  And I enter "12345678901234567890123456789012345678901" into the "Job Title" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The job title must be less than 40 characters"

Scenario: Cannot add an work experience with a company name longer than 40 characters
  Given I am on the Work experiences page
  When I touch navbar button "Edit"
  And I touch "Add new work experience"
  And I enter "Job Title" into the "Job Title" input field
  And I enter "12345678901234567890123456789012345678901" into the "Company Name" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The company name must be less than 40 characters"

Scenario: Cannot add an work experience with a company address longer than 100 characters
  Given I am on the Work experiences page
  When I touch navbar button "Edit"
  And I touch "Add new work experience"
  And I enter "Job Title" into the "Job Title" input field
  And I enter "Company Name" into the "Company Name" input field
  And I enter "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890" into the "Company Address" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The company address must be less than 40 characters"

Scenario: Cannot add an work experience with an end date before the start date
  Given I am on the Work experiences page
  When I touch navbar button "Edit"
  And I touch "Add new work experience"
  And I enter "Job Title" into the "Job Title" input field
  And I enter "Company Name" into the "Company Name" input field
  And I touch "Start Date"
  And I change the date picker date to "01-01-2015"
  And I touch "End Date"
  And I change the date picker date to "01-01-2014"
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The start date must be before the end date"

Scenario: Cannot add an work experience with a referee name longer than 30 characters
  Given I am on the Work experiences page
  When I touch navbar button "Edit"
  And I touch "Add new work experience"
  And I enter "Job Title" into the "Job Title" input field
  And I enter "Company Name" into the "Company Name" input field
  And I enter "1234567890123456789012345678901" into the "Referee Name" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The referee name must be less than 30 characters"

Scenario: Cannot add an work experience with a referee email longer than 50 characters
  Given I am on the Work experiences page
  When I touch navbar button "Edit"
  And I touch "Add new work experience"
  And I enter "Job Title" into the "Job Title" input field
  And I enter "Company Name" into the "Company Name" input field
  And I enter "123456789012345678901234567890123456789012345678901" into the "Referee Email" input field
  And I touch navbar button "Done"
  Then I should see "Whoops!"
  And I should see "The referee email must be less than 50 characters"

Scenario: Add work experience
  Given I am on the Work experiences page
  When I touch navbar button "Edit"
  And I touch "Add new work experience"
  And I enter "Intern" into the "Job Title" input field
  And I enter "Apple Inc." into the "Company Name" input field
  And I enter "1 Infinite Loop, Cupertino, CA" into the "Company Address" input field
  And I enter "Summer Intern" into the "Job Title" input field
  And I touch "Start Date"
  And I change the date picker date to "01-01-2014"
  And I touch "End Date"
  And I change the date picker date to "01-01-2015"
  And I enter "Internship at Apple Inc." into the "Description" input field
  And I enter "Tim Cook" into the "Referee Name" input field
  And I enter "tcook@apple.com" into the "Referee Email" input field
  And I touch navbar button "Done"
  Then I should see "Intern at Apple Inc."
  And I should see "1 January 2014 to 1 January 2015"

Scenario: Edit work experience
  Given I am on the Work experiences page
  And I have a Work Experience "Intern" at "Apple Inc." from "01-01-2014" to "01-01-2015"
  When I touch navbar button "Edit"
  And I touch "Intern at Apple Inc."
  And I clear "Job Title"
  And I enter "Developer" into the "Job Title" input field
  And I clear "Company Name"
  And I enter "Google" into the "Company Name" input field
  And I touch "Start Date"
  And I change the date picker date to "06-06-2010"
  And I touch "End Date"
  And I change the date picker date to "12-12-2011"
  And I touch navbar button "Done"
  Then I should not see "Intern at Apple Inc."
  And I should not see "1 January 2014 to 1 January 2015"
  And I should see "Developer at Google"
  And I should see "6 June 2010 to 12 December 2011"

Scenario: Delete work experience
  Given I am on the Work experiences page
  And I have an work experience "Developer" at "Google" from "06-06-2010" to "12-12-2011"
  When I touch navbar button "Edit"
  And I touch "Delete Developer at Google"
  And I touch "Delete"
  Then I should not see "Developer at Google"
  And I should not see "6 June 2010 to 12 December 2011"

