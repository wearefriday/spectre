Feature: Failing tests for runs
  Background:
    Given there is a run with a failing test
    When we visit the runs page

  @javascript
  Scenario: showing the run
    Then we should see the run

  @javascript
  Scenario: showing a test on the run page
    Then we should see the failing test
