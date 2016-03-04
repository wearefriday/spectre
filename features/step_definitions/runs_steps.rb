Given(/^there is a run with a test$/) do
  project = Project.create!(name: 'testproject')
  suite = project.reload.suites.create!(name: 'testsuite')
  suite.runs.create

  # TODO: create test using controller methods rather than a post.
  #       this will remove the poltergiest dependecy.
  RestClient.post(
        "#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}/tests",
        test: {
          run_id: 1,
          name: 'test test',
          platform: 'osx',
          browser: 'poltergiest',
          size: '1024',
          screenshot: File.open('features/support/screenshots/run1.png')
        }
      )
end

When(/^we visit the runs page$/) do
  visit '/projects/testproject/suites/testsuite/runs/1'
end

Then(/^we should see the run$/) do
  within('h1') do
    expect(page).to have_content('Run #1')
  end
end

Then(/^we should see the test$/) do
  expect(page).to have_css('#test_1')
end
