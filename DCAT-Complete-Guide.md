# DCAT 3 (Data Catalog Vocabulary) - Comprehensive Guide

**Version:** 3.0  
**Date:** December 2024  
**Source:** https://www.w3.org/TR/vocab-dcat-3/

---

## Table of Contents

1. [Introduction to DCAT](#introduction)
2. [Core Concepts and Classes](#core-concepts)
3. [Catalog Properties](#catalog-properties)
4. [Resource Common Properties](#resource-properties)
5. [Dataset Specific Properties](#dataset-properties)
6. [Distribution Properties](#distribution-properties)
7. [Data Service Description](#data-service)
8. [Licensing and Rights Management](#licensing-rights)
9. [Versioning and Dataset Series](#versioning)
10. [Temporal and Spatial Metadata](#temporal-spatial)
11. [Relationships and Attribution](#relationships)
12. [Identifiers and Identifiability](#identifiers)

---

## 1. Introduction to DCAT {#introduction}

### Summary
DCAT is an RDF vocabulary designed to facilitate interoperability between data catalogs published on the Web. It enables publishers to describe datasets and data services using a standard model and vocabulary that facilitates consumption and aggregation of metadata from multiple catalogs.

### Key Benefits
- **Discoverability**: Increases the discoverability of datasets and data services
- **Decentralization**: Enables decentralized approaches to publishing data catalogs
- **Federation**: Makes federated search for datasets across multiple sites possible
- **Preservation**: Aggregated DCAT metadata can serve as manifest files for digital preservation
- **Standardization**: Provides a unified vocabulary for data description

### Evolution
- **DCAT 1 (2014)**: Original framework distinguishing datasets from distributions
- **DCAT 2 (2020)**: Added identifiers, quality information, and data citation support
- **DCAT 3 (2024)**: Extended with versioning, dataset series, and inverse properties

### Namespace
```
Namespace IRI: http://www.w3.org/ns/dcat#
Suggested Prefix: dcat
```

### External Vocabularies Used
- **Dublin Core (DCTERMS)**: For descriptive metadata
- **FOAF**: For agent descriptions
- **PROV-O**: For provenance and activities
- **SPDX**: For checksums and integrity
- **SKOS**: For concept schemes and taxonomies
- **ODRL**: For rights expression
- **VCARD**: For contact information
- **OWL/RDF/RDFS**: For ontology structure

---

## 2. Core Concepts and Classes {#core-concepts}

### Summary
DCAT defines seven main classes that form the foundation of the vocabulary. These classes represent different types of resources and their relationships in a data catalog ecosystem.

### Class Hierarchy

```
Resource (abstract superclass)
├── Catalog
│   └── Represents: Collection of metadata about resources
│   └── Subclass of: Dataset
│
├── Dataset
│   ├── Represents: Collection of data curated by single agent
│   ├── Subclass of: Resource
│   │
│   └── DatasetSeries
│       └── Represents: Collection of related datasets
│
├── Distribution
│   └── Represents: Accessible form of dataset (file, API, etc.)
│
├── DataService
│   └── Represents: Collection of operations/API providing data access
│
└── CatalogRecord
    └── Represents: Metadata record describing resource registration
```

### 2.1 Catalog Class

**Definition:** A curated collection of metadata about resources.

**Purpose:**
- Acts as container for datasets, services, and other catalogs
- Provides organizational structure for related resources
- Enables federated catalog discovery

**Key Characteristics:**
- Subclass of Dataset
- Typically one instance per Web-based catalog
- Can contain other catalogs (nested structure)
- Maintains theme taxonomy for resource classification

**Primary Properties:**
- `foaf:homepage`: Catalog homepage URL
- `dcat:themeTaxonomy`: Knowledge organization system for classification
- `dcat:dataset`: Links to datasets in the catalog
- `dcat:service`: Links to services in the catalog
- `dcat:catalog`: Links to sub-catalogs
- `dcat:record`: Links to catalog records
- `dcat:resource`: Generic link to resources

### 2.2 Resource Class

**Definition:** Resource published or curated by a single agent.

**Purpose:**
- Abstract superclass for all cataloged resources
- Carries properties common to datasets, services, and catalogs
- Serves as extension point for custom resource types

**Key Characteristics:**
- Not intended for direct instantiation
- Parent class of Dataset, DataService, and Catalog
- Enables custom resource types through inheritance
- Supports qualified relations and attributions

**Primary Properties:**
- Common descriptive properties (title, description, identifier)
- Rights and access control
- Agent relationships (creator, publisher)
- Relations to other resources
- Themed classification

### 2.3 Dataset Class

**Definition:** Collection of data published or curated by a single agent and available for access or download in one or more serializations or formats.

**Purpose:**
- Represents the abstract concept of a dataset
- Distinct from physical representations (distributions)
- Supports multiple formats and access methods
- Can be part of dataset series

**Key Characteristics:**
- Conceptual entity (not physical)
- Multiple distributions possible per dataset
- Can be accessed via data services
- Supports temporal and spatial metadata
- Can be versioned
- Can belong to a dataset series

**Primary Properties:**
- `dcat:distribution`: Links to available distributions
- `dcat:temporalResolution`: Minimum time period resolvable
- `dcterms:accrualPeriodicity`: Update frequency
- `dcterms:spatial`: Geographic coverage
- `dcat:spatialResolutionInMeters`: Minimum spatial separation
- `dcat:inSeries`: Links to parent dataset series
- `prov:wasGeneratedBy`: Linking activity that generated dataset

### 2.4 Distribution Class

**Definition:** Accessible form of a dataset such as a downloadable file.

**Purpose:**
- Represents specific serialization or format of a dataset
- Provides access information (URLs, formats)
- Describes technical characteristics
- Links to access services

**Key Characteristics:**
- One dataset can have multiple distributions
- Describes physical/technical manifestation
- Includes access mechanisms
- Can have separate temporal/format metadata
- May require specific access methods

**Primary Properties:**
- `dcat:accessURL`: URL for accessing distribution
- `dcat:downloadURL`: Direct download URL
- `dcterms:format`: Data format (MIME type)
- `dcat:accessService`: Access service for the distribution
- `dcterms:mediaType`: IANA media type
- `dcat:byteSize`: Size in bytes
- `spdx:checksum`: Cryptographic digest

### 2.5 DataService Class

**Definition:** Collection of operations accessible through an interface (API) that provide access to one or more datasets or data processing functions.

**Purpose:**
- Describes services providing programmatic data access
- Defines API endpoints and operations
- Enables data discovery and retrieval through services
- Supports various service types

**Key Characteristics:**
- Represents APIs and web services
- Multiple endpoints possible
- Can serve multiple datasets
- Includes service type information
- Has endpoint descriptions

**Primary Properties:**
- `dcat:endpointURL`: Web address of service endpoint
- `dcat:endpointDescription`: Detailed description of endpoint
- `dcterms:conformsTo`: API specification (e.g., OGC WMS)
- `dcterms:type`: Type of service

### 2.6 DatasetSeries Class

**Definition:** Collection of datasets that are published separately but share characteristics that group them.

**Purpose:**
- Groups related datasets with common characteristics
- Enables higher-level organization beyond individual datasets
- Supports time-series and spatial-series patterns
- Facilitates series-level metadata

**Key Characteristics:**
- Subclass of Dataset
- Contains multiple member datasets
- Shared metadata characteristics
- Supports version hierarchies
- Useful for time-series data

**Primary Properties:**
- `dcat:hasPart`: Links to member datasets
- `dcterms:hasPart`: Generic has-part relation
- Series-level metadata (title, description, etc.)

### 2.7 CatalogRecord Class

**Definition:** Metadata record describing the registration of a resource in a catalog.

**Purpose:**
- Distinguishes between resource metadata and catalog metadata
- Captures provenance information about catalog entries
- Tracks when resources were added to catalog
- Records modification history

**Key Characteristics:**
- Optional (not required for basic catalogs)
- Separate from the resource itself
- Captures registration information
- Useful for metadata provenance
- Enables audit trails

**Primary Properties:**
- `dcat:primaryTopic`: Links to the resource described
- `dcterms:issued`: Date record was added to catalog
- `dcterms:modified`: Date record was last modified
- `dcterms:language`: Language of the record
- `foaf:primaryTopic`: Alternative to dcat:primaryTopic

---

## 3. Catalog Properties {#catalog-properties}

### Summary
Catalog-specific properties define how resources are organized, classified, and accessed within a catalog. These properties enable effective resource discovery and federation.

### 3.1 Homepage Property

**IRI:** `foaf:homepage`

**Definition:** A homepage of the catalog - a public Web document usually available in HTML.

**Range:** `foaf:Document`

**Key Characteristics:**
- Inverse functional property (IFP)
- Must be unique and precisely identify the Web page
- Indicates canonical Web page for catalog
- Helpful when multiple Web pages about resource exist

**Usage Example:**
```turtle
ex:my-catalog a dcat:Catalog ;
    dcterms:title "My Data Catalog"@en ;
    foaf:homepage <https://example.org/catalog> .
```

### 3.2 Theme Taxonomy Property

**IRI:** `dcat:themeTaxonomy`

**Definition:** A knowledge organization system (KOS) used to classify resources documented in the catalog.

**Domain:** `dcat:Catalog`

**Range:** `rdfs:Resource`

**Recommended Structure:**
- `skos:ConceptScheme`: Concept scheme
- `skos:Collection`: Collection
- `owl:Ontology`: Ontology
- Similar structure allowing IRIs

**Usage Example:**
```turtle
ex:my-catalog dcat:themeTaxonomy ex:themes .

ex:themes a skos:ConceptScheme ;
    dcterms:title "Catalog Themes" ;
    skos:hasConcept ex:accountability, ex:finance, ex:environment .

ex:accountability a skos:Concept ;
    skos:prefLabel "Accountability" ;
    skos:definition "Resources related to transparency and accountability" .
```

### 3.3 Resource Management Properties

**3.3.1 Resource Property**

**IRI:** `dcat:resource`

**Definition:** A resource that is listed in the catalog.

**Sub-property of:** `dcterms:hasPart`

**Domain:** `dcat:Catalog`

**Range:** `dcat:Resource`

**Characteristics:**
- Most general predicate for catalog membership
- Use more specific sub-properties when available
- Links to any type of cataloged resource

**Sub-properties:**
- `dcat:dataset`: For dataset membership
- `dcat:service`: For service membership
- `dcat:catalog`: For catalog membership

### 3.4 Dataset Membership

**IRI:** `dcat:dataset`

**Definition:** A dataset that is listed in the catalog.

**Sub-property of:** `dcat:resource`

**Domain:** `dcat:Catalog`

**Range:** `dcat:Dataset`

**Usage Example:**
```turtle
ex:my-catalog a dcat:Catalog ;
    dcat:dataset ex:dataset-001, ex:dataset-002 .

ex:dataset-001 a dcat:Dataset ;
    dcterms:title "Sales Data 2024" .
```

### 3.5 Service Membership

**IRI:** `dcat:service`

**Definition:** A service that is listed in the catalog.

**Sub-property of:** `dcat:resource`

**Domain:** `dcat:Catalog`

**Range:** `dcat:DataService`

**Usage Example:**
```turtle
ex:my-catalog dcat:service ex:data-api .

ex:data-api a dcat:DataService ;
    dcterms:title "Data API Service" ;
    dcat:endpointURL <https://api.example.org/v1> .
```

### 3.6 Catalog Records

**IRI:** `dcat:record`

**Definition:** A record describing the registration of a single resource that is part of the catalog.

**Domain:** `dcat:Catalog`

**Range:** `dcat:CatalogRecord`

**Usage Example:**
```turtle
ex:my-catalog dcat:record ex:record-001 .

ex:record-001 a dcat:CatalogRecord ;
    dcat:primaryTopic ex:dataset-001 ;
    dcterms:issued "2024-01-01"^^xsd:date ;
    dcterms:modified "2024-01-15"^^xsd:date .
```

---

## 4. Resource Common Properties {#resource-properties}

### Summary
Resource common properties are shared by all resource types (catalogs, datasets, services). They provide descriptive, administrative, and relationship metadata.

### 4.1 Access Rights

**IRI:** `dcterms:accessRights`

**Definition:** Information about who can access the resource or an indication of its security status.

**Range:** `dcterms:RightsStatement`

**Use Cases:**
- Public datasets
- Restricted access datasets
- Confidential resources
- Licensed access

**Usage Example:**
```turtle
ex:dataset-001 dcterms:accessRights <https://example.org/access/public> .
ex:dataset-002 dcterms:accessRights <https://example.org/access/restricted> .
```

### 4.2 Conformance Standards

**IRI:** `dcterms:conformsTo`

**Definition:** An established standard to which the described resource conforms.

**Range:** `dcterms:Standard`

**Usage Guidance:**
- Indicate model, schema, ontology, or profile
- Link to formal standard documentation
- Enable interoperability assessment

**Usage Example:**
```turtle
ex:dataset-001 dcterms:conformsTo <https://www.w3.org/ns/dcat> ;
    dcterms:conformsTo <https://www.iso.org/standard/19115> .
```

### 4.3 Contact Information

**IRI:** `dcat:contactPoint`

**Definition:** Relevant contact information for the cataloged resource.

**Range:** `vcard:Kind`

**Recommended Use:** vCard vocabulary

**Usage Example:**
```turtle
ex:dataset-001 dcat:contactPoint [
    a vcard:Individual ;
    vcard:fn "John Doe" ;
    vcard:hasEmail <mailto:john@example.org> ;
    vcard:hasTelephone <tel:+1-555-123-4567> ;
] .
```

### 4.4 Creators and Publishers

**4.4.1 Creator Property**

**IRI:** `dcterms:creator`

**Definition:** The entity responsible for producing the resource.

**Range:** `foaf:Agent`

**Usage Example:**
```turtle
ex:dataset-001 dcterms:creator ex:research-team .

ex:research-team a foaf:Organization ;
    foaf:name "Research Team" ;
    foaf:homepage <https://example.org/research> .
```

**4.4.2 Publisher Property**

**IRI:** `dcterms:publisher`

**Definition:** The entity responsible for making the resource available.

**Range:** `foaf:Agent`

**Usage Example:**
```turtle
ex:dataset-001 dcterms:publisher ex:data-agency .

ex:data-agency a foaf:Organization ;
    foaf:name "Data Agency" .
```

### 4.5 Description and Title

**4.5.1 Title Property**

**IRI:** `dcterms:title`

**Definition:** A name given to the resource.

**Range:** `rdfs:Literal`

**Usage Example:**
```turtle
ex:dataset-001 dcterms:title "Sales Data 2024"@en ;
    dcterms:title "Datos de Ventas 2024"@es .
```

**4.5.2 Description Property**

**IRI:** `dcterms:description`

**Definition:** A free-text account of the resource.

**Range:** `rdfs:Literal`

**Usage Example:**
```turtle
ex:dataset-001 dcterms:description 
    "Complete sales data for fiscal year 2024, including regional breakdowns"@en .
```

### 4.6 Identifiers

**IRI:** `dcterms:identifier`

**Definition:** A unique identifier of the resource being described or cataloged.

**Range:** `rdfs:Literal`

**Characteristics:**
- Provides unambiguous reference within context
- Can be part of resource IRI
- Text string assigned to resource
- Complements IRI identification

**Usage Example:**
```turtle
ex:dataset-001 dcterms:identifier "SALES-2024-001" ;
    dcterms:identifier "10.5281/zenodo.123456" .
```

### 4.7 Themes and Types

**4.7.1 Theme Property**

**IRI:** `dcat:theme`

**Definition:** A main category of the resource. Multiple themes possible.

**Sub-property of:** `dcterms:subject`

**Usage Example:**
```turtle
ex:dataset-001 dcat:theme ex:finance ;
    dcat:theme ex:economy .
```

**4.7.2 Type Property**

**IRI:** `dcterms:type`

**Definition:** The nature or genre of the resource.

**Range:** `rdfs:Class`

**Recommended Controlled Vocabularies:**
- DCMI Type Vocabulary
- MARC Genre/Terms Scheme
- ISO 19115-1 MD_Scope codes
- DataCite resource types
- PARSE.Insight content-types

**Usage Example:**
```turtle
ex:dataset-001 dcterms:type <https://purl.org/dc/dcmitype/Dataset> .
```

### 4.8 Relations and Qualified Relations

**4.8.1 Relation Property**

**IRI:** `dcterms:relation`

**Definition:** A resource with unspecified relationship to cataloged resource.

**Sub-properties:**
- `dcat:distribution`: Link to dataset distribution
- `dcterms:hasPart`: Included/contained resources
- `dcterms:isPartOf`: Part of larger resource
- `dcterms:conformsTo`: Conforms to standard
- `dcterms:isFormatOf`: Different format
- `dcterms:hasFormat`: Has alternative format
- `dcterms:isVersionOf`: Version of resource
- `dcterms:hasVersion`: Has version
- `dcterms:replaces`: Replaces resource
- `dcterms:isReplacedBy`: Replaced by resource
- `dcterms:references`: References resource
- `dcterms:isReferencedBy`: Referenced by resource
- `dcterms:requires`: Requires resource
- `dcterms:isRequiredBy`: Required by resource

**Usage Example:**
```turtle
ex:dataset-001 dcterms:isPartOf ex:dataset-series-2024 ;
    dcterms:hasFormat ex:dataset-001-csv ;
    dcterms:hasFormat ex:dataset-001-json .
```

**4.8.2 Qualified Relation Property**

**IRI:** `dcat:qualifiedRelation`

**Definition:** Link to description of relationship with another resource when standard properties don't apply.

**Range:** `dcat:Relationship`

**Usage Example:**
```turtle
ex:dataset-001 dcat:qualifiedRelation [
    a dcat:Relationship ;
    dct:relation ex:dataset-002 ;
    dcat:hadRole roles:derivedFrom ;
] .
```

---

## 5. Dataset Specific Properties {#dataset-properties}

### Summary
Dataset-specific properties extend the common resource properties with characteristics relevant to data collections, including temporal properties, spatial coverage, and update frequency.

### 5.1 Distributions

**IRI:** `dcat:distribution`

**Definition:** An available distribution of the dataset.

**Sub-property of:** `dcterms:relation`

**Domain:** `dcat:Dataset`

**Range:** `dcat:Distribution`

**Usage Example:**
```turtle
ex:dataset-001 a dcat:Dataset ;
    dcterms:title "Sales Data" ;
    dcat:distribution ex:dataset-001-csv ;
    dcat:distribution ex:dataset-001-json .

ex:dataset-001-csv a dcat:Distribution ;
    dcterms:format "CSV" ;
    dcat:downloadURL <https://example.org/sales.csv> .

ex:dataset-001-json a dcat:Distribution ;
    dcterms:format "JSON" ;
    dcat:downloadURL <https://example.org/sales.json> .
```

### 5.2 Temporal Properties

**5.2.1 Issued Date**

**IRI:** `dcterms:issued`

**Definition:** Date of formal issuance (publication) of the resource.

**Range:** `rdfs:Literal` (ISO 8601 formatted)

**Datatypes:**
- `xsd:gYear`
- `xsd:gYearMonth`
- `xsd:date`
- `xsd:dateTime`

**Usage Example:**
```turtle
ex:dataset-001 dcterms:issued "2024-01-01"^^xsd:date .
```

**5.2.2 Modified Date**

**IRI:** `dcterms:modified`

**Definition:** Most recent date on which resource was changed, updated, or modified.

**Range:** `rdfs:Literal` (ISO 8601 formatted)

**Characteristics:**
- Indicates change to actual resource
- Not change to catalog record
- Absence may indicate never changed or unknown

**Usage Example:**
```turtle
ex:dataset-001 dcterms:modified "2024-01-15"^^xsd:date .
```

**5.2.3 Accrual Periodicity**

**IRI:** `dcterms:accrualPeriodicity`

**Definition:** The frequency at which a dataset is published.

**Range:** `dcterms:Frequency`

**Frequency Values:**
- Annual
- Biannual
- Quarterly
- Monthly
- Biweekly
- Weekly
- Daily
- Continuous
- Never

**Usage Example:**
```turtle
ex:dataset-001 dcterms:accrualPeriodicity <https://purl.org/ckan/freq/monthly> .
```

**5.2.4 Temporal Coverage**

**IRI:** `dcterms:temporal`

**Definition:** Temporal coverage or extent of dataset.

**Range:** `dcterms:PeriodOfTime`

**Usage Example:**
```turtle
ex:dataset-001 dcterms:temporal [
    a dcterms:PeriodOfTime ;
    dcat:startDate "2020-01-01"^^xsd:date ;
    dcat:endDate "2024-12-31"^^xsd:date ;
] .
```

**5.2.5 Temporal Resolution**

**IRI:** `dcat:temporalResolution`

**Definition:** Minimum time period resolvable in the dataset.

**Range:** `rdfs:Literal` (typed as `xsd:duration`)

**Characteristics:**
- For time-series: corresponds to spacing of items
- For other datasets: smallest time difference between items
- Single value indicating minimum resolution

**Usage Example:**
```turtle
ex:timeseries-data dcat:temporalResolution "P1D"^^xsd:duration .
# P1D = Period of 1 Day
```

### 5.3 Spatial Properties

**5.3.1 Spatial Coverage**

**IRI:** `dcterms:spatial`

**Definition:** Spatial coverage or extent of dataset.

**Range:** Resources from geographic databases

**Recommended Sources:**
- Geonames IRIs
- ISO 3166-1 country codes
- Custom geographic ontologies

**Usage Example:**
```turtle
ex:dataset-001 dcterms:spatial <https://sws.geonames.org/2988507/> .
# United States
```

**5.3.2 Spatial Resolution**

**IRI:** `dcat:spatialResolutionInMeters`

**Definition:** Minimum spatial separation of items within dataset.

**Range:** `rdfs:Literal` (typed as `xsd:decimal`)

**Usage Example:**
```turtle
ex:satellite-data dcat:spatialResolutionInMeters "30.0"^^xsd:decimal .
# 30 meters resolution
```

### 5.4 Dataset Series Membership

**IRI:** `dcat:inSeries`

**Definition:** A dataset series of which the dataset is part.

**Range:** `dcat:DatasetSeries`

**Sub-property of:** `dcterms:isPartOf`

**Usage Example:**
```turtle
ex:dataset-2024-q1 a dcat:Dataset ;
    dcat:inSeries ex:quarterly-sales-series .

ex:quarterly-sales-series a dcat:DatasetSeries ;
    dcterms:title "Quarterly Sales Data Series" .
```

### 5.5 Generation Activities

**IRI:** `prov:wasGeneratedBy`

**Definition:** An activity that generated or provides business context for dataset creation.

**Range:** `prov:Activity`

**Characteristics:**
- Links to project, initiative, mission, survey, or ongoing activity
- Multiple properties can show granular details
- Details defined in applications

**Usage Example:**
```turtle
ex:dataset-001 prov:wasGeneratedBy ex:research-project-2024 .

ex:research-project-2024 a prov:Activity ;
    prov:label "2024 Research Initiative" ;
    prov:startedAtTime "2024-01-01"^^xsd:date ;
    prov:endedAtTime "2024-12-31"^^xsd:date ;
    prov:wasAssociatedWith ex:research-team .
```

---

## 6. Distribution Properties {#distribution-properties}

### Summary
Distribution properties describe the technical characteristics and access mechanisms for dataset representations. Each distribution represents a specific format, serialization, or access method.

### 6.1 Access Mechanisms

**6.1.1 Access URL**

**IRI:** `dcat:accessURL`

**Definition:** URL for accessing the distribution.

**Characteristics:**
- General access point (may not be direct download)
- Can be landing page requiring navigation
- Required for distributions without download URL
- May point to landing page

**Usage Example:**
```turtle
ex:dataset-001-csv a dcat:Distribution ;
    dcat:accessURL <https://example.org/download/sales-data> .
```

**6.1.2 Download URL**

**IRI:** `dcat:downloadURL`

**Definition:** Direct download URL for the distribution file.

**Characteristics:**
- Points to directly downloadable resource
- Direct file access without additional steps
- Subset of accessURL
- Should duplicate as accessURL if only download method

**Usage Example:**
```turtle
ex:dataset-001-csv a dcat:Distribution ;
    dcat:downloadURL <https://example.org/files/sales-2024.csv> ;
    dcat:accessURL <https://example.org/files/sales-2024.csv> .
```

### 6.2 Format Information

**6.2.1 Format Property**

**IRI:** `dcterms:format`

**Definition:** Data format of the distribution.

**Range:** `rdfs:Resource` (typically IANA media types or format ontologies)

**Recommended Values:**
- IANA Media Types (https://www.iana.org/assignments/media-types/)
- File type URIs
- Format ontology IRIs

**Usage Example:**
```turtle
ex:dataset-001-csv dcterms:format <https://www.iana.org/assignments/media-types/text/csv> ;
    dcterms:format "CSV" .

ex:dataset-001-json dcterms:format <https://www.iana.org/assignments/media-types/application/json> ;
    dcterms:format "JSON" .
```

**6.2.2 Media Type Property**

**IRI:** `dcterms:mediaType`

**Definition:** IANA media type of the distribution.

**Usage Example:**
```turtle
ex:dataset-001-csv dcterms:mediaType "text/csv" .
ex:dataset-001-json dcterms:mediaType "application/json" .
```

### 6.3 Size Information

**IRI:** `dcat:byteSize`

**Definition:** Size of the distribution in bytes.

**Range:** `rdfs:Literal` (xsd:nonNegativeInteger)

**Usage Example:**
```turtle
ex:dataset-001-csv dcat:byteSize "5242880"^^xsd:nonNegativeInteger .
# 5 MB file
```

### 6.4 Checksums and Integrity

**IRI:** `spdx:checksum`

**Definition:** Cryptographic digest for distribution verification.

**Range:** `spdx:Checksum`

**Supported Algorithms:**
- SHA256
- SHA1
- MD5
- SHA512

**Usage Example:**
```turtle
ex:dataset-001-csv spdx:checksum [
    a spdx:Checksum ;
    spdx:algorithm "SHA256" ;
    spdx:checksumValue "d6a770ba38583ed4bb4525bd96e50461655d2758" ;
] .
```

### 6.5 Availability Status

**IRI:** `adms:status`

**Definition:** Status of the distribution (e.g., completed, deprecated, under development).

**Range:** Controlled vocabulary

**Typical Values:**
- Completed
- Deprecated
- Under Development
- Planned
- Obsolete

**Usage Example:**
```turtle
ex:dataset-001-csv adms:status <http://purl.org/adms/status/Completed> .
```

### 6.6 Compression Format

**IRI:** `dcat:compressFormat`

**Definition:** Compression format of the distribution, if applicable.

**Usage Example:**
```turtle
ex:dataset-001-gz a dcat:Distribution ;
    dcat:compressFormat <http://www.iana.org/assignments/media-types/application/gzip> ;
    dcat:byteSize "1048576"^^xsd:nonNegativeInteger .
```

### 6.7 Temporal Resolution

**IRI:** `dcat:temporalResolution`

**Definition:** Minimum time period resolvable in this distribution.

**Range:** `xsd:duration`

**Usage Example:**
```turtle
ex:timeseries-distribution dcat:temporalResolution "PT1H"^^xsd:duration .
# PT1H = Period of 1 Hour
```

### 6.8 Access Service

**IRI:** `dcat:accessService`

**Definition:** Data service providing access to the distribution.

**Range:** `dcat:DataService`

**Usage Example:**
```turtle
ex:dataset-001-via-api a dcat:Distribution ;
    dcat:accessService ex:data-api .

ex:data-api a dcat:DataService ;
    dcterms:title "Data API" ;
    dcat:endpointURL <https://api.example.org/v1> .
```

---

## 7. Data Service Description {#data-service}

### Summary
Data services describe APIs and web services that provide programmatic access to datasets. Services can support data discovery, distribution, transformation, and processing operations.

### 7.1 Service Definition

**IRI:** `dcat:DataService`

**Definition:** Collection of operations accessible through interface (API) providing access to datasets or data processing functions.

**Characteristics:**
- Represents APIs and web services
- Multiple endpoints possible
- Serves one or more datasets
- Supports various service types

**Key Service Types:**
- Data Distribution Services (download/query)
- Data Discovery Services (search/browse)
- Data Transformation Services (coordinate conversion, resampling)
- Data Processing Services (simulation, modeling)

### 7.2 Endpoint Information

**7.2.1 Endpoint URL**

**IRI:** `dcat:endpointURL`

**Definition:** Web address of the service endpoint.

**Range:** URL

**Characteristics:**
- Direct access point to API
- Service base URL
- Multiple endpoints per service possible

**Usage Example:**
```turtle
ex:data-api a dcat:DataService ;
    dcterms:title "Public Data API" ;
    dcat:endpointURL <https://api.example.org/v1> .
```

**7.2.2 Endpoint Description**

**IRI:** `dcat:endpointDescription`

**Definition:** Detailed description of individual endpoint parameters and options.

**Characteristics:**
- Formal API specification
- OpenAPI/Swagger documentation
- WSDL for SOAP services
- Links to detailed documentation

**Usage Example:**
```turtle
ex:data-api dcat:endpointDescription 
    <https://api.example.org/openapi.json> .
```

### 7.3 Standards Conformance

**IRI:** `dcterms:conformsTo`

**Definition:** API specification or standard the service conforms to.

**Typical Standards:**
- OGC Web Map Service (WMS)
- OGC Web Feature Service (WFS)
- OGC Web Coverage Service (WCS)
- SPARQL Protocol
- REST/OpenAPI
- SOAP/WSDL

**Usage Example:**
```turtle
ex:wms-service a dcat:DataService ;
    dcterms:conformsTo <http://www.opengis.net/gml/3.2.1> ;
    dcterms:conformsTo <http://www.opengis.net/wms> ;
    dcterms:type <http://purl.org/linked-data/sdmx/2009/variable#observation> .
```

### 7.4 Service Relationships

**7.4.1 Services Linked to Datasets**

**IRI:** `dcat:accessService` (on Distribution)

**Definition:** Data service providing access to a dataset distribution.

**Usage Example:**
```turtle
ex:dataset-001 dcat:distribution [
    a dcat:Distribution ;
    dcat:accessService ex:wfs-service ;
] .

ex:wfs-service a dcat:DataService ;
    dcterms:title "OGC WFS Service" ;
    dcat:endpointURL <https://example.org/wfs> .
```

**7.4.2 Services in Catalogs**

**Usage Example:**
```turtle
ex:catalog dcat:service ex:data-api ;
    dcat:service ex:search-service .

ex:data-api a dcat:DataService ;
    dcterms:title "Data Download API" .

ex:search-service a dcat:DataService ;
    dcterms:title "Dataset Search Service" .
```

---

## 8. Licensing and Rights Management {#licensing-rights}

### Summary
DCAT provides comprehensive support for expressing legal rights, licenses, and access conditions associated with resources. Multiple properties allow for different approaches to rights expression.

### 8.1 License Declaration

**IRI:** `dcterms:license`

**Definition:** Legal document under which resource is made available.

**Range:** `dcterms:LicenseDocument`

**Characteristics:**
- Points to formal license document
- IRI preferred over inline text
- Can be applied to resource or distribution
- Recommended over inline rights statements

**Common Licenses:**
- CC-BY 4.0
- CC-BY-SA 4.0
- CC-0 (Public Domain)
- ODbL
- MIT
- Apache 2.0

**Usage Example:**
```turtle
ex:dataset-001 dcterms:license <https://creativecommons.org/licenses/by/4.0/> .

ex:dataset-001-csv dcterms:license <https://creativecommons.org/licenses/by-sa/4.0/> .
```

### 8.2 Access Rights

**IRI:** `dcterms:accessRights`

**Definition:** Information about who can access resource or security status.

**Range:** `dcterms:RightsStatement`

**Use Cases:**
- Public access
- Restricted access
- Conditional access
- Licensed access
- Confidential

**Usage Example:**
```turtle
ex:dataset-001 dcterms:accessRights <https://example.org/rights/public> ;
    dcterms:title "Public Dataset" .

ex:dataset-002 dcterms:accessRights <https://example.org/rights/restricted> ;
    dcterms:title "Restricted Access Dataset" ;
    dcat:contactPoint [ ... ] .
```

### 8.3 Rights Statements

**IRI:** `dcterms:rights`

**Definition:** Statement concerning all rights not addressed by license or access rights.

**Range:** `dcterms:RightsStatement`

**Characteristics:**
- Handles copyright, moral rights, other rights
- Complements license and access rights
- Can be text or IRI
- More general than license

**Usage Example:**
```turtle
ex:dataset-001 dcterms:rights "Copyright © 2024 Example Organization" ;
    dcterms:license <https://creativecommons.org/licenses/by/4.0/> .
```

### 8.4 ODRL Policies

**IRI:** `odrl:hasPolicy`

**Definition:** ODRL-conformant policy expressing rights associated with resource.

**Range:** `odrl:Policy`

**Characteristics:**
- Formal rights expression
- Fine-grained control
- Conditions, duties, and prohibitions
- Complex rights scenarios

**Usage Example:**
```turtle
ex:dataset-001 odrl:hasPolicy [
    a odrl:Policy ;
    odrl:permission [
        odrl:action odrl:use ;
        odrl:assignee [a odrl:PartyCollection] ;
        odrl:constraint [
            odrl:operator odrl:neq ;
            odrl:rightOperand "Commercial" ;
        ] ;
    ] ;
] .
```

### 8.5 Policy Structure

**Key ODRL Concepts:**
- **Permission**: What can be done with resource
- **Prohibition**: What cannot be done
- **Obligation**: What must be done
- **Action**: Specific allowed actions (use, copy, distribute)
- **Constraint**: Conditions on usage (territory, time, purpose)
- **Assignee**: Party to which policy applies

---

## 9. Versioning and Dataset Series {#versioning}

### Summary
DCAT 3 introduces comprehensive versioning support allowing description of version chains, current versions, and dataset series structures.

### 9.1 Version Chains

**9.1.1 Version Property**

**IRI:** `dcat:version`

**Definition:** A version string or identifier for the resource.

**Range:** `rdfs:Literal`

**Usage Example:**
```turtle
ex:dataset-2024 dcat:version "2024.1.0" .
```

**9.1.2 Previous Version**

**IRI:** `dcat:previousVersion`

**Definition:** Previous version of resource in lineage.

**Equivalent Property:** `pav:previousVersion`

**Sub-property of:** `prov:wasRevisionOf`

**Usage Example:**
```turtle
ex:dataset-2024 dcat:previousVersion ex:dataset-2023 ;
    dcterms:title "Sales Data 2024" .

ex:dataset-2023 dcterms:title "Sales Data 2023" .
```

**9.1.3 Current Version**

**IRI:** `dcat:hasCurrentVersion`

**Definition:** The current version of a resource (inverse of previousVersion).

**Usage Example:**
```turtle
ex:dataset-2023 dcat:hasCurrentVersion ex:dataset-2024 .
```

### 9.2 Dataset Series

**9.2.1 DatasetSeries Class**

**IRI:** `dcat:DatasetSeries`

**Definition:** Collection of datasets published separately but sharing grouping characteristics.

**Sub-class of:** `dcat:Dataset`

**Characteristics:**
- Represents series of related datasets
- Each member is separate dataset
- Share common characteristics
- Enable series-level metadata
- Support time-series and spatial-series patterns

**Usage Example:**
```turtle
ex:quarterly-sales-series a dcat:DatasetSeries ;
    dcterms:title "Quarterly Sales Data Series 2024"@en ;
    dcterms:description "Quarterly sales figures for all regions"@en ;
    dcterms:publisher ex:sales-department ;
    dcat:seriesMember ex:q1-sales, ex:q2-sales, ex:q3-sales, ex:q4-sales .

ex:q1-sales a dcat:Dataset ;
    dcat:inSeries ex:quarterly-sales-series ;
    dcterms:title "Q1 2024 Sales" ;
    dcat:issued "2024-04-01"^^xsd:date .
```

**9.2.2 Series Members**

**IRI:** `dcat:seriesMember`

**Definition:** Links to individual datasets that are members of series.

**Domain:** `dcat:DatasetSeries`

**Range:** `dcat:Dataset`

**Inverse Relationship:** `dcat:inSeries`

**Usage Example:**
```turtle
ex:monthly-data-series a dcat:DatasetSeries ;
    dcat:seriesMember ex:data-jan, ex:data-feb, ex:data-mar ;
    dcat:seriesMember ex:data-apr, ex:data-may, ex:data-jun .
```

### 9.3 Version Relationships

**9.3.1 Format Changes**

**Properties:**
- `dcterms:isFormatOf`: This resource is different format of another
- `dcterms:hasFormat`: This resource has alternative format

**Usage Example:**
```turtle
ex:dataset-csv dcterms:isFormatOf ex:dataset-abstract ;
    dcat:downloadURL <https://example.org/data.csv> .

ex:dataset-json dcterms:isFormatOf ex:dataset-abstract ;
    dcat:downloadURL <https://example.org/data.json> .

ex:dataset-abstract dcterms:hasFormat ex:dataset-csv ;
    dcterms:hasFormat ex:dataset-json .
```

**9.3.2 Version Changes**

**Properties:**
- `dcterms:isVersionOf`: This is version of another resource
- `dcterms:hasVersion`: This resource has versions

**Usage Example:**
```turtle
ex:dataset-v2 dcterms:isVersionOf ex:dataset ;
    dcat:version "2.0" ;
    dcat:previousVersion ex:dataset-v1 .

ex:dataset dcterms:hasVersion ex:dataset-v1 ;
    dcterms:hasVersion ex:dataset-v2 .
```

**9.3.3 Replacement Relationships**

**Properties:**
- `dcterms:replaces`: This resource replaces another
- `dcterms:isReplacedBy`: This resource is replaced by another

**Usage Example:**
```turtle
ex:dataset-new dcterms:replaces ex:dataset-old ;
    dcterms:title "New Sales Dataset (Preferred)" .

ex:dataset-old dcterms:isReplacedBy ex:dataset-new ;
    dcterms:title "Old Sales Dataset (Deprecated)" ;
    adms:status <http://purl.org/adms/status/Deprecated> .
```

---

## 10. Temporal and Spatial Metadata {#temporal-spatial}

### Summary
DCAT provides comprehensive support for expressing temporal and spatial characteristics of datasets, including coverage, resolution, and update frequencies.

### 10.1 Temporal Coverage

**IRI:** `dcterms:temporal`

**Definition:** Temporal coverage or extent of dataset.

**Range:** `dcterms:PeriodOfTime`

**Characteristics:**
- Closed interval with start and end dates
- Describes data collection period
- Optional start/end dates
- Can span multiple periods

**Usage Example:**
```turtle
ex:dataset-001 dcterms:temporal [
    a dcterms:PeriodOfTime ;
    dcat:startDate "2020-01-01"^^xsd:date ;
    dcat:endDate "2024-12-31"^^xsd:date ;
] .

# Multiple periods
ex:dataset-002 dcterms:temporal [
    a dcterms:PeriodOfTime ;
    dcat:startDate "2015-01-01"^^xsd:date ;
    dcat:endDate "2020-12-31"^^xsd:date ;
] ;
dcterms:temporal [
    a dcterms:PeriodOfTime ;
    dcat:startDate "2022-01-01"^^xsd:date ;
    dcat:endDate "2024-12-31"^^xsd:date ;
] .
```

### 10.2 Temporal Resolution

**IRI:** `dcat:temporalResolution`

**Definition:** Minimum time period resolvable in dataset.

**Range:** `xsd:duration`

**ISO 8601 Duration Format:**
- `P1Y` = 1 Year
- `P1M` = 1 Month
- `P1D` = 1 Day
- `PT1H` = 1 Hour
- `PT1M` = 1 Minute
- `PT1S` = 1 Second
- `P1DT12H` = 1 Day 12 Hours

**Time-Series Usage:**
- Corresponds to spacing between items
- Indicates data point frequency

**Usage Example:**
```turtle
# Daily data
ex:daily-timeseries dcat:temporalResolution "P1D"^^xsd:duration .

# Hourly data
ex:hourly-data dcat:temporalResolution "PT1H"^^xsd:duration .

# Monthly aggregates
ex:monthly-summary dcat:temporalResolution "P1M"^^xsd:duration .

# 15-minute intervals
ex:real-time-data dcat:temporalResolution "PT15M"^^xsd:duration .
```

### 10.3 Accrual Periodicity

**IRI:** `dcterms:accrualPeriodicity`

**Definition:** Frequency at which dataset is published.

**Range:** `dcterms:Frequency`

**Recommended Values (from CKAN/DCAT-AP):**
```
https://purl.org/ckan/freq/

- /instant: Instantaneous
- /daily: Daily
- /three_times_a_week: Three times weekly
- /semiweekly: Twice weekly
- /weekly: Weekly
- /biweekly: Twice monthly (biweekly)
- /three_times_a_month: Three times monthly
- /monthly: Monthly
- /bimonthly: Every two months
- /quarterly: Quarterly (every three months)
- /semiannual: Every six months
- /annual: Annually
- /biennial: Every two years
- /triennial: Every three years
- /irregular: Irregular
- /never: Never updated
```

**Usage Example:**
```turtle
# Daily updates
ex:stock-data dcterms:accrualPeriodicity 
    <https://purl.org/ckan/freq/daily> .

# Weekly updates
ex:sales-report dcterms:accrualPeriodicity 
    <https://purl.org/ckan/freq/weekly> .

# Monthly updates
ex:financial-data dcterms:accrualPeriodicity 
    <https://purl.org/ckan/freq/monthly> .

# No updates
ex:historical-archive dcterms:accrualPeriodicity 
    <https://purl.org/ckan/freq/never> .
```

### 10.4 Spatial Coverage

**IRI:** `dcterms:spatial`

**Definition:** Spatial coverage or extent of dataset.

**Range:** Spatial references (typically IRIs from geographic databases)

**Recommended Sources:**

**1. Geonames (https://www.geonames.org/)**
```turtle
ex:dataset-usa dcterms:spatial <https://sws.geonames.org/2988507/> .
# United States

ex:dataset-paris dcterms:spatial <https://sws.geonames.org/2988507/> .
# France
```

**2. ISO 3166-1 Country Codes**
```turtle
ex:dataset-canada dcterms:spatial <http://linked.data.gov.au/def/iso3166/1/CA> .
# Canada
```

**3. Custom Geographic Ontologies**
```turtle
ex:dataset-region dcterms:spatial <https://example.org/regions/north-america> .
```

**Multiple Coverage Areas**

**Usage Example:**
```turtle
ex:multi-region-data dcterms:spatial <https://sws.geonames.org/2988507/> ;  # USA
    dcterms:spatial <https://sws.geonames.org/2658434/> ;  # Spain
    dcterms:spatial <https://sws.geonames.org/2988507/> .  # Germany
```

### 10.5 Spatial Resolution

**IRI:** `dcat:spatialResolutionInMeters`

**Definition:** Minimum spatial separation of items within dataset.

**Range:** `xsd:decimal`

**Unit:** Meters

**Common Values:**
- 1 meter = 1
- 10 meters = 10
- 30 meters = 30 (Landsat resolution)
- 100 meters = 100
- 1 kilometer = 1000
- 100 kilometers = 100000

**Usage Example:**
```turtle
# 30-meter resolution (Landsat satellite)
ex:satellite-imagery dcat:spatialResolutionInMeters "30.0"^^xsd:decimal .

# 1-meter resolution (High resolution)
ex:aerial-photography dcat:spatialResolutionInMeters "1.0"^^xsd:decimal .

# 100-meter resolution
ex:coarse-resolution dcat:spatialResolutionInMeters "100.0"^^xsd:decimal .
```

### 10.6 Period of Time Class

**IRI:** `dcterms:PeriodOfTime`

**Definition:** Class representing a continuous time interval with defined start and end points.

**Properties:**
- `dcat:startDate`: Start of period
- `dcat:endDate`: End of period

**Usage Example:**
```turtle
ex:fiscal-year-2024 a dcterms:PeriodOfTime ;
    dcat:startDate "2024-01-01"^^xsd:date ;
    dcat:endDate "2024-12-31"^^xsd:date ;
    dcterms:title "Fiscal Year 2024" .
```

---

## 11. Relationships and Attribution {#relationships}

### Summary
DCAT provides mechanisms for expressing complex relationships between resources and for attributing responsibility to agents for specific aspects of resources.

### 11.1 Qualified Relations

**IRI:** `dcat:qualifiedRelation`

**Definition:** Link to description of relationship with another resource.

**Range:** `dcat:Relationship`

**Purpose:**
- Express relationships not covered by standard DCTERMS properties
- Attach additional metadata to relationships
- Maintain semantic richness of relationships

**Supported Relationship Types:**
```
- derivedFrom: Current resource derived from another
- relatedTo: General relationship
- hasVersion: Current has versions
- isVersionOf: Is version of another
- replaces: Replaces another resource
- isReplacedBy: Is replaced by another
- supplements: Supplements another resource
- isSupplementedBy: Is supplemented by another
```

**Usage Example:**
```turtle
ex:dataset-processed dcat:qualifiedRelation [
    a dcat:Relationship ;
    dcterms:relation ex:dataset-raw ;
    dcat:hadRole <http://example.org/roles/derivedFrom> ;
] .

ex:dataset-parent dcat:qualifiedRelation [
    a dcat:Relationship ;
    dcterms:relation ex:dataset-child ;
    dcat:hadRole <http://example.org/roles/supplements> ;
] .
```

### 11.2 Qualified Attribution

**IRI:** `prov:qualifiedAttribution`

**Definition:** Link to agent having some form of responsibility for resource.

**Range:** `prov:Attribution`

**Purpose:**
- Beyond standard creator/publisher properties
- Attach role information to agents
- Express specific responsibilities

**Common Roles:**
- Creator
- Contributor
- Developer
- Reviewer
- Translator
- Maintainer
- Principal Investigator

**Usage Example:**
```turtle
ex:dataset-001 prov:qualifiedAttribution [
    a prov:Attribution ;
    prov:agent ex:data-scientist-01 ;
    dcat:hadRole <http://example.org/roles/dataProcessing> ;
] ;
prov:qualifiedAttribution [
    a prov:Attribution ;
    prov:agent ex:qa-team ;
    dcat:hadRole <http://example.org/roles/qualityAssurance> ;
] .

ex:data-scientist-01 a foaf:Person ;
    foaf:name "Alice Johnson" .

ex:qa-team a foaf:Organization ;
    foaf:name "Quality Assurance Team" .
```

### 11.3 Referenced By

**IRI:** `dcterms:isReferencedBy`

**Definition:** Related resource such as publication that references, cites, or points to cataloged resource.

**Purpose:**
- Data citation use case
- Link datasets to scholarly publications
- Show dataset impact and usage

**Usage Example:**
```turtle
ex:dataset-climate-model dcterms:isReferencedBy [
    a dcat:Resource ;
    dcterms:title "Global Climate Patterns in the 21st Century" ;
    dcterms:identifier "10.1234/example.journal.2024.001" ;
    dcterms:creator [
        a foaf:Person ;
        foaf:name "Dr. Jane Smith" ;
    ] ;
    dcterms:issued "2024-06-15"^^xsd:date ;
] ;
dcterms:isReferencedBy [
    a dcat:Resource ;
    dcterms:title "Regional Climate Impacts" ;
    dcterms:identifier "10.5678/nature.climate.2024" ;
    dcterms:issued "2024-09-20"^^xsd:date ;
] .
```

### 11.4 Relationship Type Examples

**Entity Relationships:**
```
- hasVersion / isVersionOf: Version lineage
- replaces / isReplacedBy: Superseded versions
- isPartOf / hasPart: Compositional structure
- isFormatOf / hasFormat: Format variations
```

**Derivation Relationships:**
```
- wasDerivedFrom: Source data
- wasQuotedFrom: Quoted content
- wasRevisionOf: Revision history
```

**Attribution Relationships:**
```
- wasAssociatedWith: Associated agents
- wasAttributedTo: Attributed agents
- hadPrimarySource: Primary source
```

---

## 12. Identifiers and Identifiability {#identifiers}

### Summary
DCAT resources should use global identifiers (IRIs) for effective linking and collaboration in Linked Data contexts. This section covers identifier strategies and best practices.

### 12.1 IRIs vs. Blank Nodes

**IRIs (Recommended)**

**Definition:** Internationalized Resource Identifiers providing global unique identification.

**Characteristics:**
- Globally unique
- Dereferenceable (can be looked up)
- Enable collaborative annotation
- Support Linked Data principles
- Recommended for all main DCAT classes

**Benefits:**
- Enable external references
- Support federation
- Allow additional information to be added
- Support distributed data

**Usage Example:**
```turtle
ex:dataset-001 a dcat:Dataset ;
    dcterms:title "Sales Data 2024" ;
    dcat:distribution ex:dataset-001-csv ;
    dcat:distribution ex:dataset-001-json .

ex:dataset-001-csv a dcat:Distribution ;
    dcat:downloadURL <https://example.org/sales.csv> .
```

**Blank Nodes (Not Recommended)**

**Characteristics:**
- Anonymous resources
- No global identifier
- Limited to single document
- Cannot be referenced externally
- Undermine Linked Data principles

**Limitations:**
- Cannot be target of external links
- Cannot be annotated from outside
- Limit collaborative data enhancement
- Complicate data integration

**Example (Not Recommended):**
```turtle
# AVOID THIS - using blank nodes
ex:dataset-001 a dcat:Dataset ;
    dcterms:title "Sales Data 2024" ;
    dcat:distribution [
        a dcat:Distribution ;
        dcat:downloadURL <https://example.org/sales.csv> ;
    ] .
```

### 12.2 Unique Identifiers

**IRI:** `dcterms:identifier`

**Definition:** Unique identifier of resource being described or cataloged.

**Range:** `rdfs:Literal` (text string)

**Characteristics:**
- Complements IRI identification
- Useful for human-readable identifiers
- Can be part of IRI
- Provides context-specific reference

**Recommendation:** All DCAT main classes should have both IRI and identifier.

**Usage Example:**
```turtle
ex:dataset-001 a dcat:Dataset ;
    dcterms:identifier "SALES-2024-001" ;
    dcterms:identifier "10.5281/zenodo.123456" ;
    dcterms:title "Sales Data 2024" .

# Multiple identifier schemes
ex:dataset-002 dcterms:identifier "GOV.UK:dataset-weather-2024" ;
    dcterms:identifier "DOI:10.1234/weather.2024" ;
    dcterms:identifier "UUID:550e8400-e29b-41d4-a716-446655440000" .
```

### 12.3 Identifier Schemes

**Common Identifier Types:**

**1. Internal Identifiers**
```turtle
ex:dataset dcterms:identifier "INTERNAL-ID-12345" .
```

**2. DOI (Digital Object Identifier)**
```turtle
ex:dataset dcterms:identifier "10.5281/zenodo.123456" .
# IRI form: https://doi.org/10.5281/zenodo.123456
```

**3. URN (Uniform Resource Name)**
```turtle
ex:dataset dcterms:identifier "urn:uuid:550e8400-e29b-41d4-a716-446655440000" .
```

**4. Government-Specific IDs**
```turtle
ex:dataset dcterms:identifier "GOV.UK:HMRC-TR-2024-001" .
```

**5. Federated IDs**
```turtle
# Using adms:identifier for administrative identifiers
ex:dataset adms:identifier [
    a adms:Identifier ;
    skos:notation "CKAN-ID-12345" ;
    adms:schemeAgency "data.gov.uk" ;
] .
```

### 12.4 IRI Construction Best Practices

**Pattern 1: Hierarchical**
```
https://example.org/datasets/2024/sales
https://example.org/datasets/2024/sales/distribution/csv
```

**Pattern 2: Semantic**
```
https://example.org/catalog/sales-data-2024
https://example.org/dataset/climate-observations
```

**Pattern 3: Opaque (Recommended for stability)**
```
https://example.org/resource/d12345
https://example.org/resource/s67890
```

**Usage Example:**
```turtle
# Good IRI pattern - stable and dereferenceable
<https://data.example.org/dataset/sales-2024> a dcat:Dataset ;
    dcterms:identifier "SALES-2024" ;
    dcterms:title "Annual Sales Data 2024" ;
    dcat:distribution <https://data.example.org/dist/sales-2024/csv> .

<https://data.example.org/dist/sales-2024/csv> a dcat:Distribution ;
    dcterms:format "CSV" ;
    dcat:downloadURL <https://files.example.org/sales-2024.csv> .
```

---

## Summary and Best Practices

### Core Principles

1. **Use IRIs for All Main Classes**: Enable federation and collaboration
2. **Distinguish Dataset from Distribution**: Represent conceptual vs. physical manifestation
3. **Leverage Standard Properties**: Use Dublin Core and established vocabularies
4. **Version Your Resources**: Track changes and create audit trails
5. **Specify Rights Clearly**: Use licenses and access rights properties
6. **Include Temporal/Spatial Metadata**: Enable discovery by coverage characteristics
7. **Relate Resources Explicitly**: Use qualified relations and attributions
8. **Conform to Standards**: Express conformance using dcterms:conformsTo

### Implementation Patterns

**Minimal Dataset Description:**
```turtle
<https://example.org/dataset/minimal> a dcat:Dataset ;
    dcterms:title "Minimal Dataset" ;
    dcterms:description "A basic dataset description" ;
    dcterms:publisher <https://example.org/organization> ;
    dcat:distribution <https://example.org/dist/minimal> .

<https://example.org/dist/minimal> a dcat:Distribution ;
    dcat:accessURL <https://files.example.org/data.csv> .
```

**Comprehensive Dataset Description:**
```turtle
<https://example.org/dataset/comprehensive> a dcat:Dataset ;
    dcterms:title "Comprehensive Dataset" ;
    dcterms:description "A complete dataset with all recommended properties" ;
    dcterms:identifier "COMPREHENSIVE-2024" ;
    dcterms:issued "2024-01-01"^^xsd:date ;
    dcterms:modified "2024-12-31"^^xsd:date ;
    dcterms:language <http://id.loc.gov/vocabulary/iso639-1/en> ;
    dcterms:accrualPeriodicity <https://purl.org/ckan/freq/monthly> ;
    dcterms:spatial <https://sws.geonames.org/2988507/> ;
    dcterms:temporal [ 
        a dcterms:PeriodOfTime ;
        dcat:startDate "2024-01-01"^^xsd:date ;
        dcat:endDate "2024-12-31"^^xsd:date ;
    ] ;
    dcterms:creator <https://example.org/researcher/alice> ;
    dcterms:publisher <https://example.org/organization> ;
    dcat:theme <https://example.org/themes/environment> ;
    dcat:keyword "climate", "environment", "sustainability" ;
    dcterms:license <https://creativecommons.org/licenses/by/4.0/> ;
    dcterms:conformsTo <https://www.w3.org/ns/dcat> ;
    dcat:contactPoint [ 
        a vcard:Individual ;
        vcard:fn "Data Manager" ;
        vcard:hasEmail <mailto:data@example.org> ;
    ] ;
    dcat:distribution [ 
        a dcat:Distribution ;
        dcat:accessURL <https://files.example.org/comprehensive.csv> ;
        dcterms:format <https://www.iana.org/assignments/media-types/text/csv> ;
        dcterms:issued "2024-01-01"^^xsd:date ;
        spdx:checksum [ 
            a spdx:Checksum ;
            spdx:algorithm "SHA256" ;
            spdx:checksumValue "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" ;
        ] ;
    ] .
```

---

**Document Version:** 1.0  
**Created:** December 2024  
**Based on:** DCAT 3.0 Recommendation (https://www.w3.org/TR/vocab-dcat-3/)
