select SHIP_HEAD.SHIP_NUM,
         SHIP_HEAD.SHIP_STATUS_CODE,
         ORG.NAME,
         SHIP_LINES.SHIP_LINE_NUM,
         SHIP_LINES.SHIP_LINE_SRC_TYPE_CODE,
         SHIP_LINES.CURRENCY_CODE,
         SHIP_LINES.INVENTORY_ITEM_ID,
         MSIB.SEGMENT1,
         MSIB.DESCRIPTION,
         SHIP_LINES.TXN_QTY,
         SHIP_LINES.TXN_UOM_CODE,
         SHIP_LINES.TXN_UNIT_PRICE,
         SHIP_LINES.PRIMARY_QTY,
         SHIP_LINES.PRIMARY_UOM_CODE,
         SHIP_LINES.PRIMARY_UNIT_PRICE,
         SHIP_LINES.LANDED_COST_FLAG,
         SHIP_LINES.TRX_BUSINESS_CATEGORY,
         SHIP_LINES.SHIP_FROM_PARTY_ID,
         SHIP_LINES.SHIP_FROM_PARTY_SITE_ID,
         SHIP_LINES.SHIP_TO_ORGANIZATION_ID,
         SHIP_LINES.SHIP_TO_LOCATION_ID,
         SHIP_LINES.BILL_FROM_PARTY_ID,
         SHIP_LINES.BILL_FROM_PARTY_SITE_ID
from INL_SHIP_HEADERS_ALL SHIP_HEAD,
        INL_SHIP_LINES_ALL SHIP_LINES,
        HR_ALL_ORGANIZATION_UNITS ORG,
        MTL_SYSTEM_ITEMS_B MSIB
where 1 = 1
          AND SHIP_HEAD.SHIP_HEADER_ID = SHIP_LINES.SHIP_HEADER_ID
          AND ORG.ORGANIZATION_ID = SHIP_HEAD.ORGANIZATION_ID
          AND MSIB.INVENTORY_ITEM_ID = SHIP_LINES.INVENTORY_ITEM_ID
          AND SHIP_HEAD.ship_num = 88 ;

select  *
from INL_SHIP_LINES_ALL
where ship_header_id = 66021;

SELECT *
FROM INL_SHIP_HEADERS_ALL;

select *
from po_headers_all
where po_header_id = 248325;

select *
from po_lines_all
where po_line_id  = 248325;

select *
from INL_ENTITIES_B;

select *
from INL_PO_SOURCE_LINES_V;

select *
from INL_ENTER_RECEIPTS_V;

select *
from INL_ALLOCATIONS;