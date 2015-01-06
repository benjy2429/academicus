Given /^I am on the Reminders page$/ do
    element_exists("label marked: 'Reminders'")
end

When /^I touch the Grades tab$/ do
    touch("tabBarButton marked:'Grades'")
end

Given(/^I am on the Qualifications page$/) do
    touch("tabBarButton marked:'Grades'")
    touch("tabBarButton marked:'Grades'") #Touch twice to go to first view on navigation stack
    element_exists("label marked: 'Qualifications'")
end

Then(/^I should be on the Qualifications page$/) do
    element_exists("label marked: 'Qualifications'")
end

Then(/^I am on the New Qualification page$/) do
    element_exists("label marked: 'Add qualification'")
end