MODEL (
  name oso.projects_by_collection_v1,
  kind FULL,
  tags (
    'export'
  )
);

SELECT
  projects_by_collection.project_id,
  projects_by_collection.project_source,
  projects_by_collection.project_namespace,
  projects_by_collection.project_name,
  collections.collection_id,
  collections.collection_source,
  collections.collection_namespace,
  collections.collection_name
FROM oso.int_projects_by_collection AS projects_by_collection
LEFT JOIN oso.int_collections AS collections
  ON projects_by_collection.collection_id = collections.collection_id