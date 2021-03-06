# Migration Emitter

[![Build Status](https://travis-ci.org/LandRegistry/migration-emitter.svg)](https://travis-ci.org/LandRegistry/migration-emitter)

This Ruby library is used to transform data items extracted from the legacy database of titles into the JSON format used to hold a title in the [system of record](https://github.com/LandRegistry/system-of-record).

The generated JSON format is tested using the Python [datatype](https://github.com/LandRegistry/datatypes) library.

Using an intermediate data model enables the complex process of extracting title information from legacy systems to be decoupled from the constrained document format used by the [the mint](https://github.com/LandRegistry/mint) which is slowly emerging to answer stories driven by [user needs](https://www.gov.uk/design-principles#first).

###migration_emitter

The migration emitter app is written in jRuby and runs on a Torquebox server. The app consumes messages from a queue which contains a hash (key/value pairs) for each migrating title.
The hash will is reconstructed into the appropriate JSON format using the Jbuilder rubygem. The finished JSON is then posted to the mint.

### Title JSON Structure

A title is really just a list of entries, where each entry is a different piece of text. The entry text is made from four pieces of information: text, fields, deeds and notes. Consequently the JSON structure for an entry looks like this:

<pre>
  {
    "template" : "example text with markup",
    "full_text" : "example text with markup replaced with real values",
    "fields" : {a list of fields},
    "deeds" : [an array of deeds],
    "notes" : [an array of notes]
  }  
</pre>

The text field will contain markup such as:

<pre>
  A *DT**DE* dated *DD* made between *DP* contains the following provision:-*VT*
</pre>

Each piece of markup i.e. *DT* will be replaced with either a field, deed, or note. Once each piece of markup has been replaced you have the full text for the entry.

A deed looks like this;
<pre>
{
    "type" : string,
    "date" : date,
    "parties" : [2 or more parties]
}
</pre>

<pre>
And a party to a deed looks like this
{
    "title" : string,
    "full_name" : string,
    "decoration" : string
}
</pre>

An address looks like this:

<pre>
{
    "full_address": "8 Miller Way, Plymouth, Devon, PL6 8UQ",
    "house_no" : "8",
    "street_name" : "Miller Way",
    "town" : "Plymouth",
    "postal_county" : "Devon",
    "region_name" : "",
    "country" : "",
    "postcode":""
}
</pre>

*Note* that only full_address is guaranteed to be populated.


The entries can then be grouped together based upon user need i.e provisions, easements, restrictions etc...

Therefore, with the addition of the extent section, the title template should look like this:

<pre>

  {

    "title_number" : "TEST_AB1234567",
    "tenure":"Absolute",
    "class_of_title":"Freehold",
    "edition_date":"10.05.2005",

    "extent": {
        "type": "Feature",
        "crs": {  
            "type":"name",
            "properties":{  
                "name":"urn:ogc:def:crs:EPSG:27700"
            }
        },
        "geometry":{  
            "type":"Polygon",
            "coordinates":[  
                [[530857.01,181500.00],
                [530857.00,181500.00],
                [530857.00,181500.00],
                [530857.00,181500.00],
                [530857.01,181500.00]]
            ]
        },
        "properties":{
        }
    }

    "proprietorship" : an entry,
    "property_description" : an entry,
    "price_paid" : an entry,
    "provisions" : [array of entries],
    "easements" : [array of entries],
    "restrictive_covenants" : [array of entries],
    "restrictions" : [array of entries],
    "bankruptcy" : [array of entries],
    "charges" : [array of entries],
    "h_schedule" : an array,
    "other" : [array of entries]

  }

</pre>

However, we have several existing fields in the JSON that I will leave in in this first pass in order to not break the current services. The resulting structure is:

<pre>

    {
            "title_number": "TEST_AB1234567",
            "tenure":"Absolute",
            "class_of_title":"Freehold",
            "edition_date":"10.05.2005",

            "proprietors": [
                {
                    "full_name": "firstname lastname"
                },
                {
                    "full_name": "firstname lastname"
                }
            ],

            "property" : {
                "address": {
                    "house_number": "house number",
                    "road": "road",
                    "town": "town",
                    "postcode": ""
                },

                "tenure": "freehold|leasehold",
                "class_of_title": "absolute|good|qualified|possesory"
            },


            "payment": {
                "price_paid": "12345",
                "titles": ["TEST_AB1234567"]
            },

            "extent": {
                "type": "Feature",
                "crs": {  
                    "type":"name",
                    "properties":{  
                        "name":"urn:ogc:def:crs:EPSG:27700"
                    }
                },
                "geometry":{  
                    "type":"Polygon",
                    "coordinates":[  
                        [[530857.01,181500.00],
                        [530857.00,181500.00],
                        [530857.00,181500.00],
                        [530857.00,181500.00],
                        [530857.01,181500.00]]
                    ]
                },
                "properties":{
                }
            }

            "proprietorship" : an entry,
            "property_description" : an entry,
            "price_paid" : an entry,
            "provisions" : [array of entries],
            "easements" : [array of entries],
            "restrictive_covenants" : [array of entries],
            "restrictions" : [array of entries],
            "bankruptcy" : [array of entries],
            "charges" : [array of entries],
            "h_schedule" : an entry,
            "other" : [array of entries]
    }

</pre>
