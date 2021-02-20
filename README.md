# Hop Teaming Analysis

For this project, you will be working with the Hop Teaming dataset, a dataset which aims to capture referrals between healthcare providers based on Medicare claims. The 2017 Hop Teaming dataset can be acquired for no charge from https://careset.com/datasets-3/.

The Hop Teaming dataset identifies providers using NPIs, or National Provider Identifiers. An NPI is a unique identification number for covered health care providers created to improve the efficiency and effectiveness of electronic transmission of health information. An NPI is mandatory for all Medicare providers. To supplement the Hop Teaming, download the NPPES Data Dissemination from https://download.cms.gov/nppes/NPI_Files.html. 

The NPPES dataset contains a large number of fields, only a few of which are relevant to this project:
* 'NPI' 
* Entity Type, indicated by the 'Entity Type Code' field:
    - 1 = Provider (doctors, nurses, etc.)
    - 2 = Facility (Hospitals, Urgent Care, Doctors Offices) 
* Entity Name: Either First/Last or Organization or Other Organization Name contained in the following fields:
    - 'Provider Organization Name (Legal Business Name)'
    - 'Provider Last Name (Legal Name)'
    - 'Provider First Name'
    - 'Provider Middle Name'
    - 'Provider Name Prefix Text'
    - 'Provider Name Suffix Text'
    - 'Provider Credential Text'
* Address: Business Practice Location (not mailing), contained in the following fields:
    - 'Provider First Line Business Mailing Address'
    - 'Provider Second Line Business Mailing Address'
    - 'Provider Business Mailing Address City Name'
    - 'Provider Business Mailing Address State Name'
    - 'Provider Business Mailing Address Postal Code'
* The provider's taxonomy code, which is contained in one of the 'Healthcare Provider Taxonomy Code*' columns. A provider can have up to 15 taxonomy codes, but we want the one which has Primary Switch = Y in the associated 'Healthcare Provider Primary Taxonomy Switch*' field. Note that this does not always occur in spot 1.

Next, download the taxonomy code to classification crosswalk from the National Uniform Claim Committee (https://www.nucc.org/index.php/code-sets-mainmenu-41/provider-taxonomy-mainmenu-40/csv-mainmenu-57). Using the primary taxonomy code, match each provider to a classification (from the Classification column).

Finally, you need the Zip code to CBSA crosswalk from here: https://www.huduser.gov/portal/datasets/usps_crosswalk.html. Match each provider to a CBSA using the Business Zip code. Note that a zipcode can be associated to multiple CBSAs, so match with the CBSA with the highest TOT_RATIO. Note that the zipcodes in the nppes dataset are either 5 or 9 digits, and be mindful that leading zeros might be dropped when reading the dataset into a dataframe.

Tasks:
* Filter from_npi to be entity type 1 and to_npi to be entity type 2.
* We want to eliminate "accidental" referrals, so filter the hop teaming data so that the transaction_count is at least 50 and the average_day_wait is less than 50. 
* First, build a profile of providers referring patients to the major hospitals in Nashville. Are certain specialties more likely to refer to a particular hospital over the others?
* Determine which professionals Vanderbilt Hospital should reach out to in the Nashville area to expand their own patient volume. 
    - First, research which professionals are sending significant numbers of patients only to competitor hospitals (such as TriStar Centennial Medical Center).
    - Next, consider the specialty of the provider. If Vanderbilt wants to increase volume from Orthopedic Surgeons or from Family Medicine doctors who should they reach out to in those areas?
* Finally, look for "communities" of providers in the Nashville/Davidson County CBSA. Make use of the Louvain community detection algorithm from Neo4j: https://neo4j.com/docs/graph-data-science/current/algorithms/louvain/.