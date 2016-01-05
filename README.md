# Spectre

Spectre is a web application to diff screenshots. It's heavily influence by [VisualReview](https://github.com/xebia/VisualReview), [BackstopJS](https://github.com/garris/BackstopJS) and [Wraith](https://github.com/BBC-News/wraith).

## Requirements

* Postgres
* Imagemagick

## Setup

* Clone the repo
* `bundle exec rake db:create && bundle exec rake db:migrate`
* `bundle exec rails s`

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

## TODO

* massively refactor to remove code from fat controllers
* JSON output for a whole Run rather than a single test?
* ability to get a canonical link to the baseline screenshot for a named test (e.g. ability to hotlink a screenshot into a component library)
* sort out routing, currently they're not nested resources but probably could be
* test coverage is currently nil
