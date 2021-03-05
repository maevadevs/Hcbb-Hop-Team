// Needed CSV Exports from Database
// ********************************
// Checkout notebook/maeva-05-export-csv-for-neo4j.ipynb for implementation details
// - providers.csv: Exported from SQL-Lite npidata with applied filters: entity_type_code == 1
// - facilities.csv: Exported from SQL-Lite npidata with applied filters: entity_type_code == 2
// - filtered_hop_teaming.csv: Exported from SQL-Lite filtered_hop_teaming: Check notebook/maeva-04-filtering-hop-teaming-to-smaller-table.ipynb for implementation details
// - specializations.csv: Exported from SQL-Lite taxonomy with only taxonomy_code and non-null Specializations
// - classifications.csv: Exported from SQL-Lite taxonomy with only taxonomy_code and non-null Classifications
// - groupings.csv: Exported from SQL-Lite taxonomy with only taxonomy_code and non-null Groupings

// Create the models first
CREATE CONSTRAINT ON (p:Provider) ASSERT p.npi IS UNIQUE;
CREATE CONSTRAINT ON (f:Facility) ASSERT f.npi IS UNIQUE;
CREATE CONSTRAINT ON (s:Specialization) ASSERT s.taxonomy_code IS UNIQUE;
CREATE CONSTRAINT ON (g:Grouping) ASSERT g.taxonomy_code IS UNIQUE;
CREATE CONSTRAINT ON (c:Classification) ASSERT c.taxonomy_code IS UNIQUE;



// NODE: Provider
// **************
USING PERIODIC COMMIT 1000 // This is important for loading in batch
LOAD CSV WITH HEADERS FROM
'file:///providers.csv' AS line // Exported from SQL-Lite npidata with applied filters: entity_type_code == 1

// MERGE or CREATE Provider nodes
MERGE (p:Provider{ npi: line.npi })
// SET the properties on Provider
SET p.last_name = line.provider_last_name,
    p.first_name = line.provider_first_name,
    p.middle_name = line.provider_middle_name,
    p.name_prefix = line.provider_name_prefix,
    p.name_suffix = line.provider_name_suffix,
    p.credential = line.provider_credential,
    p.business_address_1 = line.provider_business_address_1,
    p.business_address_2 = line.provider_business_address_2,
    p.city = line.provider_business_city,
    p.state = line.provider_business_state,
    p.zip = line.provider_business_zip5,
    p.primary_taxonomy_code = line.taxonomy_code
;



// NODE: Facility
// **************
USING PERIODIC COMMIT 1000 // This is important for loading in batch
LOAD CSV WITH HEADERS FROM
'file:///facilities.csv' AS line // Exported from SQL-Lite npidata with applied filters: entity_type_code == 2

// MERGE or CREATE Facility nodes
MERGE (f:Facility{ npi: line.npi })
// SET the properties on Facility
SET f.org_name = line.provider_org_name,
    f.business_address_1 = line.provider_business_address_1,
    f.business_address_2 = line.provider_business_address_2,
    f.city = line.provider_business_city,
    f.state = line.provider_business_state,
    f.zip = line.provider_business_zip5,
    f.primary_taxonomy_code = line.taxonomy_code
;



// NODE: Classification
// ********************
USING PERIODIC COMMIT 1000 // This is important for loading in batch
LOAD CSV WITH HEADERS FROM
'file:///classifications.csv' AS line // Exported from SQL-Lite taxonomy with only taxonomy_code and non-null Classifications

// MERGE or CREATE Classification nodes
MERGE (c:Classification{ taxonomy_code: line.taxonomy_code, classification_name: line.classification })
;


// NODE: Specialization
// ********************
USING PERIODIC COMMIT 1000 // This is important for loading in batch
LOAD CSV WITH HEADERS FROM
'file:///specializations.csv' AS line // Exported from SQL-Lite taxonomy with only taxonomy_code and non-null Specializations

// MERGE or CREATE Specialization nodes
MERGE (s:Specialization{ taxonomy_code: line.taxonomy_code, specialization_name: line.specialization })
;



// NODE: Grouping
// **************
USING PERIODIC COMMIT 1000 // This is important for loading in batch
LOAD CSV WITH HEADERS FROM
'file:///groupings.csv' AS line // Exported from SQL-Lite taxonomy with only taxonomy_code and non-null Groupings

// MERGE or CREATE Grouping nodes
MERGE (g:Grouping{ taxonomy_code: line.taxonomy_code, grouping_name: line.grouping })
;



// RELATIONSHIP: (Provider)-[:REFERS_TO]->(Facility)
// *************************************************
USING PERIODIC COMMIT 1000 // This is important for loading in batch
LOAD CSV WITH HEADERS FROM
'file:///filtered_hop_teaming.csv' AS line // Exported from SQL-Lite filtered_hop_teaming with applied filters: entity_type_code == 2

MATCH (p:Provider{ npi: line.from_npi })
MATCH (f:Facility{ npi: line.to_npi })

// Create the relationship
CREATE (p)-[ref:REFERS_TO]->(f)

// SET the properties on REFERS_TO
SET ref.patient_count = line.patient_count,
    ref.transaction_count = line.transaction_count,
    ref.average_day_wait = line.average_day_wait,
    ref.std_day_wait = line.std_day_wait
;



// RELATIONSHIP: (Provider)-[:IN_SPECIALIZATION]->(Specialization)
// ***************************************************************
// Select the Providers with the matching primary taxonomy codes in Specialization
MATCH (p:Provider)
MATCH (s:Specialization)
WHERE p.primary_taxonomy_code = s.taxonomy_code

// Create the Specialization relationship
CREATE (p)-[:IN_SPECIALIZATION]->(s)
;



// RELATIONSHIP: (Facility)-[:IN_SPECIALIZATION]->(Specialization)
// ***************************************************************
// Select the Facilities with the matching primary taxonomy codes in Specialization
MATCH (f:Facility)
MATCH (s:Specialization)
WHERE f.primary_taxonomy_code = s.taxonomy_code

// Create the Specialization relationship
CREATE (f)-[:IN_SPECIALIZATION]->(s)
;



// RELATIONSHIP: (Provider)-[:IN_CLASSIFICATION]->(Classification)
// ***************************************************************
// Select the Providers with the matching primary taxonomy codes in Classification
MATCH (p:Provider)
MATCH (c:Classification)
WHERE p.primary_taxonomy_code = c.taxonomy_code

// Create the Classification relationship
CREATE (p)-[:IN_CLASSIFICATION]->(c)
;



// RELATIONSHIP: (Facility)-[:IN_CLASSIFICATION]->(Classification)
// ***************************************************************
// Select the Facilities with the matching primary taxonomy codes in Classification
MATCH (f:Facility)
MATCH (c:Classification)
WHERE f.primary_taxonomy_code = c.taxonomy_code

// Create the Classification relationship
CREATE (f)-[:IN_CLASSIFICATION]->(c)
;



// RELATIONSHIP: (Provider)-[:IN_GROUPING]->(Grouping)
// ***************************************************************
// Select the Providers with the matching primary taxonomy codes in Grouping
MATCH (p:Provider)
MATCH (g:Grouping)
WHERE p.primary_taxonomy_code = g.taxonomy_code

// Create the Grouping relationship
CREATE (p)-[:IN_GROUPING]->(g)
;



// RELATIONSHIP: (Facility)-[:IN_GROUPING]->(Grouping)
// ***************************************************************
// Select the Facilities with the matching primary taxonomy codes in Grouping
MATCH (f:Facility)
MATCH (g:Grouping)
WHERE f.primary_taxonomy_code = g.taxonomy_code

// Create the Grouping relationship
CREATE (f)-[:IN_GROUPING]->(g)
;
