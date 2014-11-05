Feature: JSON Test AGL500794 District for Deconstructed Address

  Background:
    Given I get the JSON for title "AGL500794"

  Scenario: District Path exists for Deconstructed Address
    Then the JSON should have "title_number"
    Then the JSON should have "districts"

  Scenario: District Path value exists for Deconstructed Address
    When the JSON at "title_number" should be "AGL500794"
    Then the JSON at "districts" should be "BARNET"
