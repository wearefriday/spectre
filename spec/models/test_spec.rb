RSpec.describe Test do
  it 'flags if the tests has failed more than five consecutive times' do
    project = Project.create!(name: 'spec_project')
    suite = project.suites.create!(name: 'spec_suite')
    run = suite.runs.create!
    test_params = {
      name: 'rspec_test',
      browser: 'na',
      platform: 'na',
      size: '0'
    }
    5.times do
      run.tests.create!(test_params)
    end
    test = run.tests.create!(test_params)
    expect(test.five_consecutive_failures).to eq true
  end
end
