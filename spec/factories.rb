FactoryGirl.define do
  factory :project do
    name 'spec_project'
  end

  factory :suite do
    name 'spec_suite'
    project
  end

  factory :run do
    suite
  end

  factory :test do
    name 'rspec_test'
    browser 'na'
    platform 'na'
    size '0'
    run
  end
end
