Feature: Tests for runs
  Scenario: showing the run
    Given there is a run
    When we visit the runs page
    Then we should see the run
