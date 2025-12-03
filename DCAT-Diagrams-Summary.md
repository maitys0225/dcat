# DCAT PlantUML Diagrams & Implementation Guide

## 1. DCAT Core Class Hierarchy

```plantuml
@startuml DCAT_Core_Classes
!theme plain
skinparam backgroundColor #FEFEFE
skinparam classBorderColor #333333
skinparam classBackgroundColor #E1F5FE

title DCAT Core Class Hierarchy

abstract class Resource {
    - dcterms:title
    - dcterms:description
    - dcterms:identifier
    - dcterms:creator
    - dcterms:publisher
    - dcterms:issued
    - dcterms:modified
    - dcat:theme
    - dcterms:accessRights
    - dcterms:license
}

class Catalog {
    - foaf:homepage
    - dcat:themeTaxonomy
    + dcat:dataset
    + dcat:service
    + dcat:catalog
    + dcat:record
}

class Dataset {
    - dcat:distribution [0..*]
    - dcterms:temporal
    - dcterms:spatial
    - dcterms:accrualPeriodicity
    - dcat:temporalResolution
    - dcat:spatialResolutionInMeters
    - dcat:inSeries
}

class DatasetSeries {
    - dcat:seriesMember [1..*]
}

class Distribution {
    - dcat:accessURL
    - dcat:downloadURL
    - dcterms:format
    - dcat:byteSize
    - spdx:checksum
    - dcat:accessService
}

class DataService {
    - dcat:endpointURL
    - dcat:endpointDescription
    - dcterms:conformsTo
    - dcterms:type
}

class CatalogRecord {
    - dcat:primaryTopic
    - dcterms:issued
    - dcterms:modified
}

Resource <|-- Catalog
Resource <|-- Dataset
Resource <|-- DataService
Dataset <|-- DatasetSeries
Catalog "1" *-- "0..*" Dataset : contains
Catalog "1" *-- "0..*" DataService : contains
Catalog "1" *-- "0..*" CatalogRecord : contains
Dataset "1" *-- "1..*" Distribution : has
Distribution "0..*" -- "1" DataService : accessed via
CatalogRecord "1" -- "1" Resource : describes
@enduml
```

## 2. DCAT Catalog Structure

```plantuml
@startuml DCAT_Catalog_Structure
!theme plain
skinparam backgroundColor #FEFEFE
skinparam classBackgroundColor #E1F5FE

title DCAT Catalog Structure and Relationships

class Catalog {
    id: IRI
    title: String
    description: String
    homepage: URL
    themeTaxonomy: KOS
}

class Resource {
    id: IRI
    title: String
    identifier: String
    publisher: Agent
}

class Dataset {
    id: IRI
    title: String
    distribution: [Distribution]
    temporal: PeriodOfTime
    spatial: Location
}

class Distribution {
    id: IRI
    accessURL: URL
    format: Format
    byteSize: Integer
}

class DataService {
    id: IRI
    endpointURL: URL
    conformsTo: Standard
}

class CatalogRecord {
    id: IRI
    primaryTopic: Resource
    issued: DateTime
    modified: DateTime
}

Catalog "1" -- "0..*" Dataset : dcat:dataset
Catalog "1" -- "0..*" DataService : dcat:service
Catalog "1" -- "0..*" CatalogRecord : dcat:record
Dataset "1" -- "1..*" Distribution : dcat:distribution
Distribution "0..*" -- "1" DataService : dcat:accessService
CatalogRecord "1" -- "1" Resource : dcat:primaryTopic
@enduml
```

## 3. Dataset Lifecycle and Versioning

```plantuml
@startuml DCAT_Dataset_Lifecycle
!theme plain
skinparam backgroundColor #FEFEFE
skinparam stateBackgroundColor #E1F5FE

title Dataset Lifecycle and Versioning

state Dataset_v1 {
    [*] --> Created: dcterms:issued
    Created --> Active: Published
    Active --> [*]: dcterms:modified
}

state Dataset_v2 {
    [*] --> Created: dcterms:issued
    Created --> Active: Published
    Active --> [*]: dcterms:modified
}

state Dataset_v3 {
    [*] --> Created: dcterms:issued
    Created --> Active: Published
    Active --> [*]: dcterms:modified
}

Dataset_v1 --> Dataset_v2: dcat:previousVersion\n(replaces)
Dataset_v2 --> Dataset_v3: dcat:previousVersion\n(replaces)

note right of Dataset_v1
    Version 1.0
    dcterms:issued: 2022-01-01
    dcterms:modified: 2022-12-31
end note

note right of Dataset_v2
    Version 2.0
    dcterms:issued: 2023-01-01
    dcterms:modified: 2023-12-31
end note

note right of Dataset_v3
    Version 3.0 (Current)
    dcterms:issued: 2024-01-01
    dcterms:modified: 2024-12-31
end note
@enduml
```

## 4. Distribution Access Patterns

```plantuml
@startuml DCAT_Distribution_Access
!theme plain
skinparam backgroundColor #FEFEFE
skinparam classBackgroundColor #FFF9C4

title Distribution Access Patterns

class Distribution {
    id: IRI
    --
    accessURL: URL
    downloadURL: URL
    format: String
    mediaType: String
    byteSize: Integer
    checksum: Checksum
}

class Checksum {
    algorithm: String
    checksumValue: String
}

class DataService {
    id: IRI
    --
    endpointURL: URL
    endpointDescription: URL
    conformsTo: IRI
    type: String
}

package "Access Methods" {
    class DirectDownload {
        downloadURL: URL
        format: CSV/JSON/etc
        byteSize: Integer
    }
    
    class ServiceAccess {
        accessService: DataService
        query: Filter/Transform
        format: Dynamic
    }
    
    class LandingPage {
        landingPage: URL
        accessURL: URL (landing)
        description: Text
    }
}

Distribution "1" -- "1" Checksum : spdx:checksum
Distribution "0..*" -- "1" DataService : dcat:accessService
Distribution --> DirectDownload : pattern
Distribution --> ServiceAccess : pattern
Distribution --> LandingPage : pattern
@enduml
```

## 5. Temporal and Spatial Metadata

```plantuml
@startuml DCAT_Temporal_Spatial
!theme plain
skinparam backgroundColor #FEFEFE
skinparam classBackgroundColor #C8E6C9

title Temporal and Spatial Metadata

class Dataset {
    id: IRI
    title: String
}

class PeriodOfTime {
    startDate: xsd:date
    endDate: xsd:date
    label: String
}

class SpatialLocation {
    geonames: IRI
    bbox: Coordinates
    label: String
}

class TemporalMetadata {
    temporalCoverage: PeriodOfTime
    temporalResolution: xsd:duration
    accrualPeriodicity: Frequency
    issued: xsd:date
    modified: xsd:date
}

class SpatialMetadata {
    spatialCoverage: SpatialLocation
    spatialResolution: xsd:decimal
    spatialExtent: GeoJSON
}

class Frequency {
    daily
    weekly
    monthly
    quarterly
    annual
    never
}

Dataset "1" -- "1" TemporalMetadata : describes
Dataset "1" -- "1" SpatialMetadata : describes
TemporalMetadata "1" -- "1" PeriodOfTime : dcterms:temporal
TemporalMetadata "1" -- "1" Frequency : dcterms:accrualPeriodicity
SpatialMetadata "1" -- "1" SpatialLocation : dcterms:spatial
@enduml
```

## 6. Licensing and Rights Expression

```plantuml
@startuml DCAT_Licensing_Rights
!theme plain
skinparam backgroundColor #FEFEFE
skinparam classBackgroundColor #FFCCBC

title Licensing and Rights Expression

class Resource {
    id: IRI
    title: String
}

class LicenseDocument {
    id: IRI
    name: String
    text: String
    url: URL
}

class RightsStatement {
    id: IRI
    description: String
    restrictions: Text
}

class AccessRights {
    public
    restricted
    conditional
    licensed
}

class ODRLPolicy {
    id: IRI
    permission: [Permission]
    prohibition: [Prohibition]
    obligation: [Obligation]
}

class Permission {
    action: Action
    assignee: Party
    constraint: [Constraint]
}

class Action {
    use
    copy
    distribute
    modify
    derivative
}

Resource "1" -- "1" LicenseDocument : dcterms:license
Resource "1" -- "1" RightsStatement : dcterms:rights
Resource "1" -- "1" AccessRights : dcterms:accessRights
Resource "0..*" -- "1" ODRLPolicy : odrl:hasPolicy
ODRLPolicy "1" -- "1..*" Permission : odrl:permission
Permission "1" -- "1" Action : odrl:action
@enduml
```

## 7. Dataset Series Organization

```plantuml
@startuml DCAT_Dataset_Series
!theme plain
skinparam backgroundColor #FEFEFE
skinparam classBackgroundColor #E1BEE7

title Dataset Series Organization

class DatasetSeries {
    id: IRI
    title: String
    description: String
    frequency: String
    seriesMember: [Dataset]
}

class Dataset {
    id: IRI
    title: String
    issued: Date
    modified: Date
    inSeries: DatasetSeries
}

class TimeSeriesDataset {
    id: IRI
    title: String (Year/Quarter/Month)
    temporalCoverage: PeriodOfTime
    issued: Date
}

class SpatialSeriesDataset {
    id: IRI
    title: String (Region/Area)
    spatialCoverage: Location
    issued: Date
}

DatasetSeries "1" *-- "1..*" Dataset : dcat:seriesMember
Dataset "0..*" -- "1" DatasetSeries : dcat:inSeries
TimeSeriesDataset --|> Dataset
SpatialSeriesDataset --|> Dataset

note right of TimeSeriesDataset
    Examples:
    - Quarterly Sales Data
    - Monthly Reports
    - Annual Surveys
end note

note right of SpatialSeriesDataset
    Examples:
    - Regional Climate Data
    - State-by-State Statistics
    - City-level Demographics
end note
@enduml
```

## 8. Qualified Relations and Attribution

```plantuml
@startuml DCAT_Qualified_Relations
!theme plain
skinparam backgroundColor #FEFEFE
skinparam classBackgroundColor #B3E5FC

title Qualified Relations and Attribution

class Resource {
    id: IRI
}

class QualifiedRelation {
    id: IRI
    relation: Resource
    hadRole: Role
}

class QualifiedAttribution {
    id: IRI
    agent: Agent
    hadRole: Role
}

class Role {
    derivedFrom
    supplements
    relatedTo
    creator
    contributor
    reviewer
    translator
}

class Agent {
    id: IRI
    name: String
    type: Person/Organization
}

Resource "1" -- "0..*" QualifiedRelation : dcat:qualifiedRelation
Resource "1" -- "0..*" QualifiedAttribution : prov:qualifiedAttribution
QualifiedRelation "1" -- "1" Resource : dcterms:relation
QualifiedRelation "1" -- "1" Role : dcat:hadRole
QualifiedAttribution "1" -- "1" Agent : prov:agent
QualifiedAttribution "1" -- "1" Role : dcat:hadRole
@enduml
```

## 9. Complete DCAT Workflow

```plantuml
@startuml DCAT_Complete_Workflow
!theme plain
skinparam backgroundColor #FEFEFE
skinparam sequenceActorBorderColor #333333

title Complete DCAT Workflow: From Catalog to Discovery

actor Publisher
database Catalog
participant "DCAT Metadata" as DCAT
participant "Aggregator" as AGG
database "Federated Index" as INDEX
actor Consumer

Publisher --> Catalog: Create/Update\nDatasets
Catalog --> DCAT: Publish as\nRDF/JSON-LD
DCAT --> AGG: Consume\nMetadata
AGG --> AGG: Aggregate &\nEnrich
AGG --> INDEX: Index &\nStore
Consumer --> INDEX: Query\nDatasets
INDEX --> Consumer: Return\nResults
Consumer --> DCAT: Access\nMetadata
DCAT --> Consumer: Download\nData via\nDistribution

note right of Publisher
    Describes datasets
    with DCAT classes
end note

note right of DCAT
    RDF serializations:
    - Turtle
    - JSON-LD
    - RDF/XML
end note

note right of AGG
    Federated search
    across catalogs
end note

note right of INDEX
    Faceted search
    by theme, temporal,
    spatial coverage
end note
@enduml
```

---

## PostgreSQL Implementation Summary

### Key Features
- **Normalized Schema**: Fully normalized relational database design
- **ENUM Types**: Strongly-typed status and frequency fields
- **Audit Trail**: Complete change tracking with audit_log table
- **Materialized Views**: Pre-computed views for common queries
- **Stored Procedures**: PL/pgSQL functions for UPSERT operations
- **Referential Integrity**: Foreign key constraints throughout

### Main Tables
| Table | Purpose | Records |
|-------|---------|---------|
| `agents` | Persons and Organizations | Multiple per catalog |
| `resources` | Base for all DCAT resources | One per unique IRI |
| `catalogs` | Catalog containers | Multiple per system |
| `datasets` | Dataset metadata | Multiple per catalog |
| `distributions` | Dataset formats | Multiple per dataset |
| `data_services` | API endpoints | Multiple per catalog |
| `catalog_records` | Metadata about catalog entries | One per resource entry |
| `qualified_relations` | Complex relationships | Multiple |
| `qualified_attributions` | Agent responsibilities | Multiple |
| `checksums` | Distribution integrity | Multiple per distribution |

### Core Procedures
1. **upsert_resource()**: Master UPSERT for all resource types
2. **upsert_dataset()**: Dataset-specific UPSERT
3. **upsert_distribution()**: Distribution with checksums
4. **search_datasets()**: Full-text search with filters

### Query Examples

**Search datasets by title and format:**
```sql
SELECT * FROM search_datasets(
    p_search_term := 'sales',
    p_format := 'CSV',
    p_limit := 50
);
```

**View complete resource with metadata:**
```sql
SELECT * FROM v_resources_complete
WHERE resource_type = 'Dataset'
ORDER BY modified_date DESC;
```

**Track dataset versions:**
```sql
SELECT * FROM v_version_lineage
WHERE current_resource_id = 123;
```

---

## Integration Points

### 1. RDF to PostgreSQL
- Parse RDF/Turtle into resource tuples
- Call upsert procedures for each resource
- Maintain IRIs for Linked Data compatibility

### 2. PostgreSQL to RDF
- Query views for complete resource information
- Generate Turtle/JSON-LD from result sets
- Include IRIs for federation

### 3. Full-Text Search
- Use PostgreSQL full-text indexes
- Integrate with search applications
- Support federated catalog aggregation

### 4. Version Control
- Track all changes in audit_log
- Maintain version chains
- Support rollback operations

---

**Document Version:** 1.0  
**Created:** December 2024  
**Based on:** DCAT 3.0 Recommendation