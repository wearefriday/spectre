Given(/^there is a run$/) do
  project = Project.create!(name: 'testproject')
  suite = project.reload.suites.create!(name: 'testsuite')
  suite.runs.create
end

When(/^we visit the runs page$/) do
  visit '/projects/testproject/suites/testsuite/runs/1'
end

Then(/^we should see the run$/) do
  within('h1') do
    expect(page).to have_content('Run #1')
  end
end
