
# Data Hub Framework - Schematron Validation Example

## Prerequisites

* Java SE JDK 11 or later
* MarkLogic Server (See Version Compatibility.)
* Chrome or Firefox for Hub Central

## Versions Tested

* MarkLogic 10.0-9.2
* Data Hub 5.7.2
* Data Hub Central 5.7.2

## Building/Deploying

* Use the included gradle wrapper to execute Data Hub tasks
* Inital deployment `./gradlew mlDeploy -i`
* Run `./gradlew schematronPut -i` to deploy the schematron xslts for validation. This will process all Schematrons placed in the schemas database. See `src/main/ml-schemas/schematron` for examples.
* Start hub central by executing java -jar marklogic-data-hub-central-5.7.2.war in a separate terminal

## Sample Data and Flow

* Data is located in `data/invocies` and `data/invocies`
* The flow `FinancialFlow` will load and map data accordingly
* There is a step interceptor that is part of the mapping step to run validations.
    * Note: This step can be used with any schematron and data. See the step defintion (`steps/mapping/MapInvoice.step.json`) for step intercetpor config with schematron. 
* Validation errors will be persisted to the headers. Additionally a TDE will index the data.

## Data Validation Rules

* Invoice Line Item Total must be calculated correctly based off unit price and quanity
* Invoice Total must be the sum of all the unit totals
* Invoice product category must be in a controlled list.
* Organization Zip codes must be 5 or 9 digit patterns.

## Data Validation Status 

* Validation failures will appear in the header of the envelope. 
* Validation failures are soft and mark records with additional collections
* TDE View available to see a report of errors. 

```
-- query

select * from Validation.Schematron
limit 100
```

