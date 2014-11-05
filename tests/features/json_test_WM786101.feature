Feature: JSON Test WM786101 District and Office for Address String

  Background:
    Given I get the JSON for title "WM786101"

  Scenario: District and Office Paths exists for Address String
    Then the JSON should have "title_number"
    Then the JSON should have "districts"
    Then the JSON should have "office"

  Scenario: District abd Office Path values exists for Address String
    When the JSON at "title_number" should be "WM786101"
    Then the JSON at "districts" should be "COVENTRY"
    Then the JSON at "office" should be "Coventry Office"

