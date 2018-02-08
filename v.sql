select *
from OE_HEADERS_IFACE_ALL;


sel

item
rog
sub inv
amt
qty
trans type


select *
from mtl_material_transactions;

select *
from mtl_transaction_types;

select *
from hr_all_organization_units;


select distinct msib.segment1,
         msib.description,
          org.name organization,
         mmt.organization_id,
         mmt.transaction_id,
         mmt.subinventory_code,
         mmt.transaction_quantity,
         mmt.transaction_uom,
         mtl_trans.transaction_type_name
from mtl_material_transactions mmt,
        mtl_system_items_b msib,
        mtl_transaction_types mtl_trans,
        hr_all_organization_units org
where 1 = 1
          AND mmt.inventory_item_id = msib.inventory_item_id
          AND mtl_trans.transaction_type_id = mmt.transaction_type_id
          AND org.organization_id = mmt.organization_id
          AND segment1 LIKE '170UC%';









set verify on echo off feedback on pagesize 500 linesize 300 serveroutput on size 100000 newpage 0

variable x_table_name varchar2(30)
variable x_where_clause varchar2(1000)
variable x_show_mode number
-- (1=ALL, 2=NOT NULL, 3=DIFF)

prompt Enter a table name for parameter 1
prompt Enter the where clause for parameter 2 (no 'where')
prompt Enter the show mode for parameter 3 (1=ALL, 2=NOT NULL, 3=DIFF)

declare
  show_column boolean;
  col_name varchar2(30) := 'BAD TABLE NAME';
  col_owner varchar2(10);
  col_value_prev varchar2(2000);
  col_value varchar2(2000);
  select_stat varchar2(2000);
  null_column boolean;
  col_line varchar2(2000);
  cursor_id number;
  rows_processed number;
  cursor tab is
    select rpad(column_name, 30, ' ') column_name, data_type, owner
    from   all_tab_columns
    where  table_name = :x_table_name
    and    owner = ( select owner from all_tab_columns
                     where table_name = :x_table_name and rownum =1
                   )
-- make sure the same column will not be selected twice if two schemas
-- have the object, table or view. (ra_interface_lines is a table under
-- RA, but view in APPS)
--    and  owner = 'OE'
    order by column_name;
begin
  :x_table_name   := upper('&1');
  :x_where_clause := '&2';
  :x_show_mode    := nvl('&3', 2);
--  if :x_show_mode is null then
--    :x_show_mode := 2; -- default to 'NOT NULL' columns
--  end if;
  
  dbms_output.put_line('Table: ' || :x_table_name);
  dbms_output.put_line('Where ' || :x_where_clause);
  dbms_output.put_line('==============================');

  for t in tab loop
    col_name    := t.column_name;
    col_owner   := t.owner;
    cursor_id   := dbms_sql.open_cursor;
    select_stat := 'select ' || col_name ||
                   '  from ' || col_owner || '.' || :x_table_name ||
                   ' where ' || :x_where_clause;
    dbms_sql.parse(cursor_id, select_stat, dbms_sql.v7);
    dbms_sql.define_column(cursor_id, 1, col_value, 2000);
    rows_processed := dbms_sql.execute(cursor_id);

    col_line       := rpad(col_name,30,' ');
    null_column    := TRUE;
    rows_processed := 0;
    show_column    := FALSE;
    col_value_prev := 'NOT ASSIGNED';

    while dbms_sql.fetch_rows(cursor_id) > 0 loop
      dbms_sql.column_value(cursor_id, 1, col_value);
      rows_processed := rows_processed + 1;

      if col_value is null then
        col_value := '~';
      else
        null_column := FALSE;
      end if;
      col_line := col_line || rpad(substr(col_value, 1, 40), 20, ' ');

      if :x_show_mode = 3 and not show_column then
        if rows_processed > 1 and col_value_prev != col_value then
          show_column := TRUE;
        end if;
        col_value_prev := col_value;          
      end if;
    end loop;

    dbms_sql.close_cursor(cursor_id);
    if :x_show_mode = 2 then
      if NOT null_column then
        dbms_output.put_line(col_line);
      end if;
    elsif :x_show_mode = 3 then
      if rows_processed = 1 or show_column = TRUE then
        dbms_output.put_line(col_line);
      end if;
    else
      dbms_output.put_line(col_line);
    end if;

  end loop;

  if col_name = 'BAD TABLE NAME' then
    dbms_output.put_line('Table/view not exist');
  end if;
  dbms_output.put_line('==============================');
  if rows_processed > 1 then
    dbms_output.put_line(to_char(rows_processed) || ' rows processed');
  else
    dbms_output.put_line(to_char(rows_processed) || ' row processed');
  end if;
end;
/



