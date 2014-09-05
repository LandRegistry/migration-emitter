# Migration Emitter

This Ruby library is used to transform data items extracted from the legacy database of titles into the JSON format used to hold a title in the [system of record](https://github.com/LandRegistry/system-of-record).

The generated JSON format is tested using the Python [datatype](https://github.com/LandRegistry/datatypes) library.

Using an intermediate data model enables the complex process of extracting title information from legacy systems to be decoupled from the constrained document format used by the [the mint](https://github.com/LandRegistry/mint) which is slowly emerging to answer stories driven by [user needs](https://www.gov.uk/design-principles#first).
