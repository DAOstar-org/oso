import { gql } from "../__generated__/gql";

/**********************
 * ARTIFACT
 **********************/

const GET_ALL_ARTIFACTS = gql(`
  query Artifacts {
    artifact {
      id
      name
      namespace
    }
  }
`);

const GET_ARTIFACTS_BY_IDS = gql(`
  query ArtifactsByIds($artifactIds: [Int!]) {
    artifact(where: { id: { _in: $artifactIds } }) {
      id
      name
      namespace
    }
  }
`);

const GET_ARTIFACT_BY_NAME = gql(`
  query ArtifactByName($namespace: artifact_namespace_enum!, $name: String!) {
    artifact(where: { name: { _eq: $name }, namespace: { _eq: $namespace } }) {
      id
      name
      namespace
      type
      url
    }
  }
`);

/**********************
 * PROJECT
 **********************/

const GET_ALL_PROJECTS = gql(`
  query Projects {
    project {
      id
      name
      slug
    }
  }
`);

const GET_PROJECTS_BY_IDS = gql(`
  query ProjectsByIds($projectIds: [Int!]) {
    project(where: { id: { _in: $projectIds } }) {
      id
      name
      slug
    }
  }
`);

const GET_PROJECTS_BY_SLUGS = gql(`
  query ProjectsBySlug($slugs: [String!]) {
    project(where: { slug: { _in: $slugs } }) {
      id
      name
      slug
      description
      verified
    }
  }
`);

const GET_PROJECTS_BY_COLLECTION_SLUGS = gql(`
  query ProjectsByCollectionSlugs($slugs: [String!]) {
    project(where: {collection_projects_projects: {collection: {slug: {_in: $slugs}}}}) {
      id
      name
      slug
      description
      verified
    }
  }
`);

/**********************
 * COLLECTION
 **********************/

const GET_ALL_COLLECTIONS = gql(`
  query Collections {
    collection {
      id
      name
      slug
    }
  }
`);

const GET_COLLECTIONS_BY_IDS = gql(`
  query CollectionsByIds($collectionIds: [Int!]) {
    collection(where: { id: { _in: $collectionIds } }) {
      id
      name
      slug
    }
  }
`);

const GET_COLLECTIONS_BY_SLUGS = gql(`
  query CollectionsBySlug($slugs: [String!]) {
    collection(where: { slug: { _in: $slugs } }) {
      id
      name
      slug
      description
      verified
    }
  }
`);

/**********************
 * EVENTS
 **********************/

const GET_EVENTS_DAILY_TO_ARTIFACT = gql(`
  query EventsDailyToArtifact(
    $artifactIds: [Int!],
    $typeIds: [Int!],
    $startDate: timestamptz!,
    $endDate: timestamptz!, 
  ) {
    events_daily_to_artifact(where: {
      artifactId: { _in: $artifactIds },
      typeId: { _in: $typeIds },
      bucketDaily: { _gte: $startDate, _lte: $endDate }
    }) {
      typeId
      artifactId
      bucketDaily
      amount
    }
  }
`);

const GET_EVENTS_WEEKLY_TO_ARTIFACT = gql(`
  query EventsWeeklyToArtifact(
    $artifactIds: [Int!],
    $typeIds: [Int!],
    $startDate: timestamptz!,
    $endDate: timestamptz!, 
  ) {
    events_weekly_to_artifact(where: {
      artifactId: { _in: $artifactIds },
      typeId: { _in: $typeIds },
      bucketWeekly: { _gte: $startDate, _lte: $endDate }
    }) {
      typeId
      artifactId
      bucketWeekly
      amount
    }
  }
`);

const GET_EVENTS_MONTHLY_TO_ARTIFACT = gql(`
  query EventsMonthlyToArtifact(
    $artifactIds: [Int!],
    $typeIds: [Int!],
    $startDate: timestamptz!,
    $endDate: timestamptz!, 
  ) {
    events_monthly_to_artifact(where: {
      artifactId: { _in: $artifactIds },
      typeId: { _in: $typeIds },
      bucketMonthly: { _gte: $startDate, _lte: $endDate }
    }) {
      typeId
      artifactId
      bucketMonthly
      amount
    }
  }
`);

const GET_EVENTS_DAILY_TO_PROJECT = gql(`
  query EventsDailyToProject(
    $projectIds: [Int!],
    $typeIds: [Int!],
    $startDate: timestamptz!,
    $endDate: timestamptz!, 
  ) {
    events_daily_to_project(where: {
      projectId: { _in: $projectIds },
      typeId: { _in: $typeIds },
      bucketDaily: { _gte: $startDate, _lte: $endDate }
    }) {
      typeId
      projectId
      bucketDaily
      amount
    }
  }
`);

const GET_EVENTS_WEEKLY_TO_PROJECT = gql(`
  query EventsWeeklyToProject(
    $projectIds: [Int!],
    $typeIds: [Int!],
    $startDate: timestamptz!,
    $endDate: timestamptz!, 
  ) {
    events_weekly_to_project(where: {
      projectId: { _in: $projectIds },
      typeId: { _in: $typeIds },
      bucketWeekly: { _gte: $startDate, _lte: $endDate }
    }) {
      typeId
      projectId
      bucketWeekly
      amount
    }
  }
`);

const GET_EVENTS_MONTHLY_TO_PROJECT = gql(`
  query EventsMonthlyToProject(
    $projectIds: [Int!],
    $typeIds: [Int!],
    $startDate: timestamptz!,
    $endDate: timestamptz!, 
  ) {
    events_monthly_to_project(where: {
      projectId: { _in: $projectIds },
      typeId: { _in: $typeIds },
      bucketMonthly: { _gte: $startDate, _lte: $endDate }
    }) {
      typeId
      projectId
      bucketMonthly
      amount
    }
  }
`);

const GET_EVENT_SUM = gql(`
  query AggregateSum (
    $projectIds: [Int!],
    $typeIds: [Int!],
    $startDate: timestamptz!,
    $endDate: timestamptz!, 
  ) {
    events_daily_to_project_aggregate(
      where: {
        projectId: {_in: $projectIds},
        typeId: {_in: $typeIds},
        bucketDaily: {_gte: $startDate, _lte: $endDate}}
    ) {
      aggregate {
        sum {
          amount
        }
      }
    }
  }
`);

export {
  GET_ALL_ARTIFACTS,
  GET_ARTIFACTS_BY_IDS,
  GET_ARTIFACT_BY_NAME,
  GET_ALL_PROJECTS,
  GET_PROJECTS_BY_IDS,
  GET_PROJECTS_BY_SLUGS,
  GET_PROJECTS_BY_COLLECTION_SLUGS,
  GET_ALL_COLLECTIONS,
  GET_COLLECTIONS_BY_IDS,
  GET_COLLECTIONS_BY_SLUGS,
  GET_EVENTS_DAILY_TO_ARTIFACT,
  GET_EVENTS_WEEKLY_TO_ARTIFACT,
  GET_EVENTS_MONTHLY_TO_ARTIFACT,
  GET_EVENTS_DAILY_TO_PROJECT,
  GET_EVENTS_WEEKLY_TO_PROJECT,
  GET_EVENTS_MONTHLY_TO_PROJECT,
  GET_EVENT_SUM,
};
