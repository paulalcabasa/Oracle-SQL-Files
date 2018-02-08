with tbl(str) as (
select '1,2,,4,5' from dual
   )
  select regexp_substr(str, '(.*?)(,|$)', 1, level, null, 1) element
  from tbl
   connect by level <= regexp_count(str, ',')+1;
   
   SELECT  REGEXP_SUBSTR (str, '[^,]+', 1, 1)    AS part_1
,       REGEXP_SUBSTR (str, '[^,]+', 1, 2)    AS part_2
,       REGEXP_SUBSTR (str, '[^,]+', 1, 3)    AS part_3
,       REGEXP_SUBSTR (str, '[^,]+', 1, 4)    AS part_4
FROM    table_x