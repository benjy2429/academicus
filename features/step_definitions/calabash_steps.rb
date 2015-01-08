require 'calabash-cucumber/calabash_steps'

def visitQualificationPage
    touch("tabBarButton marked:'Grades'")
    touch("tabBarButton marked:'Grades'") #Touch twice to go to first view on navigation stack
end

def createQualification(name)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new qualification"'
    macro 'I enter "' + name + '"into the "Name" input field'
    macro 'I touch navbar button "Done"'
    macro 'I touch navbar button "Done"'
end

def createYear(name)
    macro 'I touch navbar button "Edit"'
    macro 'I touch "Add new year"'
    macro 'I enter "' + name + '" into the "Name" input field'
    macro 'And I touch "Start Date"'
    macro 'And I change the date picker date to "01-01-2014"'
    macro 'And I touch "End Date"'
    macro 'And I change the date picker date to "01-01-2015"'
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
    if query("label marked: '#{name}'").empty?
        createYear name
    end
end

Given(/^I am on the Years page for "(.*?)"$/) do |qual|
    visitQualificationPage
    touch("label marked: '#{qual}'")
end

When /^I touch the Grades tab$/ do
    touch("tabBarButton marked:'Grades'")
end

Then(/^I should be on the Qualifications page$/) do
    element_exists("label marked: 'Qualifications'")
end

Then(/^I should be on the New Qualification page$/) do
    element_exists("label marked: 'Add qualification'")
end

Then(/^I should be on the Years page for "(.*?)"$/) do |qual|
    element_exists("label marked: '#{qual}'")
end

