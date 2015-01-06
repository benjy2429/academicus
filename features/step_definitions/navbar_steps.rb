def navbar_visible?
    !query('navigationBar').empty?
end

def navbar_has_back_button?
    !query("navigationItemButtonView").empty?
end

def navbar_should_have_back_button
    unless navbar_has_back_button?
        screenshot_and_raise "there is no navigation bar back button"
    end
end

def navbar_should_not_have_back_button
    if navbar_has_back_button?
        screenshot_and_raise "i should not see navigation bar back button"
    end
end


# navigation back item, distinct from left bar button item
Then /^I should see navbar back button$/ do
    navbar_should_have_back_button
end

Then /^I should see a back button in the navbar$/ do
    navbar_should_have_back_button
end

# navigation back item, distinct from left bar button item
Then /^I should not see navbar back button$/ do
    if navbar_has_back_button?
        screenshot_and_raise "there should be no navigation bar back button"
    end
end

# will not work to detect left/right buttons
def index_of_navbar_button (name)
    titles = query("navigationButton", :accessibilityLabel)
    titles.index(name)
end

def should_see_navbar_button (name)
    idx = index_of_navbar_button name
    if idx.nil?
        screenshot_and_raise "there should be a navbar button named #{name}"
    end
end

def should_not_see_navbar_button (name)
    idx = index_of_navbar_button name
    unless idx.nil?
        screenshot_and_raise "i should not see a navbar button named #{name}"
    end
end



def date_is_in_navbar (date)
    with_leading = date.strftime("%a %b %d")
    without_leading = date.strftime("%a %b #{date.day}")
    items = query("navigationItemView", :accessibilityLabel)
    items.include?(with_leading) || items.include?(without_leading)
end

Then /^I should see today's date in the navbar$/ do
now = Time.now
unless date_is_in_navbar(now)
    with_leading = now.strftime("%a %b %d")
    without_leading = now.strftime("%a %b #{date.day}")
    screenshot_and_raise "could not find #{with_leading} or #{without_leading} " +
    "in the date bar"
end
end

def go_back_after_waiting
    touch("navigationItemButtonView first")
end

Then /^I go back after waiting$/ do
    go_back_after_waiting
end

def touch_navbar_item(name)
    idx = index_of_navbar_button name
    #puts "index of nav bar button: #{idx}"
    if idx
        touch("navigationButton index:#{idx}")
        else
        screenshot_and_raise "could not find navbar item #{name}"
    end
end

Then /^I touch navbar button "([^"]*)"$/ do |name|
touch_navbar_item(name)
end

Then /^I touch right navbar button$/ do
    touch("navigationButton index:1")
end


def navbar_has_title (title)
    query('navigationItemView', :accessibilityLabel).include?(title)
end

def navbar_should_have_title(title)
    unless navbar_has_title title
        screenshot_and_raise "after waiting, i did not see navbar with title #{title}"
    end
end

Then /^I should see navbar with title "([^\"]*)"$/ do |title|
    navbar_should_have_title title
end


Then /^I should (not see|see) (?:the|an?) "([^"]*)" button in the navbar$/ do |visibility, name|
if visibility.eql? "see"
    should_see_navbar_button name
    else
    should_not_see_navbar_button name
end
end

Then /^I touch the "([^"]*)" navbar button$/ do |name|
touch_navbar_item name
end

Then /^I should see that the navbar has title "([^"]*)"$/ do |title|
navbar_should_have_title title
end

Then /^I touch the "([^"]*)" button in the navbar$/ do |name|
touch_navbar_item name
end

Then /^I should see a back button in the navbar with the title "([^"]*)"$/ do |title|
if query("navigationItemButtonView marked:'#{title}'").empty?
    screenshot_and_raise "the navbar should have a back button with title #{title}"
end
end