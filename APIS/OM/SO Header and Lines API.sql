DELETE FROM  oe_headers_iface_all  WHERE ORIG_SYS_DOCUMENT_REF like 'PAUL%';
DELETE FROM  oe_lines_iface_all  WHERE ORIG_SYS_DOCUMENT_REF like 'PAUL%';

SELECT * FROM oe_headers_iface_all;
SELECT * FROM oe_lines_iface_all;
SELECT sold_to_org_id
FROM oe_order_headers_all;

SELECT *
FROM hz_cust_acc
;
SELECT *
FROM HZ_CUST_ACCOUNTS_ALL
WHERE account_number = 1744;

SELECT *
FROM HZ_PARTIES
WHERE PARTY_ID = 33132;
where orig_sys_document_ref LIKE 'PAUL001';


SELECT INVENTORY_ITEM_ID
FROM mtl_system_items
where organization_id = 102;

SELECT *
FROM oe_headers_iface_all;

SELECT ship_to_org_id
FROM OE_ORDER_HEADERS_ALL
WHERE ORIG_SYS_DOCUMENT_REF = 'PAUL-004';

/* INSERT HEADERS TO ORDER INTERFACE */
 INSERT INTO oe_headers_iface_all  ( 
     order_source_id            
    , ORIG_SYS_DOCUMENT_REF      
    , ORG_ID                     
    , CUSTOMER_NUMBER             
    , CUSTOMER_NAME
    , SHIP_TO_PARTY_SITE_ID
    , INVOICE_SITE_CODE
    , ORDER_TYPE_ID
    , ORDER_TYPE
    , SALESREP
    , CUSTOMER_PO_NUMBER
    , ORDERED_DATE
    , REQUEST_DATE
    , PRICE_LIST_ID
    , PRICE_LIST
    , PAYMENT_TERM_ID
    , PAYMENT_TERM 
    , FREIGHT_TERMS
    , FOB_POINT
    , TRANSACTIONAL_CURR_CODE
    , SOLD_TO_ORG_ID
    , SHIP_FROM_ORG_ID
    , SHIP_FROM_ORG 
    , ORDER_SOURCE
    , BOOKED_FLAG
    , OPERATION_CODE
    ,created_by
    ,creation_date
    ,last_updated_by
    ,last_update_date
 )
VALUES (
        1001,     -- oe_order_sources.order_source_id
        'PAUL007',     -- Any reference                 ,c3.orig_sys_document_ref
        82,    --     Operating Unit      , c3.org_id
        1744,   --                  , c3.customer_number
        NULL,     --                  , c3.customer_name
        31505,          --  select * from hz_party_sites where party_id = 33100 and party_site_number =     6586;                , c3.ship_to_party_site_id
        4735,           --                  , c3.invoice_to_location
        1142,           --                  , c3.order_type_ID,
        NULL,           --                  , c3.order_type
        'No Sales Credit',           --                  , c3.salesrep
        'PAUL-PO-007',          --                  , c3.cust_po_number
        SYSDATE,        --                  , c3.ordered_date
        SYSDATE   ,     --                  , c3.request_date
        9073,            --                  , c3.price_list_ID
         NULL,            --                  , c3.price_list
        1000,          --                  , c3.payment_term_ID,
        NULL,          --                  , c3.payment_term
        NULL,          --                  , c3.freight_terms
        NULL,          --                  , c3.fob_point
        'PHP'    ,       --                  , c3.transactional_curr_code
        15084, -- SOLD TO ORG _ID
        102,         --                  , c3.ship_from_org_ID
        NULL,         --                  , c3.ship_from_org
        NULL,        --                  , c3.order_source
        'N',        --                  , (SELECT DECODE(UPPER(c3.booked_flag),'BOOKED','Y', 'N') FROM dual)
        'INSERT',        --                  , 'INSERT'
        fnd_global.user_id,
        SYSDATE,
        fnd_global.user_id,
        SYSDATE
);

SELECT *
FROM oe_lines_iface_all;

SELECT DISTINCT SHIP_FROM_ORG_ID
FROM OE_ORDER_LINES_ALL;

DELETE FROM oe_headers_iface_all where ORIG_SYS_DOCUMENT_REF like 'Test%';

/* INSERT LINES TO ORDER INTERFACE */
 INSERT INTO oe_lines_iface_all( 
     ORDER_SOURCE_ID
    , ORIG_SYS_DOCUMENT_REF
    , ORIG_SYS_LINE_REF
    , org_id
    , LINE_NUMBER
    , INVENTORY_ITEM_ID
    --, STATUS_FLAG
    , ORDERED_QUANTITY
    , ORDER_QUANTITY_UOM
    , ORDERED_QUANTITY2
    , ORDERED_QUANTITY_UOM2
    , UNIT_SELLING_PRICE
    , PRICE_LIST_ID
    , PRICE_LIST
    , LINE_TYPE_ID
    , LINE_TYPE
    , CANCELLED_QUANTITY
    , FULFILLED_QUANTITY
    , UNIT_LIST_PRICE
    , REQUEST_DATE
    , SCHEDULE_SHIP_DATE
    , SHIP_FROM_ORG_ID
    , SHIP_TO_PARTY_SITE_ID
    , iNVOICE_TO_PARTY_SITE_ID
    , SALESREP
    , PAYMENT_TERM_ID
    , PRICING_CONTEXT
    , CALCULATE_PRICE_FLAG
    , PRICING_QUANTITY
    , PRICING_QUANTITY_UOM
    , PRICING_DATE
    , SUBINVENTORY
    , SCHEDULE_ARRIVAL_DATE
    , PROMISE_DATE
    , SOURCE_TYPE_CODE
    , SHIPMENT_PRIORITY
    , OPERATION_CODE
    , created_by
    , creation_date
    , last_updated_by
    , last_update_date
)


VALUES ( 
     1001, --,c3.order_source_id
    'PAUL005', -- ,c3.orig_sys_document_ref
    1, -- c4.line_number
    82,-- c3.org_id
    1,-- c4.line_number
    83695, --c4.line_inventory_item
    1, -- c4.line_ordered_quantity
    'PCS', --, c4.line_order_quantity_uom
    NULL, -- c4.line_ordered_quantity2
    NULL, --c4.line_ordered_quantity_uom2
    1000, --c4.line_unit_selling_price
    9073, --c4.line_price_list_ID
    NULL, -- price list name
     1061, --c4.line_type_ID
     NULL, -- LINE TYPE
    NULL ,-- c4.line_cancelled_quantity
    NULL, --c4.line_fulfilled_quantity
    1, --c4.line_unit_list_price
    SYSDATE,-- c4.line_request_date
    SYSDATE+2, --c4.line_SCHEDULE_SHIP_DATE
     102, --c4.line_SHIP_FROM_ORG
    NULL,--31505, --c4.line_SHIP_TO_PARTY_SITE_ID
     NULL,--31505, --c4.line_iNVC_TO_PARTY_SITE_ID
    -3, --c4.line_SALESREP
    1000, --c4.line_PAYMENT_TERM
     NULL, -- c4.line_PRICING_CONTEXT
     'N', --(SELECT DECODE(c4.line_CALCULATE_PRICE_FLAG,'Freeze Price', 'N', 'Calculate Price', 'Y', 'Partial', 'P', NULL) FROM dual)
    NULL, --c4.line_PRICING_QUANTITY
    NULL, --c4.line_PRICING_QUANTITY_UOM
   NULL ,-- c4.line_PRICING_DATE
    NULL, --c4.line_SUBINVENTORY
    SYSDATE+2, --c4.line_SCHEDULE_ARRIVAL_DATE
    SYSDATE+2, --c4.line_PROMISE_DATE
    NULL, --c4.line_SOURCE_TYPE
    NULL --c4.line_SHIPMENT_PRIORITY
    , 'INSERT'
    , fnd_global.user_id
    , SYSDATE
    , fnd_global.user_id
    , SYSDATE
);
                   
               


SELECT *
FROM hr_all_organization_units;

select *
from RA_TERMS_TL;
select *
from oe_order_types_v ;

select *
from oe_order_type;


select *
from oe_transaction_types_all;


select *
from hz_cust_accounts_all
where account_number = '1744';

select *
from hz_locations
where location_id = 4735;

select * from hz_party_sites where party_id = 33100 and party_site_number =     6586;


SELECT *
FROM qp_list_headers_b
WHERE list_header_id IN (SELECT list_header_id
                         FROM qp_list_headers_tl);           --Price List Name  
 /*  CURSOR c_so_hdr1 IS
      SELECT DISTINCT orig_sys_document_ref, operating_unit, org_id, customer_number, customer_name
            , ship_to_location, ship_to_party_site_id, invoice_to_location, booked_flag
            , order_type, salesrep, cust_po_number, ordered_date
            , request_date, price_list, payment_term, freight_terms, fob_point
            , transactional_curr_code, ship_from_org, order_source, order_source_id 
      FROM xxconv_ont_sales_order_staging
      WHERE file_header_id = p_file_header_id
      AND status = 'VALID' ;
      
   CURSOR c_so_lines1 (p_orig_doc_ref IN VARCHAR2 )
   IS SELECT line_number, line_inventory_item
            , line_ordered_quantity, line_order_quantity_uom, line_ordered_quantity2, line_ordered_quantity_uom2
            , line_booked_flag, line_unit_selling_price, line_price_list, line_type, line_cancelled_quantity
            , line_fulfilled_quantity, line_unit_list_price, line_request_date, line_schedule_ship_date, line_ship_from_org
            , line_ship_to_location, line_invoice_to_location, line_salesrep, line_freight_terms, line_fob_point
            , line_payment_term, line_order_source, line_pricing_context, line_calculate_price_flag, line_pricing_date
            , line_pricing_quantity, line_pricing_quantity_uom, line_subinventory, line_schedule_arrival_date
            , line_promise_date, line_source_type, line_shipment_priority, line_iNVC_TO_PARTY_SITE_ID, line_ship_TO_PARTY_SITE_ID
      FROM xxconv_ont_sales_order_staging
      WHERE file_header_id = p_file_header_id
      AND orig_sys_document_ref =   p_orig_doc_ref
      AND status = 'VALID'; 


         FOR c3 IN c_so_hdr1
         LOOP
            INSERT INTO oe_headers_iface_all
               ( order_source_id            
               , ORIG_SYS_DOCUMENT_REF      
               , ORG_ID                     
               , CUSTOMER_NUMBER             
               , CUSTOMER_NAME
               , SHIP_TO_PARTY_SITE_ID
               , INVOICE_SITE_CODE
               , ORDER_TYPE
               , SALESREP
               , CUSTOMER_PO_NUMBER
               , ORDERED_DATE
               , REQUEST_DATE
               , PRICE_LIST
               , PAYMENT_TERM 
               , FREIGHT_TERMS
               , FOB_POINT
               , TRANSACTIONAL_CURR_CODE
               , SHIP_FROM_ORG 
               , ORDER_SOURCE
               , BOOKED_FLAG
               , OPERATION_CODE
               ,created_by
               ,creation_date
               ,last_updated_by
               ,last_update_date
               )
            VALUES
               ( c3.order_source_id
                  ,c3.orig_sys_document_ref
                  , c3.org_id
                  , c3.customer_number
                  , c3.customer_name
                  , c3.ship_to_party_site_id
                  , c3.invoice_to_location
                  , c3.order_type
                  , c3.salesrep
                  , c3.cust_po_number
                  , c3.ordered_date
                  , c3.request_date
                  , c3.price_list
                  , c3.payment_term
                  , c3.freight_terms
                  , c3.fob_point
                  , c3.transactional_curr_code
                  , c3.ship_from_org
                  , c3.order_source
                  , (SELECT DECODE(UPPER(c3.booked_flag),'BOOKED','Y', 'N') FROM dual)
                  , 'INSERT'
                  , fnd_global.user_id
                  , SYSDATE
                  , fnd_global.user_id
                  , SYSDATE
               );
         
            FOR c4 IN c_so_lines1 (c3.orig_sys_document_ref)
            LOOP
               INSERT INTO oe_lines_iface_all   
                  ( ORDER_SOURCE_ID
                  , ORIG_SYS_DOCUMENT_REF
                  , ORIG_SYS_LINE_REF
                  , org_id
                  , LINE_NUMBER
                  , INVENTORY_ITEM
                  --, STATUS_FLAG
                  , ORDERED_QUANTITY
                  , ORDER_QUANTITY_UOM
                  , ORDERED_QUANTITY2
                  , ORDERED_QUANTITY_UOM2
                  , UNIT_SELLING_PRICE
                  , PRICE_LIST
                  , LINE_TYPE
                  , CANCELLED_QUANTITY
                  , FULFILLED_QUANTITY
                  , UNIT_LIST_PRICE
                  , REQUEST_DATE
                  , SCHEDULE_SHIP_DATE
                  , SHIP_FROM_ORG
                  , SHIP_TO_PARTY_SITE_ID
                  , iNVOICE_TO_PARTY_SITE_ID
                  , SALESREP
                  , PAYMENT_TERM
                  , PRICING_CONTEXT
                  , CALCULATE_PRICE_FLAG
                  , PRICING_QUANTITY
                  , PRICING_QUANTITY_UOM
                  , PRICING_DATE
                  , SUBINVENTORY
                  , SCHEDULE_ARRIVAL_DATE
                  , PROMISE_DATE
                  , SOURCE_TYPE_CODE
                  , SHIPMENT_PRIORITY
                  , OPERATION_CODE
                  , created_by
                  , creation_date
                  , last_updated_by
                  , last_update_date
                  )
               VALUES  -- xxconv_ont_sales_order_staging
                  (  c3.order_source_id
                     ,c3.orig_sys_document_ref
                     , c4.line_number
                     , c3.org_id
                     , c4.line_number
                     , c4.line_inventory_item
                     , c4.line_ordered_quantity
                     , c4.line_order_quantity_uom
                     , c4.line_ordered_quantity2
                     , c4.line_ordered_quantity_uom2
                     , c4.line_unit_selling_price
                     , c4.line_price_list
                     , c4.line_type
                     , c4.line_cancelled_quantity
                     , c4.line_fulfilled_quantity
                     , c4.line_unit_list_price
                     , c4.line_request_date
                     , c4.line_SCHEDULE_SHIP_DATE
                     , c4.line_SHIP_FROM_ORG
                     , c4.line_SHIP_TO_PARTY_SITE_ID
                     , c4.line_iNVC_TO_PARTY_SITE_ID
                     , c4.line_SALESREP
                     , c4.line_PAYMENT_TERM
                     , c4.line_PRICING_CONTEXT
                     , (SELECT DECODE(c4.line_CALCULATE_PRICE_FLAG,'Freeze Price', 'N', 'Calculate Price', 'Y', 'Partial', 'P', NULL) FROM dual)
                     , c4.line_PRICING_QUANTITY
                     , c4.line_PRICING_QUANTITY_UOM
                     , c4.line_PRICING_DATE
                     , c4.line_SUBINVENTORY
                     , c4.line_SCHEDULE_ARRIVAL_DATE
                     , c4.line_PROMISE_DATE
                     , c4.line_SOURCE_TYPE
                     , c4.line_SHIPMENT_PRIORITY
                     , 'INSERT'
                     , fnd_global.user_id
                     , SYSDATE
                     , fnd_global.user_id
                     , SYSDATE
               );
            END LOOP;
         
         END LOOP;
         
         
         */