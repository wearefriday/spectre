# Spectre

Spectre is a web application to diff screenshots. It's heavily influence by [VisualReview](https://github.com/xebia/VisualReview), [BackstopJS](https://github.com/garris/BackstopJS) and [Wraith](https://github.com/BBC-News/wraith).

![Spectre!](spectre_screenshot.png)

## Requirements

* Postgres
* Imagemagick

## Setup

* Clone the repo
* `bundle exec rake db:create && bundle exec rake db:schema:load`
* `bundle exec rails s`
* Copy `.env.example` and rename to `.env`. Change the url details if you need to.

## Submitting tests

A "test" is a screenshot and associated metadata. A test is categorised under a Project, which in turn has (test) Suites. A test is submitted and associated with a "run" of a suite.

First you should create a new "run". The JSON response will contain the `run_id` to submit with each subsequent test.

    POST /runs
      project: My Projetc Name
      suite: My Suite Name

Then you can submit a screenshot!

    POST /tests
      test:
        run_id: {run_id from above},
        name: Homepage,
        platform: OSX,
        browser: PhantomJS,
        width: 1024,
        screenshot: <File>

* `name` is a friendly name of your test. It should describe the template, component or state of the thing you've screenshotted
* `platform` is the OS/platform that the screenshot was taken on (e.g. OSX, Windows, iOS, Android etc.)
* `browser` is the browser that was used to render the screenshot. This will usually be a headless webkit such as Phantom, but if using Selenium you may have used a "real" browser
* `width` is the screenshot size
* `screenshot` is the image itself. PNGs are preferred

## Dummy tests

An example test run can be executed using:

    bundle exec rake screenshots

## Administration

Spectre doesn't provide a UI or API to edit or delete content. We've included `rails_admin`, so head to `/admin` for this. By default there is no password.

## TODO

* refactor to remove code from fat controllers
* ability to get a canonical link to the baseline screenshot for a named test (e.g. ability to hotlink a screenshot into a component library)
* test coverage is currently nil
* upgrade to Rails 5 when released
* use ActionCable on Run::show view to update list as tests are submitted
* disable a test if it fails more than n times (see below)
* ability to set the "fuzz" factor on a per-test basis that overrides the default. e.g. the stat component antialiasing (http://spectre.tools.fridayengineering.net/projects/hsbc-cmb-pws/suites/components/runs/10?name=statistic&browser=&platform=&size=375&result=Failed)
* refactor "width" property of a test to be more generic "size" so that it can support form factor e.g. "mobile", "tablet". won't always be a numeric width
* mark a test as passed when it's set as a baseline
* ability to hide/mask specific dom elements per test which we do not control e.g. http://spectre.tools.fridayengineering.net/projects/hsbc-cmb-pws/suites/templates/runs/15?name=branch_locator&browser=&platform=&size=375&result=Failed

### Disabling a test if it fails more than N times
Occassionaly we get a repo that has nightly tests that fail repeatedly for more than a week. In this instance we keep collecting screenshots (because we keep screenshots for failed tests). It'd be useful to be able to disable a job from within Spectre, either:
* disable a project so that new runs cannot be created
* configure a threshhold after which each individual tests are disabled, to reduce noise. Or auto-disable a project if there are consistent failures on every run? Would need a way to re-enable them.
