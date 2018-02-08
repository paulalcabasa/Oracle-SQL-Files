select ACRA.CASH_RECEIPT_ID, 
         ACRA.RECEIPT_NUMBER,
         BB.BANK_NAME,
         BB.BANK_BRANCH_NAME,
         CBA.BANK_ACCOUNT_NAME,
         CBA.BANK_ACCOUNT_NUM
from  AR_CASH_RECEIPTS_ALL ACRA,       
         CE_BANK_ACCOUNTS CBA,
         CE_BANK_BRANCHES_V BB,
         CE_BANK_ACCT_USES_ALL REMIT_BANK
where 1 = 1 AND REMIT_BANK.BANK_ACCT_USE_ID = ACRA.REMIT_BANK_ACCT_USE_ID
          AND CBA.BANK_ACCOUNT_ID(+) = REMIT_BANK.BANK_ACCOUNT_ID
          AND BB.BRANCH_PARTY_ID = CBA.BANK_BRANCH_ID
        --  AND ACRA.CASH_RECEIPT_ID = 14002
        and acra.status = 'UNID'
          ORDER BY ACRA.RECEIPT_NUMBER ASC;

SELECT distinct 
            REC_METHOD.NAME RECEIPT_METHOD,
       --     ACRA.CASH_RECEIPT_ID,
            ACRA.RECEIPT_NUMBER,
            acra.doc_sequence_value,
            RCTA.COMMENTS,
            RCTA.TRX_NUMBER,
            RCTTA.NAME TRANSACTION_TYPE,
     --       RCTTA.DESCRIPTION
            ACRA.CURRENCY_CODE,
            ACRA.AMOUNT,
       --  ACRA.TYPE,
       --  ACRHA.STATUS STATE,
            ACRA.RECEIPT_DATE,
            ACRA.ATTRIBUTE1 DFF_CUSTOMER_BANK,
            ACRA.ATTRIBUTE2 DFF_CHECK_NUMBER,
            ACRA.ATTRIBUTE3 DFF_CHECK_DATE,
   --      ACRHA.GL_DATE,
   --      APSA.DUE_DATE,
   --      ARAA.GL_DATE REC_GL_DATE,
            TO_CHAR(ARAA.APPLY_DATE) APPLY_DATE,
            ACRHA.ACCTD_AMOUNT FUNCTIONAL_AMOUNT,
            ACRA.DOC_SEQUENCE_VALUE,
    --     ACRA.DEPOSIT_DATE,
             PARTY.PARTY_NAME,
             CUST.ACCOUNT_NUMBER,
             CUST.ACCOUNT_NAME,
             SITE_USES.LOCATION,
             BB.BANK_NAME,
             BB.BANK_BRANCH_NAME,
             CBA.BANK_ACCOUNT_NAME,
             CBA.BANK_ACCOUNT_NUM,
      --   APSA.GL_DATE PAYMENT_GL_DATE,
  --       RCTA.TRX_NUMBER,
            ARAA.AMOUNT_APPLIED
    --    ARAA.GL_DATE APPLIED_PAYMENT_GL_DATE
FROM AR_CASH_RECEIPTS_ALL ACRA,
        AR_CASH_RECEIPT_HISTORY_ALL ACRHA,
        AR_PAYMENT_SCHEDULES_ALL APSA,
        AR_RECEIPT_METHODS REC_METHOD,
        AR_RECEIPT_CLASSES ARC,
        HZ_CUST_ACCOUNTS CUST,
        HZ_PARTIES PARTY,
        HZ_CUST_SITE_USES_ALL SITE_USES,
        CE_BANK_ACCT_USES_ALL REMIT_BANK,
        CE_BANK_ACCOUNTS CBA,
        CE_BANK_BRANCHES_V BB,
        AR_RECEIVABLE_APPLICATIONS_ALL ARAA,
        RA_CUSTOMER_TRX_ALL RCTA,
        RA_CUST_TRX_TYPES_ALL RCTTA
WHERE ACRA.CASH_RECEIPT_ID = ACRHA.CASH_RECEIPT_ID
AND RCTTA.CUST_TRX_TYPE_ID = RCTA.CUST_TRX_TYPE_ID
          AND APSA.CASH_RECEIPT_ID = ACRA.CASH_RECEIPT_ID
          AND ACRA.RECEIPT_METHOD_ID = REC_METHOD.RECEIPT_METHOD_ID
          AND ARC.RECEIPT_CLASS_ID = REC_METHOD.RECEIPT_CLASS_ID
          AND SITE_USES.SITE_USE_ID(+) = ACRA.CUSTOMER_SITE_USE_ID
          AND ACRA.PAY_FROM_CUSTOMER = CUST.CUST_ACCOUNT_ID(+)
          AND CUST.PARTY_ID = PARTY.PARTY_ID(+)
          AND REMIT_BANK.BANK_ACCT_USE_ID = ACRA.REMIT_BANK_ACCT_USE_ID
          AND CBA.BANK_ACCOUNT_ID(+) = REMIT_BANK.BANK_ACCOUNT_ID
          AND BB.BRANCH_PARTY_ID = CBA.BANK_BRANCH_ID
          AND ARAA.CASH_RECEIPT_ID = ACRA.CASH_RECEIPT_ID
--          and ACRA.RECEIPT_NUMBER = '092020'
         -- AND RCTA.TRX_NUMBER=  '40200001585'
          AND RCTA.CUSTOMER_TRX_ID = ARAA.APPLIED_CUSTOMER_TRX_ID(+)
        AND ARAA.DISPLAY = 'Y'
-- and rcta.trx_date between '01-MAY-2017' AND '30-MAY-2017'
     --     AND rcta.trx_number like '403%9295'
        AND REC_METHOD.NAME = 'COLLECTION RECEIPTS 2'
       order by ACRA.RECEIPT_NUMBER asc ;

SELECT cash_receipt_id,receipt_number,receipt_date,creation_date
FROM AR_CASH_RECEIPTS_ALL   
WHERE receipt_number IN('60235');
-- 31001,31003,31004
UPDATE  AR_CASH_RECEIPTS_ALL
SET RECEIPT_DATE = '26-JAN-2017',
       DEPOSIT_DATE = '26-JAN-2017'
WHERE CASH_RECEIPT_ID IN(6025);

UPDATE AR_CASH_RECEIPT_HISTORY_ALL
SET GL_DATE  = '26-JAN-2017',
       TRX_DATE = '26-JAN-2017'
WHERE CASH_RECEIPT_ID IN(6025);

UPDATE AR_RECEIVABLE_APPLICATIONS_ALL
SET gl_date = '26-JAN-2017',
       apply_date = '26-JAN-2017'
    WHERE CASH_RECEIPT_ID IN(6025);

UPDATE AR_PAYMENT_SCHEDULES_ALL
SET DUE_DATE = '26-JAN-2017',
      gl_date =  '26-JAN-2017'
WHERE CASH_RECEIPT_ID IN(6025);

COMMIT;


select *
from ra_customer_trx_all
where ct_reference like '3010008989';

select *
from ra_customer_trx_all
where comments like '%980239935%';

select *
from ra_custo

select *
from ra_customer_trx_all
where attribute1 = '1340';

select *
from ra_customer_trx_all
where trx_number = '50100000070';

select *
from ra_customer_trx_lines_all
where customer_trx_id = 694768;

select *
from ra_customer_trx_all
where interface_header_attribute1 = '3010002108';








select *
from ra_customer_trx_all
where trx_number = '980239896';

select *
from ra_customer_trx_all
where comments = '980239896';

select *
from ar_cash_receipts_all
where cash_receipt_id = 22031;

SELECT trx_number,trx_date,interface_header_attribute1
FROM RA_CUSTOMER_TRX_ALL;

select *
from ra_customer_trX_all
where interface_header_attribute1 = '3010006140';

select *
from ra_customer_trx_all
where comments like '%980242048%';

SELECT *
FROM RA_CUSTOMER_TRX_ALL
WHERE INTERFACE_HEADER_ATTRIBUTE1 LIKE '%3010005842%';

select *
from ar_cash_receipts_all
where COMMENTS IN (59709
,59926
,60303);

SELECT DISTINCT COMMENTS
FROM AR_CASH_RECEIPTS_ALL;

SELECT 
msn.current_subinventory_code subinventory_code
,msi.inventory_item_id
,mp.organization_code 
,msi.segment1 item_model    
,msn.serial_number cs_number
,msn.lot_number lot_number
,msn.attribute2 chassis_no
,msn.attribute4 body_number
,msn.attribute3 engine_no
,msi.attribute11 engine_model
,msn.attribute6 key_number
,msi.attribute8  body_color
,SUBSTR(msn.attribute7, 1,instr(msn.attribute7,'/') - 1) ac_no
,substr(msn.attribute7, - instr(reverse(msn.attribute7), '/') + 1) ac_brand
,SUBSTR(msn.attribute9, 1,instr(msn.attribute9,'/') - 1) stereo_no
,substr(msn.attribute9, - instr(reverse(msn.attribute9), '/') + 1) stereo_brand
,substr(msn.attribute11, - instr(reverse(msn.attribute11), '/') + 1) fm_date
,msn.attribute5 as buyoff_date
,msi.item_type
FROM mtl_system_items_b msi
LEFT JOIN mtl_serial_numbers msn
ON msi.inventory_item_id = msn.inventory_item_id
AND msi.organization_id = msn.current_organization_id
LEFT JOIN mtl_parameters mp
ON msi.organization_id = mp.organization_id
WHERE 1 = 1
AND mp.organization_code IN ('IVP','NYK','PSI')
AND msi.item_type = 'FG'
AND msn.current_status = 3
ORDER BY msn.serial_number DESC;

SELECT *
FROM XXIPC_CUSTOMER_DETAIL_V;

CREATE OR REPLACE FORCE VIEW XXIPC_VEHICLE_INQUIRY_V AS SELECT 
msn.current_subinventory_code subinventory_code
,msi.inventory_item_id
,mp.organization_code 
,msi.segment1 item_model    
,msn.serial_number cs_number
,msn.lot_number lot_number
,msn.attribute2 chassis_no
,msn.attribute4 body_number
,msn.attribute3 engine_no
,msi.attribute11 engine_model
,msn.attribute6 key_number
,msi.attribute8  body_color
,SUBSTR(msn.attribute7, 1,instr(msn.attribute7,'/') - 1) ac_no
,substr(msn.attribute7, - instr(reverse(msn.attribute7), '/') + 1) ac_brand
,SUBSTR(msn.attribute9, 1,instr(msn.attribute9,'/') - 1) stereo_no
,substr(msn.attribute9, - instr(reverse(msn.attribute9), '/') + 1) stereo_brand
,substr(msn.attribute11, - instr(reverse(msn.attribute11), '/') + 1) fm_date
,msn.attribute5 as buyoff_date
,msi.item_type
FROM mtl_system_items_b msi
LEFT JOIN mtl_serial_numbers msn
ON msi.inventory_item_id = msn.inventory_item_id
AND msi.organization_id = msn.current_organization_id
LEFT JOIN mtl_parameters mp
ON msi.organization_id = mp.organization_id
WHERE 1 = 1
AND mp.organization_code IN ('IVP','NYK','PSI')
AND msi.item_type = 'FG'
AND msn.current_status = 3
ORDER BY msn.serial_number DESC;
COMMIT;

SELECT *
FROM XXIPC_VEHICLE_INQUIRY_V;

select   a.trx_number, 
            sum(extended_amount) invoice_amount,
            b.amount_applied,
            cash_receipt_id, 
            a.customer_trx_id, 
            hcsua.TAX_REFERENCE TAX_REFERENCE_ALL
           
from RA_CUSTOMER_TRX_ALL a,
        AR_RECEIVABLE_APPLICATIONS_ALL b,
        RA_CUSTOMER_TRX_lines_ALL c,
        hz_cust_site_uses_all hcsua
where c.customer_trx_id = a.customer_trx_id
        and b.APPLIED_CUSTOMER_TRX_ID = a.customer_trx_id
        and a.bill_to_site_use_id = hcsua.SITE_USE_ID
  and b.amount_applied > 0
        AND cash_receipt_id BETWEEN :or_from AND :or_to
        and B.display = 'Y'
group by a.trx_number,
              cash_receipt_id,
              a.customer_trx_id,
              hcsua.TAX_REFERENCE,
              b.amount_applied
           
              order by a.trx_number;
              


 AR_CASH_RECEIPTS_ALL ACRA,
        AR_CASH_RECEIPT_HISTORY_ALL ACRHA,
        AR_PAYMENT_SCHEDULES_ALL APSA,
        AR_RECEIPT_METHODS REC_METHOD,
        AR_RECEIPT_CLASSES ARC,
        
SELECT ACRA.RECEIPT_NUMBER,
            REC.NAME
FROM AR_CASH_RECEIPTS_ALL ACRA,
          AR_RECEIPT_METHODS REC
WHERE ACRA.RECEIPT_METHOD_ID = REC.RECEIPT_METHOD_ID
;

select *
from dbs_picklist_interface
where request_number = '1048939';

SELECT receipt_number,receipt_date
FROM ar_cash_receipts_all
where receipt_date BETWEEN '01-MAY-2017' and '31-MAY-2017'
and amount <> 0;

-- 2012264

select *
from po_headers_all
where segment1 LIKE '%201%2264%';
select *
from rcv_transactions
where po_header_id = 505376
and transaction_type = 'RECEIVE';

select *
from po_receipts_all;

 SELECT  
              pha.po_header_id,
              pha.segment1 "po number",
              rsh.receipt_num "receipt number"
FROM   po_headers_all pha,
              rcv_shipment_lines  rsl,
              rcv_shipment_headers rsh
WHERE  1=1
AND     pha.po_header_id=rsl.po_header_id
AND     rsl.shipment_header_id=rsh.shipment_header_id
AND     pha.segment1='20100002264';--po number;

select *
from RCV_VRC_TXS_V;

select receipt_number
from ar_cash_receipts_all
where receipt_date >= '31-MAY-2017';

select receipt_number
from ar_cash_receipts_all
where amount = '509821.93';