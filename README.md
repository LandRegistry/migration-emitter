# Migration Emitter

This Ruby library is used to transform data items extracted from the legacy register of titles into the JSON format used to hold a title in the [system of record](https://github.com/LandRegistry/system-of-record).

The generated JSON format is tested using the Python [datatype](https://github.com/LandRegistry/datatypes) library.

Using an intermediate data model enables the team extracting the complex title information from the legacy database to be slightly decoupled from the format used by the [the mint](https://github.com/LandRegistry/mint), which is slowly emerging, in answer to needs of users, rather than previously understood business requirements, some of which may no longer apply.
