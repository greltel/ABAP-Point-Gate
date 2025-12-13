🚧 Status: Under Development

# ABAP Point Gate

The ABAP Point Gate is a structured approach to managing ABAP exit points by isolating custom code

## License
This project is licensed under the [MIT License](https://github.com/greltel/ABAP-Point-Gate/blob/main/LICENSE).

## Contributors-Developers
The repository was created by [George Drakos](https://www.linkedin.com/in/george-drakos/).

## Motivation for Creating the Repository

ABAP Point Gate to provide a standardized “gate” around ABAP exit points/enhancements, so custom logic stays isolated from the SAP core instead of being scattered across standard objects. This helps keep the system clean, maintainable, and upgrade-friendly, while offering a consistent way to implement enhancements that aligns with Clean Core / ABAP Cloud readiness practices and encourages quality through automated checks (e.g. abaplint) and unit testing.

## Design Goals/Features

* Install via [ABAPGit](http://abapgit.org)
* ABAP Cloud/Clean Core compatibility.Passed SCI check variant S4HANA_READINESS_2023 and ABAP_CLOUD_READINESS
* Unit Tested
* [ABAPLint](https://github.com/apps/abaplint) checked
