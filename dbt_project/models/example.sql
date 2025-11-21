{{ config(materialized='table') }}

SELECT 
  1 as id,
  'hello world' as message,
  CURRENT_TIMESTAMP as created_at
