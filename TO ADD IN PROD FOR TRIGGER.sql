CREATE SEQUENCE APPS.DBS_PICKLIST_INT_LINE_SEQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  CACHE 20
  NOORDER;
  
  
CREATE TABLE APPS.DBS_PICKLIST_INTERFACE_LINES
(
  LINE_ID             NUMBER                    NOT NULL,
  PICKLIST_HEADER_ID  NUMBER                    NOT NULL,
  REQUEST_NUMBER      VARCHAR2(100 BYTE)        NOT NULL,
  SALES_ORDER_NUMBER  VARCHAR2(100 BYTE),
  INVENTORY_ITEM_ID   NUMBER                    NOT NULL,
  LINE_NO             NUMBER                    NOT NULL,
  PART_NO             VARCHAR2(50 BYTE),
  PART_DESCRIPTION    VARCHAR2(255 BYTE),
  REQUESTED_QUANTITY  NUMBER,
  UNIT_OF_MEASURE     VARCHAR2(50 BYTE),
  PROMISE_DATE        DATE,
  REMARKS             VARCHAR2(100 BYTE),
  CREATION_DATE       DATE
);

select *
from dbs_picklist_interface;

select distinct mtrh.header_id,
                     mtrh.request_number,
                     mtrh.header_status,
                     mtrh.organization_id,
                     mtrh.move_order_type,
                     mtrh.transaction_type_id,
                     mtrh.status_date,
                     mtrh.creation_date,
                     ooh.order_number
        from MTL_RESERVATIONS_ALL_V mr
                ,OE_ORDER_HEADERS_ALL ooh
                ,OE_ORDER_LINES_ALL ool
                ,MTL_TXN_REQUEST_LINES_V mtrl
                ,MTL_TXN_REQUEST_HEADERS_V mtrh
        where ooh.header_id=ool.header_id
        and demand_source_line_id=ool.line_id
        and mr.DEMAND_SOURCE_LINE_ID is not null
        and mtrh.header_id=mtrl.header_id
        and mtrl.txn_source_line_id=mr.DEMAND_SOURCE_LINE_ID
        and mtrh.REQUEST_NUMBER='21020';

select

         mtrh.header_id,
         mtrh.request_number,
         mtrh.header_status,
         mtrh.organization_id,
         mtrh.move_order_type,
         mtrh.transaction_type_id,
         mtrh.status_date,
         mtrh.creation_date,
         ooh.order_number,
         mr.PRIMARY_RESERVATION_QUANTITY,
         mr.RESERVATION_UOM_CODE,
         mr.RESERVATION_UOM_ID,
         mr.RESERVATION_QUANTITY,
         mr.ORGANIZATION_ID,
         mr.INVENTORY_ITEM_ID
         
from MTL_RESERVATIONS_ALL_V mr
,OE_ORDER_HEADERS_ALL ooh
,OE_ORDER_LINES_ALL ool
,MTL_TXN_REQUEST_LINES_V mtrl
,MTL_TXN_REQUEST_HEADERS_V mtrh
where ooh.header_id=ool.header_id
and demand_source_line_id=ool.line_id
and mr.DEMAND_SOURCE_LINE_ID is not null
and mtrh.header_id=mtrl.header_id
and mtrl.txn_source_line_id=mr.DEMAND_SOURCE_LINE_ID
and mtrh.REQUEST_NUMBER='21020'
and mr.staged_flag = 'Y';

select *
from mtl_reservations;

select *
from mtl_material_transactions;
select *
from mtl_reservations;
drop trigger dbs_after_insert_rs;

CREATE OR REPLACE TRIGGER dbs_after_insert_rs AFTER INSERT ON mtl_reservations
FOR EACH ROW
BEGIN
    INSERT INTO dbs_picklist_interface
    select dbs_picklist_interface_seq.nextval,
         header_details.header_id,
         header_details.request_number,
         header_details.header_status,
         header_details.organization_id,
         header_details.move_order_type,
         header_details.transaction_type_id,
         header_details.status_date,
         header_details.creation_date,
         null,
         null,
         header_details.order_number
    from (select distinct mtrh.header_id,
                         mtrh.request_number,
                         mtrh.header_status,
                         mtrh.organization_id,
                         mtrh.move_order_type,
                         mtrh.transaction_type_id,
                         mtrh.status_date,
                         mtrh.creation_date,
                         ooh.order_number
            from MTL_RESERVATIONS_ALL_V mr
                    ,OE_ORDER_HEADERS_ALL ooh
                    ,OE_ORDER_LINES_ALL ool
                    ,MTL_TXN_REQUEST_LINES_V mtrl
                    ,MTL_TXN_REQUEST_HEADERS_V mtrh
            where ooh.header_id=ool.header_id
            and demand_source_line_id=ool.line_id
            and mr.DEMAND_SOURCE_LINE_ID is not null
            and mtrh.header_id=mtrl.header_id
            and mtrl.txn_source_line_id=mr.DEMAND_SOURCE_LINE_ID
      ) header_details;
END;


CREATE OR REPLACE TRIGGER dbs_after_insert AFTER INSERT ON MTL_TXN_REQUEST_HEADERS
FOR EACH ROW
BEGIN
    INSERT INTO dbs_picklist_interface (
        picklist_id,
        header_id ,
        request_number ,
        header_status ,
        organization_id ,
        move_order_type  ,
        transaction_type_id ,
        status_date ,
        creation_date  
    )
    values(
        dbs_picklist_interface_seq.nextval,
        :new.header_id,
        :new.request_number,
        :new.header_status,
        :new.organization_id,
        :new.move_order_type,
        :new.transaction_type_id,
        :new.status_date,
        :new.creation_date
    );
END;
/
