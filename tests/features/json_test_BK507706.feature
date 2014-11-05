Feature: JSON Test BK507706 District for Address String

  Background:
    Given I get the JSON for title "BK507706"

  Scenario: District and Office Paths exists for Address String
    Then the JSON should have "title_number"
    Then the JSON should have "districts"
    Then the JSON should have "office"

  Scenario: District and Office Path values exists for Address String
    When the JSON at "title_number" should be "BK507706"
    Then the JSON at "districts" should be "READING"
    Then the JSON at "office" should be "Gloucester Office"