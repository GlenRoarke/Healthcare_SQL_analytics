# Healthcare Analytics SQL

## Authors
Glen Roarke

## Description

### T-SQL

This is a storage of some health analytics SQL code I have used last year within the NHS. The majority of this code was visualised using SSRS and powerBI type programs. 
Systems used include PAS, Maternity, and Pharmacy here.

There is a strong data quality focus here to improve the commission data set (CDS), implement new PAS merger requirements via ETL processes.

### ETL via SSIS

There are examples of import packages for large NHS datasets such as the inpatient CDS.

'DailyMissingInfoReport- Auto Email Large list' is an automated package I created to loop through and email a distribution list.
It is possible to update the email disribution lists by SQL stored procedures in the source database.


