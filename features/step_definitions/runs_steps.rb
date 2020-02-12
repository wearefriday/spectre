# frozen_string_literal: true

Given(/^there is a run with a failing test$/) do
  project = Project.create!(name: 'testproject')
  suite = project.reload.suites.create!(name: 'testsuite')
  run = suite.runs.create

  screenshots = ['run1.png', 'run2.png']

  # TODO: create test using controller methods rather than a post.
  #       this will remove the poltergiest dependecy.
  screenshots.each do |screenshot|
    RestClient.post(
      "#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/tests",
      test: {
        run_id: run.id,
        name: 'test test',
        browser: 'poltergiest',
        size: '1024',
        screenshot: File.open("features/support/screenshots/#{screenshot}")
      }
    )
  end
end

When(/^we visit the runs page$/) do
  visit '/projects/testproject/suites/testsuite/runs/1'
end

Then(/^we should see the run$/) do
  within('h1') do
    expect(page).to have_content('Run #1')
  end
end

Then(/^we should see the failing test$/) do
  expect(page).to have_css('#test_2')
end
