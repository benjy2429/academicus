require 'calabash-cucumber/calabash_steps'

def visitQualificationPage
    touch("tabBarButton marked:'Grades'")
end

def visitYearPage(qual)
    visitQualificationPage
    touch("label marked: '#{qual}'")
end

def visitSubjectPage(year)
    touch("label marked: '#{year}'")
end

def visitAssessmentPage(subject)
    touch("label marked: '#{subject}'")
end

def createQualification(name, institution)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new qualification"'
    macro 'I enter "' + name + '" into the "Name" input field'
    macro 'I enter "' + institution + '" into the "Institution" input field'
    macro 'I touch navbar button "Done"'
    macro 'I touch navbar button "Done"'
end

def createYear(name, startDate, endDate)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new year"'
    macro 'I enter "' + name + '" into the "Name" input field'
    macro 'I touch "Start Date"'
    macro 'I change the date picker date to "' + startDate + '"'
    macro 'I touch "End Date"'
    macro 'I change the date picker date to "' + endDate + '"'
    macro 'I touch navbar button "Done"'
    macro 'I touch navbar button "Done"'
end

def createSubject(name, weighting, target)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new subject"'
    macro 'I enter "' + name + '" into the "Name" input field'
    macro 'I enter "' + weighting + '" into the "Weighting" input field'
    macro 'I scroll down'
    macro 'I wait'
    macro 'I enter "' + target + '" into the "Target" input field'
    macro 'I touch navbar button "Done"'
    macro 'I touch navbar button "Done"'
end

def createFullSubject(subject, weighting, target, teacherName, teacherEmail)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new subject"'
    macro 'I enter "' + subject + '" into the "Name" input field'
    macro 'I enter "' + weighting + '" into the "Weighting" input field'
    macro 'I scroll down'
    macro 'I wait'
    macro 'I enter "' + target + '" into the "Target" input field'
    macro 'I scroll down'
    macro 'I wait'
    macro 'I enter "' + teacherName + '" into the "Teacher Name" input field'
    macro 'I enter "' + teacherEmail + '" into the "Teacher Email" input field'
    macro 'I touch navbar button "Done"'
    macro 'I touch navbar button "Done"'
end

def createAssessment(name)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new assessment"'
    macro 'I enter "' + name + '" into the "Name" input field'
    macro 'I touch navbar button "Done"'
    macro 'I touch navbar button "Done"'
end

def createAssessmentWithWeighting(name, weighting)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new assessment"'
    macro 'I enter "' + name + '" into the "Name" input field'
    macro 'I clear "Weighting"'
    macro 'I enter "' + weighting + '" into the "Weighting" input field'
    macro 'I touch navbar button "Done"'
    macro 'I touch navbar button "Done"'
end

def createFullAssessment(assessment, weighting, deadline)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new assessment"'
    macro 'I enter "' + assessment + '" into the "Name" input field'
    macro 'I clear "Weighting"'
    macro 'I enter "' + weighting + '" into the "Weighting" input field'
    macro 'I scroll down'
    macro 'I wait'
    macro 'I touch "Deadline"'
    macro 'I change the date picker date to "' + deadline + '"'
    macro 'I touch navbar button "Done"'
    macro 'I touch navbar button "Done"'
end

def createWorkExperience(jobTitle, companyName, startDate, endDate)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new work experience"'
    macro 'I enter "' + jobTitle + '" into the "Job Title" input field'
    macro 'I enter "' + companyName + '" into the "Company Name" input field'
    macro 'I scroll down'
    macro 'I wait'
    macro 'I touch "Start Date"'
    macro 'I change the date picker date to "' + startDate + '"'
    macro 'I touch "End Date"'
    macro 'I change the date picker date to "' + endDate + '"'
    macro 'I touch navbar button "Done"'
    macro 'I touch navbar button "Done"'
end

Given /^I enter the passcode "(.*?)" "(.*?)" "(.*?)" "(.*?)"$/ do |k1, k2, k3, k4|
    macro 'I touch "' + k1 + '"'
    macro 'I touch "' + k2 + '"'
    macro 'I touch "' + k3 + '"'
    macro 'I touch "' + k4 + '"'
end

Given /^I am on the Reminders page$/ do
    touch("tabBarButton marked:'Reminders'")
    element_exists("label marked: 'Reminders'")
end

Given(/^I am on the Qualifications page$/) do
    visitQualificationPage
    element_exists("label marked: 'Qualifications'")
end

Given(/^I am on the About page$/) do
    touch("tabBarButton marked:'Settings'")
    macro 'I scroll down'
    macro 'I wait'
    touch("label marked:'About'")
end

Given(/^I am on the Settings page$/) do
    touch("tabBarButton marked:'Settings'")
    macro 'I should see navbar with title "Settings"'
end

Given(/^I am on the Portfolio page$/) do
    touch("tabBarButton marked:'Portfolio'")
    macro 'I should see navbar with title "Portfolio"'
end

Given(/^I am on the Achievements page$/) do
    touch("tabBarButton marked:'Portfolio'")
    touch("label marked: 'Achievements'")
    macro 'I should see navbar with title "Achievements"'
end

Given(/^I am on the Work Experience page$/) do
    touch("tabBarButton marked:'Portfolio'")
    touch("label marked: 'Work Experience'")
    macro 'I should see navbar with title "Work Experience"'
end

Given(/^I have a qualification called "(.*?)" at "(.*?)"$/) do |name, institution|
    visitQualificationPage
    if query("label marked: '#{name}'").empty? and query("label marked: '#{institution}'").empty?
      createQualification(name, institution)
    end
end

Given(/^I have a year called "(.*?)" between "(.*?)" and "(.*?)"$/) do |name, startDate, endDate|
    visitYearPage "Degree"
    if query("label marked: '#{name}'").empty?
        createYear(name, startDate, endDate)
    end
end

Given(/^I have a subject called "(.*?)"$/) do |arg1|
    if query("label marked: '#{name}'").empty?
        createSubject name
    end
end

Given(/^I am on the Years page for "(.*?)"$/) do |qual|
    unless query('navigationItemView', :accessibilityLabel).include?("#{qual}")
        visitQualificationPage
        touch("label marked: '#{qual}'")
    end
end

Given(/^I am on the Subjects page for "(.*?)"$/) do |year|
    unless query('navigationItemView', :accessibilityLabel).include?("#{year}")
        visitSubjectPage year
    end
end

Given(/^I am on the Assessments page for "(.*?)"$/) do |subject|
      unless query('navigationItemView', :accessibilityLabel).include?("#{subject}")
        visitAssessmentPage subject
    end
end


Given(/^"(.*?)" has a year called "(.*?)" between "(.*?)" and "(.*?)"$/) do |qual, year, startDate, endDate|
    unless query('navigationItemView', :accessibilityLabel).include?("#{qual}")
        visitYearPage qual
    end
    if query("label marked: '#{year}'").empty?
        createYear(year, startDate, endDate)
    end
end

Given(/^"(.*?)" has a subject called "(.*?)" with a weighting of "(.*?)"% and a target of "(.*?)"%$/) do |year, subject, weighting, target|
    touch("label marked: '#{year}'")
    if query("label marked: '#{subject}'").empty?
        createSubject(subject, weighting, target)
    end 
end

Given(/^"(.*?)" has a subject called "(.*?)" with a weighting of "(.*?)"% and a target of "(.*?)"% and a teacher name of "(.*?)" and a teacher email of "(.*?)"$/) do |year, subject, weighting, target, teacherName, teacherEmail|
    touch("label marked: '#{year}'")
    if query("label marked: '#{subject}'").empty?
        createFullSubject(subject, weighting, target, teacherName, teacherEmail)
    end
end

Given(/^"(.*?)" has an assessment called "(.*?)" with a weighting of "(.*?)"% due on "(.*?)"$/) do |subject, assessment, weighting, deadline|
    touch("label marked: '#{subject}'")
    if query("label marked: '#{assessment}'").empty?
        createFullAssessment(assessment, weighting, deadline)
    end
end

Given(/^"(.*?)" has an assessment called "(.*?)" due in "(.*?)" days$/) do |subject, assessment, dueModifier|
      touch("label marked: '#{subject}'")
    if query("label marked: '#{assessment}'").empty?
        now = Date.today
        createFullAssessment(assessment, "0", (now + dueModifier.to_i).strftime("%d-%m-%Y"))
    end
end


Given(/^I have a Work Experience "(.*?)" at "(.*?)" from "(.*?)" to "(.*?)"$/) do |jobTitle, companyName, startDate, endDate|
  if query("label marked: '#{jobTitle} at #{companyName}'").empty?
    createWorkExperience(jobTitle, companyName, startDate, endDate)
  end
end


When /^I touch the Grades tab$/ do
    touch("tabBarButton marked:'Grades'")
end

When /^I touch the Settings tab$/ do
    touch("tabBarButton marked:'Settings'")
end

When /^I touch the Portfolio tab$/ do
    touch("tabBarButton marked:'Portfolio'")
end

Then(/^I should be on the Qualifications page$/) do
    macro 'I should see navbar with title "Qualifications"'
end

Then(/^I should be on the New Qualification page$/) do
    element_exists("label marked: 'Add qualification'")
end

Then(/^I should be on the Years page for "(.*?)"$/) do |qual|
    macro 'I should see navbar with title "' + qual + '"'
end

Then(/^I should be on the Subjects page for "(.*?)"$/) do |year|
    macro 'I should see navbar with title "' + year + '"'
end

Then(/^I should be on the Assessments page for "(.*?)"$/) do |assessment|
    macro 'I should see navbar with title "' + assessment + '"'
end

Then(/^I should not be on the Settings page$/) do
    not query('navigationItemView', :accessibilityLabel).include?("Settings")
end

Then(/^I should be on the Settings page$/) do
    query('navigationItemView', :accessibilityLabel).include?("Settings")
end

Then(/^I should be on the Portfolio page$/) do
    query('navigationItemView', :accessibilityLabel).include?("Portfolio")
end

Then(/^I should be on the Personal page$/) do
    query('navigationItemView', :accessibilityLabel).include?("Personal")
end

Then(/^I should be on the Hobbies page$/) do
    query('navigationItemView', :accessibilityLabel).include?("Hobbies")
end

Then(/^I should be on the Achievements page$/) do
    query('navigationItemView', :accessibilityLabel).include?("Achievements")
end

Then(/^I should be on the Work Experience page$/) do
    query('navigationItemView', :accessibilityLabel).include?("Work Experience")
end

Then(/^I should be on the About page$/) do
    macro 'I should see navbar with title "About"'
end

When(/^I touch the assessment cell "(.*?)"$/) do |assessment|
    now = Date.today
    macro 'I touch "' + now.day.to_s + ', ' + now.strftime("%b") + ', 0 days remaining, ' + assessment + '"'
end

When(/^I touch the delete assessment button for "(.*?)"$/) do |assessment|
    now = Date.today
    macro 'I touch "Delete ' + now.day.to_s + ', ' + now.strftime("%b") + ', 0 days remaining, ' + assessment + '"'
end

Then /^I should not see text containing "([^\"]*)"$/ do |text|
    res = query("view {text LIKE '*#{text}*'}").empty?
    if not res
        screenshot_and_raise "Text found containing #{text}"
    end
end

Given(/^"(.*?)" has no assessments$/) do |assessment|
    puts "DELETE ALL ASSESSMENTS MANUALLY TO CONTINUE!"
end

