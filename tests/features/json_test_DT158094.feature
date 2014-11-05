Feature: JSON Test DT158094 Title Details

  Background:
    Given I get the JSON for title "DT158094"

  Scenario: Title Details Paths exist
    Then the JSON should have "title_number"
    Then the JSON should have "tenure"
    Then the JSON should have "class_of_title"
    Then the JSON should have "edition_date"
    Then the JSON should have "last_application"

  Scenario: Title Details Path Values exist
    #DT158094
    Then the JSON at "title_number" should be "DT158094"
    Then the JSON at "tenure" should be "Leasehold"
    Then the JSON at "class_of_title" should be "Absolute"
    Then the JSON at "edition_date" should be "2005-12-21"
    Then the JSON at "last_application" should be "2005-12-21T00:00:01+00:00"
