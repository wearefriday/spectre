if Rails.env.development?
  require 'capybara'
  require 'capybara/poltergeist'
  require 'rest_client'
  require 'dotenv/tasks'
  require 'spectre_client'

  desc "gets some screens from nuffield health"
  task :screenshots do
    spectre = SpectreClient::Client.new('Nuffield', 'Templates', "#{ENV['PROTOCOL']}#{ENV['DOMAIN_NAME']}#{ENV['PORT']}")
    puts "Created Specture run"
    sleep(2)


    include Capybara::DSL

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {
        js_errors: false,
        timeout: 30,
        debug: true
      })
    end

    Capybara.configure do |config|
      config.default_driver = :poltergeist
      config.run_server = false
      config.default_max_wait_time = 5
    end

    Capybara.reset_sessions!

    visit "http://www.nuffieldhealth.com/"
    sleep(2)
    screenshot_file = 'homepage.png'
    page.save_screenshot(screenshot_file)
    puts "Saved screenshot #{screenshot_file}"
    spectre.submit_test('Homepage', 'Phantom', 'OSX', 1024, File.new(screenshot_file, 'rb'))
    puts "Submitting #{screenshot_file}"
    File.delete(screenshot_file)

    Capybara.reset_sessions!

    visit "http://www.nuffieldhealth.com/gyms/"
    sleep(2)
    screenshot_file = 'gyms.png'
    page.save_screenshot(screenshot_file)
    puts "Saved screenshot #{screenshot_file}"
    spectre.submit_test('Gyms Division', 'Phantom', 'OSX', 1024, File.new(screenshot_file, 'rb'))
    puts "Submitting #{screenshot_file}"
    File.delete(screenshot_file)

    Capybara.reset_sessions!

    visit "http://www.nuffieldhealth.com/about-us/"
    sleep(2)
    screenshot_file = 'about_us.png'
    page.save_screenshot(screenshot_file)
    puts "Saved screenshot #{screenshot_file}"
    spectre.submit_test('About Us', 'Phantom', 'OSX', 1024, File.new(screenshot_file, 'rb'))
    puts "Submitting #{screenshot_file}"
    File.delete(screenshot_file)


    puts "End"
  end



end
