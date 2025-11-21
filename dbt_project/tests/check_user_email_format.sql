-- Проверяем что email содержит @
SELECT *
FROM {{ ref('users') }}
WHERE email NOT LIKE '%@%'
