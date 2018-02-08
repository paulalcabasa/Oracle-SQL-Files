CREATE TABLE XXIPC_DBS_ITEM_QUANTITY  (
    id number(10) not null,
    part_number varchar2(20) not null,
    locator varchar2(100) not null,
    quantity double PRECISION not null,
    date_created timestamp,
    CONSTRAINT XXIPC_DBS_ITEM_QUANTITY_PK PRIMARY KEY (id)
);

select *
from XXIPC_DBS_ITEM_QUANTITY;

select *
from XXIPC_DBS_ITEM_QUANTITY;

drop table XXIPC_DBS_ITEM_QUANTITY;

select *
from mtl_system_items_b
where organization_id = 102;

SELECT msi.inventory_item_id,
         msi.segment1 part_no,
         NVL (pl.list_price, 0) list_price,
         msi.description,
         msi.attribute4 model,
         CASE inventory_item_status_code WHEN 'Active' THEN 'A' ELSE 'N' END
            part_status,
         NVL (total_qty, 0) - NVL (reserved_qty, 0) total_available,
         CASE
            WHEN moq.last_update_date > mr.last_update_date
            THEN
               moq.last_update_date
            ELSE
               mr.last_update_date
         END
            last_update,
         msi.creation_date create_date
    FROM mtl_system_items_b msi
         LEFT JOIN (  SELECT inventory_item_id,
                             organization_id,
                             SUM (NVL (transaction_quantity, 0)) total_qty,
                             MAX (last_update_date) last_update_date
                        FROM mtl_onhand_quantities
                    GROUP BY inventory_item_id, organization_id) moq
            ON msi.organization_id = moq.organization_id
               AND msi.inventory_item_id = moq.inventory_item_id
         LEFT JOIN (  SELECT inventory_item_id,
                             organization_id,
                             SUM (NVL (reservation_quantity, 0)) reserved_qty,
                             MAX (last_update_date) last_update_date
                        FROM mtl_reservations
                    GROUP BY inventory_item_id, organization_id) mr
            ON msi.organization_id = mr.organization_id
               AND msi.inventory_item_id = mr.inventory_item_id
         LEFT JOIN (SELECT b.product_attr_val_disp part_no,
                           b.operand list_price
                      FROM qp_secu_list_headers_vl a, qp_list_lines_v b
                     WHERE a.list_header_id = b.list_header_id
                           AND a.name = 'WSP') pl
            ON msi.segment1 = pl.part_no
   WHERE 1 = 1 AND msi.organization_id = 102
-- AND msi.inventory_item_id = 155700
ORDER BY reserved_qty DESC;
