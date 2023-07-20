SELECT TOP 1 *
FROM some_table
WHERE some_column = 'some value'
ORDER BY some_other_column desc
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER, INCLUDE_NULL_VALUES

