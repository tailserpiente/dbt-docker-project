{{ config(materialized='table') }}

WITH user_data AS (
  SELECT 1 as user_id, 'Alice' as name, 'alice@email.com' as email
  UNION ALL
  SELECT 2 as user_id, 'Bob' as name, 'bob@email.com' as email
  UNION ALL
  SELECT 3 as user_id, 'Charlie' as name, 'charlie@email.com' as email
)
SELECT 
  user_id,
  name,
  email,
  CURRENT_TIMESTAMP as loaded_at
FROM user_data
