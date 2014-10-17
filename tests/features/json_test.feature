Feature: JSON Tests

  Scenario: Title Details Paths exist
    When I get the JSON
    Then the JSON should have "title_number"
    Then the JSON should have "tenure"
    Then the JSON should have "class_of_title"
    Then the JSON should have "edition_date"
    Then the JSON should have "last_application"

  Scenario: Title Details Path Values exist
    #DT158094
    When I get the JSON
    Then the JSON at "title_number" should be "DT158094"
    Then the JSON at "tenure" should be "Leasehold"
    Then the JSON at "class_of_title" should be "Absolute"
    Then the JSON at "edition_date" should be "2005-12-21"
    Then the JSON at "last_application" should be "2005-12-21T00:00:01+00:00"

  Scenario: District Path exists
#(IR) will fail as missing
    When I get the JSON
    Then the JSON should have "title_number"
    Then the JSON should have "districts"

  Scenario: District Path value exist
  #(IR) will fail as missing
    When I get the JSON
    Then the JSON at "title_number" should be "WM786101"
    Then the JSON at "districts" should be "COVENTRY"

  Scenario: District Path exists
    When I get the JSON
    Then the JSON should have "title_number"
    Then the JSON should have "districts"

  Scenario: District Path value exist
    When I get the JSON
    Then the JSON at "title_number" should be "BK507706"
    Then the JSON at "districts" should be "READING"

  Scenario: Office Path exists
    When I get the JSON
    Then the JSON should have "title_number"
    Then the JSON should have "office"

  Scenario: Office Path value exist
    When I get the JSON
    Then the JSON at "title_number" should be "WM786101"
    Then the JSON at "office" should be "Coventry Office"

  Scenario: Office Path value exist
    When I get the JSON
    Then the JSON at "title_number" should be "BK507706"
    Then the JSON at "office" should be "Gloucester Office"

    #GEOMETRY EXTENT TESTS TO DO

  Scenario: Proprietorship paths exist
    When I get the JSON
    Then the JSON should have "title_number"
    Then the JSON should have "proprietorship/template"
    Then the JSON should have "proprietorship/full_text"
    Then the JSON should have "proprietorship/fields"
    Then the JSON should have "proprietorship/fields/proprietors"
    Then the JSON should have "proprietorship/fields/proprietors/0/name"
    Then the JSON should have "proprietorship/fields/proprietors/0/name/title"
    Then the JSON should have "proprietorship/fields/proprietors/0/name/full_name"
    Then the JSON should have "proprietorship/fields/proprietors/0/name/decoration"
    Then the JSON should have "proprietorship/fields/proprietors/0/addresses/0"
    Then the JSON should have "proprietorship/fields/proprietors/0/addresses/0/full_address"
    Then the JSON should have "proprietorship/fields/proprietors/0/addresses/0/house_no"
    Then the JSON should have "proprietorship/fields/proprietors/0/addresses/0/street_name"
    Then the JSON should have "proprietorship/fields/proprietors/0/addresses/0/town"
    Then the JSON should have "proprietorship/fields/proprietors/0/addresses/0/postal_county"
    Then the JSON should have "proprietorship/fields/proprietors/0/addresses/0/region_name"
    Then the JSON should have "proprietorship/fields/proprietors/0/addresses/0/country"
    Then the JSON should have "proprietorship/fields/proprietors/0/addresses/0/postcode"
    Then the JSON should have "proprietorship/deeds"
    Then the JSON should have "proprietorship/notes"

  Scenario: Proprietor Template Values exist
    #WM786101
    When I get the JSON
    Then the JSON at "title_number" should be "WM786101"
    Then the JSON at "proprietorship/template" should include "*RP*"
    Then the JSON at "proprietorship/full_text" should include "PROPRIETOR"

  Scenario: Proprietor Name Values exist
    #DT158094
    When I get the JSON
    Then the JSON at "title_number" should be "DT158094"
    Then the JSON at "proprietorship/fields/proprietors/0/name" should include "EVANGELINE MAY BOSS"
    Then the JSON at "proprietorship/fields/proprietors/0/name/title" should be ""
    Then the JSON at "proprietorship/fields/proprietors/0/name/full_name" should include "MAY"
    Then the JSON at "proprietorship/fields/proprietors/0/name/decoration" should include ""

  Scenario: Proprietor Address String only Values exist
    #WM786101
    When I get the JSON
    Then the JSON at "proprietorship/fields/proprietors/0/addresses/0/" should include "Property Asset Management, Land Registry Head Office, Trafalgar House 1 Bedford Park, Croydon CR0 2AQ"
    Then the JSON at "proprietorship/fields/proprietors/0/addresses/0/full_address" should include "Croydon"

  Scenario: Proprietor Deconstructed Address Values exist
    #GR508500
    When I get the JSON
    Then the JSON at "proprietorship/fields/proprietors/0/addresses/0/" should include "1 Street, Gloucester GL4 6RL"
    Then the JSON at "proprietorship/fields/proprietors/0/addresses/0/full_address" should include "GL4"
    Then the JSON at "proprietorship/fields/proprietors/0/addresses/0/house_no" should be "1"
    Then the JSON at "proprietorship/fields/proprietors/0/addresses/0/street_name" should be "Street"
    Then the JSON at "proprietorship/fields/proprietors/0/addresses/0/town" should be "Gloucester"
    Then the JSON at "proprietorship/fields/proprietors/0/addresses/0/postal_county" should be ""
    Then the JSON at "proprietorship/fields/proprietors/0/addresses/0/region_name" should be ""
    Then the JSON at "proprietorship/fields/proprietors/0/addresses/0/country" should be ""
    Then the JSON at "proprietorship/fields/proprietors/0/addresses/0/postcode" should be "GL4 6RL"

  Scenario: Joint Proprietor Deconstructed Address Values exist
     #GR508500
    When I get the JSON
    Then the JSON at "proprietorship/fields/proprietors/1/addresses/0" should include "Street"

  Scenario: Property Description paths exist
    When I get the JSON
    Then the JSON should have "title_number"
    Then the JSON should have "property_description/template"
    Then the JSON should have "property_description/full_text"
    Then the JSON should have "property_description/fields"
    Then the JSON should have "property_description/fields/addresses"
    Then the JSON should have "property_description/fields/addresses/full_address"
    Then the JSON should have "property_description/fields/addresses/house_no
    Then the JSON should have "property_description/fields/addresses/street_name
    Then the JSON should have "property_description/fields/addresses/town
    Then the JSON should have "property_description/fields/addresses/postal_county
    Then the JSON should have "property_description/fields/addresses/region_name
    Then the JSON should have "property_description/fields/addresses/country
    Then the JSON should have "property_description/fields/addresses/postcode
    Then the JSON should have "property_description/deeds"
    Then the JSON should have "property_description/notes"

  Scenario: Property Description Address String only values exist
    #BK507706
    When I get the JSON
    Then the JSON at "title_number" should be "BK507706"
    Then the JSON at "property_description/template" should include "*AD*"
    Then the JSON at "property_description/full_text" should include "shown edged with red"
    Then the JSON at "property_description/fields/addresses" should include "45 Goulam Heights, Bracknell"
    Then the JSON at "property_description/fields/addresses/full_address" should include "Heights"
    Then the JSON at "property_description/fields/addresses/house_no" should be ""
    Then the JSON at "property_description/fields/addresses/street_name" should be ""
    Then the JSON at "property_description/fields/addresses/town" should be ""
    Then the JSON at "property_description/fields/addresses/postal_county" should be ""
    Then the JSON at "property_description/fields/addresses/region_name" should be ""
    Then the JSON at "property_description/fields/addresses/country" should be ""
    Then the JSON at "property_description/fields/addresses/postcode" should be ""
    Then the JSON at "property_description/deeds" should be [ ]
    Then the JSON at "property_description/notes" should be [ ]

  Scenario: Property Description Deconstructed Address values exist
    #GR508500
    When I get the JSON
    Then the JSON at "title_number" should be "GR508500"
    Then the JSON at "property_description/template" should include "*AD*"
    Then the JSON at "property_description/full_text" should include "shown edged with red"
    Then the JSON at "property_description/fields/addresses" should include "Teddington Gardens"
    Then the JSON at "property_description/fields/addresses/full_address" should include "Gardens"
    Then the JSON at "property_description/fields/addresses/house_no" should be "21"
    Then the JSON at "property_description/fields/addresses/street_name" should be "Teddington Gardens"
    Then the JSON at "property_description/fields/addresses/town" should be "Gloucester"
    Then the JSON at "property_description/fields/addresses/postal"_county should be "Gloucestershire"
    Then the JSON at "property_description/fields/addresses/region_name" should be ""
    Then the JSON at "property_description/fields/addresses/country" should be ""
    Then the JSON at "property_description/fields/addresses/postcode" should be "GL4 6RL"
    Then the JSON at "property_description/deeds" should be [ ]
    Then the JSON at "property_description/notes" should be [ ]

  Scenario: Price Paid Paths exist
    When I get the JSON
    Then the JSON should have "title_number"
    Then the JSON should have "price_paid/template"
    Then the JSON should have "price_paid/full_text"
    Then the JSON should have "price_paid/fields/date"
    Then the JSON should have "price_paid/fields/amount"
    Then the JSON should have "price_paid/deeds"
    Then the JSON should have "price_paid/notes"

  Scenario: Price Paid Path Values exist
    When I get the JSON
    Then the JSON at "title_number" should be "BK507706"
    Then the JSON at "price_paid/template" should include "*DA*"
    Then the JSON at "price_paid/full_text" should be "The price stated to have been paid on 8 December 2003 was £200,000."
    Then the JSON at "price_paid/fields/date" should include "2003-12-08"
    Then the JSON at "price_paid/fields/amount" should include "£200,000"

  Scenario: Restrictive Covenants Template paths exist
    When I get the JSON
    Then the JSON should have "title_number"
    Then the JSON should have "restrictive_covenants/0/template"
    Then the JSON should have "restrictive_covenants/0/full_text"

  Scenario: Restrictive Covenants Fields paths exist
    Then the JSON should have "restrictive_covenants/0/fields"
   #Then the JSON should have "restrictive_covenants/0/fields/date" to be removed from sample data
    Then the JSON should have "restrictive_covenants/0/fields/extent"

  Scenario: Restrictive Covenants Deeds paths exist
    Then the JSON should have "restrictive_covenants/0/deeds/0"
    Then the JSON should have "restrictive_covenants/0/deeds/0/type"
    Then the JSON should have "restrictive_covenants/0/deeds/0/date"
    Then the JSON should have "restrictive_covenants/0/deeds/0/parties/0"
    Then the JSON should have "restrictive_covenants/0/deeds/0/parties/0/0/title"
    Then the JSON should have "restrictive_covenants/0/deeds/0/parties/0/0/full_name"
    Then the JSON should have "restrictive_covenants/0/deeds/0/parties/0/0/decoration"

  Scenario: Restrictive Covenants Notes paths exist
    Then the JSON should have "restrictive_covenants/0/notes"
    Then the JSON should have "restrictive_covenants/0/notes/0/text"
    Then the JSON should have "restrictive_covenants/0/notes/0/documents_referred"

  Scenario: Restrictions paths exist
    When I get the JSON
    Then the JSON should have "restrictions/0/template"
    Then the JSON should have "restrictions/0/full_text"
    Then the JSON should have "restrictions/0/fields"
    Then the JSON should have "restrictions/0/fields/miscellaneous/0"
    Then the JSON should have "restrictions/0/deeds"
    Then the JSON should have "restrictions/0/notes"

  Scenario: Bankruptcy paths exist
    #BK507681
    When I get the JSON
    Then the JSON should have "bankruptcy/0/template"
    Then the JSON should have "bankruptcy/0/full_text"
    Then the JSON should have "bankruptcy/0/fields"
    #Then the JSON should have "bankruptcy/0/fields/name/0" will fail as infill type is not recognised
    Then the JSON should have "bankruptcy/0/fields/miscellaneous/0"
    Then the JSON should have "bankruptcy/0/deeds"
    Then the JSON should have "bankruptcy/0/notes"

  Scenario: Easements Template paths exist
    #BK508401
    When I get the JSON
    Then the JSON should have "title_number"
    Then the JSON should have "easements/0/template"
    Then the JSON should have "easements/0/full_text"

  Scenario: Easements Fields paths exist
    Then the JSON should have "easements/0/fields"
    Then the JSON should have "easements/0/fields/extent/0"

  Scenario: Easements Deeds paths exist
    Then the JSON should have "easements/0/deeds/0"
    Then the JSON should have "easements/0/deeds/0/type"
    Then the JSON should have "easements/0/deeds/0/date"
    Then the JSON should have "easements/0/deeds/0/parties/0"
    Then the JSON should have "easements/0/deeds/0/parties/0/0/title"
    Then the JSON should have "easements/0/deeds/0/parties/0/0/full_name"
    Then the JSON should have "easements/0/deeds/0/parties/0/0/decoration"

  Scenario: Easements Notes paths exist
    Then the JSON should have "easements/0/notes"
    Then the JSON should have "easements/0/notes/0/text"
    Then the JSON should have "easements/0/notes/0/documents_referred"