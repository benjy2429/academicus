require 'calabash-cucumber/calabash_steps'

def visitQualificationPage
    touch("tabBarButton marked:'Grades'")
    touch("tabBarButton marked:'Grades'") #Touch twice to go to first view on navigation stack
end

def visitYearPage(qual)
    visitQualificationPage
    touch("label marked: '#{qual}'")
end

def createQualification(name)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new qualification"'
    macro 'I enter "' + name + '" into the "Name" input field'
    macro 'I enter "University" into the "Institution" input field'
    macro 'I touch navbar button "Done"'
    macro 'I touch navbar button "Done"'
end

def createYear(name)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new year"'
    macro 'I enter "' + name + '" into the "Name" input field'
    macro 'I touch "Start Date"'
    macro 'I change the date picker date to "01-01-2014"'
    macro 'I touch "End Date"'
    macro 'I change the date picker date to "01-01-2015"'
    macro 'I touch navbar button "Done"'
    macro 'I touch navbar button "Done"'
end

def createSubject(name)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new subject"'
    macro 'I enter "' + name + '" into the "Name" input field'
    macro 'I touch navbar button "Done"'
    macro 'I touch navbar button "Done"'
end

def createSubjectWithTarget(name, target)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new subject"'
    macro 'I enter "' + name + '" into the "Name" input field'
    macro 'I scroll down'
    macro 'I wait'
    macro 'I enter "' + target + '" into the "Target" input field'
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

Given /^I am on the Reminders page$/ do
    element_exists("label marked: 'Reminders'")
end

Given(/^I am on the Qualifications page$/) do
    visitQualificationPage
    element_exists("label marked: 'Qualifications'")
end

Given(/^I have a qualification called "(.*?)"$/) do |name|
    visitQualificationPage
    if query("label marked: '#{name}'").empty?
      createQualification name
    end
end

Given(/^I have a year called "(.*?)"$/) do |name|
    visitYearPage "Degree"
    if query("label marked: '#{name}'").empty?
        createYear name
    end
end

Given(/^I have a subject called "(.*?)"$/) do |arg1|
    if query("label marked: '#{name}'").empty?
        createSubject name
    end
end

Given(/^I am on the Years page for "(.*?)"$/) do |qual|
    visitQualificationPage
    touch("label marked: '#{qual}'")
end

Given(/^"(.*?)" has a year called "(.*?)"$/) do |qual, year|
    visitYearPage qual
    if query("label marked: '#{year}'").empty?
        createYear year
    end
end

Given(/^"(.*?)" has a subject called "(.*?)"$/) do |year, subject|
    touch("label marked: '#{year}'")
    if query("label marked: '#{subject}'").empty?
        createSubject subject
    end
end

Given(/^"(.*?)" has a subject called "(.*?)" with a target of "(.*?)"%$/) do |year, subject, target|
    touch("label marked: '#{year}'")
    if query("label marked: '#{subject}'").empty?
        createSubjectWithTarget(subject, target)
    end
end

Given(/^"(.*?)" has an assessment called "(.*?)"$/) do |subject, assessment|
    touch("label marked: '#{subject}'")
    createAssessment assessment
end

Given(/^"(.*?)" has an assessment called "(.*?)" with a weighting of "(.*?)"%$/) do |subject, assessment, weighting|
    touch("label marked: '#{subject}'")
    createAssessmentWithWeighting(assessment, weighting)
end

When /^I touch the Grades tab$/ do
    touch("tabBarButton marked:'Grades'")
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

When(/^I touch the assessment cell "(.*?)"$/) do |assessment|
    now = Date.today
    macro 'I touch "' + now.day.to_s + ', ' + now.strftime("%b") + ', 0 days remaining, ' + assessment + '"'
end

When(/^I touch the delete assessment button for "(.*?)"$/) do |assessment|
    now = Date.today
    macro 'I touch "Delete ' + now.day.to_s + ', ' + now.strftime("%b") + ', 0 days remaining, ' + assessment + '"'
end
