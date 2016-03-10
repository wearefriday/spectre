if Rails.env.development?
  require 'capybara'
  require 'capybara/poltergeist'
  require 'rest_client'
  require 'dotenv/tasks'
  require 'spectre_client'
  require 'rmagick'

  desc "gets some screens from nuffield health"
  task :screenshots do
    spectre = SpectreClient::Client.new('Nuffield', 'Templates', "#{ENV['PROTOCOL']}#{ENV['DOMAIN_NAME']}#{ENV['PORT']}")
    puts "Created Specture run"
    sleep(2)

    setup_poltergeist

    visit "http://www.nuffieldhealth.com/"
    sleep(2)
    screenshot_file = 'homepage.png'
    page.save_screenshot(screenshot_file)
    puts "Saved screenshot #{screenshot_file}"

    home_options = {
      name: 'Homepage',
      browser: 'Phantom',
      platform: 'OSX',
      size: 1024,
      screenshot: File.new(screenshot_file, 'rb')
    }
    spectre.submit_test(home_options)

    puts "Submitting #{screenshot_file}"
    File.delete(screenshot_file)

    Capybara.reset_sessions!

    visit "http://www.nuffieldhealth.com/gyms/"
    sleep(2)
    screenshot_file = 'gyms.png'
    page.save_screenshot(screenshot_file)
    puts "Saved screenshot #{screenshot_file}"

    gym_options = {
      name: 'Gyms Division',
      browser: 'Phantom',
      platform: 'OSX',
      size: 1024,
      screenshot: File.new(screenshot_file, 'rb')
    }
    spectre.submit_test(gym_options)
    puts "Submitting #{screenshot_file}"
    File.delete(screenshot_file)

    Capybara.reset_sessions!

    visit "http://www.nuffieldhealth.com/about-us/"
    sleep(2)
    screenshot_file = 'about_us.png'
    page.save_screenshot(screenshot_file)
    puts "Saved screenshot #{screenshot_file}"
    about_options = {
      name: 'Gyms Division',
      browser: 'Phantom',
      platform: 'OSX',
      size: 1024,
      screenshot: File.new(screenshot_file, 'rb'),
      fuzz_level: '90%'
    }
    spectre.submit_test(about_options)
    puts "Submitting #{screenshot_file}"
    File.delete(screenshot_file)


    puts "End"
  end

  desc "get a grab from wearefriday.com abd draw on it to ensure it fails each test"
  task :failing_test do
    spectre = SpectreClient::Client.new('We are friday', 'site', "#{ENV['PROTOCOL']}#{ENV['DOMAIN_NAME']}#{ENV['PORT']}")
    puts "Created Specture run"
    sleep(2)
    setup_poltergeist

    visit "http://www.wearefriday.com/"
    sleep(2)
    screenshot_file = 'homepage.png'
    page.save_screenshot(screenshot_file)
    draw_on_screenshot
    puts "Saved screenshot #{screenshot_file}"
    home_options = {
      name: 'Homepage',
      browser: 'Phantom',
      platform: 'OSX',
      size: 1024,
      screenshot: File.new(screenshot_file, 'rb')
    }
    spectre.submit_test(home_options)
    puts "Submitting #{screenshot_file}"
    File.delete(screenshot_file)

    Capybara.reset_sessions!

  end

  def setup_poltergeist
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
  end

  def draw_on_screenshot
    image = Magick::Image.read('homepage.png').first
    x = rand(0..image.columns)
    y = rand(0..image.rows)
    gc = Magick::Draw.new
    gc.stroke = 'white'
    gc.fill = 'white'
    gc.rectangle x, y, 10, 10
    gc.draw(image)
    image.write 'homepage.png'
  end
end
