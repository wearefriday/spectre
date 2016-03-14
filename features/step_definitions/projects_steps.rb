Given(/^there are projects with tests$/) do
  3.times do
    FactoryGirl.create(:test)
  end
end

When(/^we visit the projects page$/) do
  visit '/projects'
end

Then(/^we should see the projects$/) do
  expect(page).to have_css('#project_1')
end
