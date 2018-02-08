SELECT b.segment1 "Supplier No",
       b.vendor_name "Supplier Name",
       c.vendor_site_code,
       c.pay_group_lookup_code,
       a.invoice_num invoice_number,
       a.invoice_date,
       a.gl_date,
       d.due_date,
       a.invoice_currency_code,
       a.invoice_amount,
       a.amount_paid,
       a.pay_group_lookup_code,
       d.payment_priority,
       (SELECT MAX (check_date)
          FROM ap_checks_all aca, ap_invoice_payments_all aip
         WHERE aca.CHECK_ID = aip.CHECK_ID AND aip.invoice_id = a.invoice_id)
          "Last Payment Made on",
          a.cancelled_date
  FROM apps.ap_invoices_all a,
       apps.ap_suppliers b,
       apps.ap_supplier_sites_all c,
       apps.ap_payment_schedules_all d,
       apps.ap_invoice_payments_all ap,
       ap_checks_all ac
WHERE     a.vendor_id = b.vendor_id
       AND a.vendor_site_id = c.vendor_site_id
       AND b.vendor_id = c.vendor_id
       AND a.invoice_id = d.invoice_id(+)
       AND ap.invoice_id = a.invoice_id(+)
       AND ac.CHECK_ID = ap.CHECK_ID
       and ac.STATUS_LOOKUP_CODE <> 'VOIDED'
 --      and   a.amount_paid = 0;
   --    AND a.org_id = 89
 --      and a.invoice_id= 1234
   --    AND a.pay_group_lookup_code IN ('DISTRIBUTOR')
   --    AND ac.check_date BETWEEN TO_DATE ('01-Apr-2014', 'DD-MON-YYYY') AND TO_DATE ('30-Jun-2014 23:59:59', 'DD-MON-YYYY HH24:MI:SS')
   ;
   select aps.segment1 "Supplier No",
            aps.vendor_name "Supplier Name",
            aia.doc_sequence_value "AP Voucher Number",
            aia.invoice_num "Invoice Reference",
            (aia.invoice_amount - aia.amount_paid) *  nvl(aia.exchange_rate,1) "Amount",
            to_char(aia.gl_date) "GL Date",
            aia.invoice_currency_code "Currency",
            nvl(aia.exchange_rate,1) "Currency Rate",
            (aia.invoice_amount - aia.amount_paid)  "Currency Amount",
            aia.ACCTS_PAY_CODE_COMBINATION_ID,
             (select segment6 from gl_code_combinations_kfv where CODE_COMBINATION_ID = aia.ACCTS_PAY_CODE_COMBINATION_ID) "AP Account"
   from ap_invoices_all aia,
           ap_suppliers aps
   where 1 = 1
             and aia.vendor_id = aps.vendor_id
             and aia.invoice_amount > aia.amount_paid
             and aia.accts_pay_code_combination_id = (CASE WHEN lower(:P_AP_GROUP) = 'all' THEN aia.accts_pay_code_combination_id ELSE TO_NUMBER(:P_AP_GROUP) end)
            ; 
            -- 1018 25073
            SELECT (CASE WHEN :P_AP_GROUP = 'all' THEN 1 ELSE :P_AP_GROUP  end)
            FROM DUAL;
            
            
select   aps.segment1 "Supplier No",
            aps.vendor_name "Supplier Name",
            aia.doc_sequence_value "AP Voucher Number",
            aia.invoice_num "Invoice Reference",
            (aia.invoice_amount - aia.amount_paid) *  nvl(aia.exchange_rate,1) "Amount",
            to_char(aia.gl_date) "GL Date",
            aia.invoice_currency_code "Currency",
            nvl(aia.exchange_rate,1) "Currency Rate",
            (aia.invoice_amount - aia.amount_paid)  "Currency Amount",
            (select segment6 from gl_code_combinations_kfv where CODE_COMBINATION_ID = aia.ACCTS_PAY_CODE_COMBINATION_ID) "AP Account"
from ap_invoices_all aia,
        ap_suppliers aps
where 1 = 1
         and aia.vendor_id = aps.vendor_id
         and aia.invoice_amount > aia.amount_paid
         and aia.invoice_date <= to_date(:P_AS_OF, 'YYYY/MM/DD HH24:MI:SS') 
         and aia.accts_pay_code_combination_id = (CASE WHEN lower(:P_AP_GROUP) = 'all' THEN aia.accts_pay_code_combination_id ELSE TO_NUMBER(:P_AP_GROUP) end);

/****** IPC AP Invoices Query For Ms. Grace******/
select *
from ap_invoice_payments_all;

select *
from ap_checks_all;

select *
from ap_invoices_all
where doc_sequence_value = '20022699';

select 
     
         to_char(aia.doc_sequence_value) voucher_num,
         to_char(aia.invoice_num) invoice_num,
         to_char(aia.invoice_date) invoice_date,
         to_char(aia.gl_date) gl_date,
         to_char(aia.creation_date) creation_date,
         fu_create.user_name created_by,
         fu_create.description created_by_name,
         aps.vendor_name supplier_name,
         aia.invoice_amount,
         
         DECODE(AP_INVOICES_PKG.GET_POSTING_STATUS(aia.INVOICE_ID),
            'D', 'No',
            'N','No',
            'P','Partial',
            'Y','Yes') accounted,       
        DECODE(APPS.AP_INVOICES_PKG.GET_APPROVAL_STATUS(
            aia.invoice_id, 
            aia.invoice_amount,
            aia.payment_status_flag,
            aia.invoice_type_lookup_code
        ),
        'NEVER APPROVED', 'Never Validated',
        'NEEDS REAPPROVAL', 'Needs Revalidation',
        'CANCELLED', 'Cancelled',
        'Validated') status,
        aia.wfapproval_status approval_status
from ap_invoices_all aia,
        ap_suppliers aps,
        fnd_user fu_create

where 1 = 1

        and fu_create.user_id(+) = aia.created_by
        and aps.vendor_id = aia.vendor_id
     and aia.invoice_date <= '31-AUG-2017'
     --   AND ACA.STATUS_LOOKUP_CODE <>'VOIDED'
--        and aia.invoice_id = a_sel.invoice_id(+)
        --and aipa.invoice_id(+) = aia.invoice_id;
        ;
        
        and aia.doc_sequence_value in ('20000019','20022958');
        and aia.doc_sequence_value IN ('20000005',
'20000006',
'20000007',
'20000008',
'20000009',
'20000010',
'20000011',
'20000019',
'20000025',
'20000026',
'20000259',
'20000673',
'20000833',
'20002099',
'20004131',
'20010284',
'20021302',
'20022698',
'20022699',
'20022700',
'20022701',
'20022702',
'20022703',
'20022704',
'20022705',
'20022706',
'20022707',
'20022708',
'20022709',
'20022710',
'20022711',
'20022712',
'20022713',
'20022714',
'20022715',
'20022716',
'20022717',
'20022718',
'20022719',
'20022720',
'20022721',
'20022722',
'20022723',
'20022724',
'20022725',
'20022726',
'20022727',
'20022728',
'20022729',
'20022730',
'20022731',
'20022732',
'20022733',
'20022734',
'20022735',
'20022736',
'20022737',
'20022738',
'20022739',
'20022740',
'20022741',
'20022742',
'20022743',
'20022744',
'20022745',
'20022746',
'20022747',
'20022748',
'20022749',
'20022750',
'20022751',
'20022752',
'20022753',
'20022754',
'20022755',
'20022756',
'20022757',
'20022758',
'20022759',
'20022760',
'20022761',
'20022762',
'20022763',
'20022764',
'20022765',
'20022766',
'20022767',
'20022768',
'20022769',
'20022770',
'20022771',
'20022772',
'20022773',
'20022774',
'20022775',
'20022776',
'20022777',
'20022778',
'20022779',
'20022780',
'20022781',
'20022782',
'20022783',
'20022784',
'20022785',
'20022786',
'20022787',
'20022789',
'20022790',
'20022791',
'20022792',
'20022793',
'20022794',
'20022795',
'20022796',
'20022797',
'20022798',
'20022799',
'20022800',
'20022801',
'20022802',
'20022803',
'20022804',
'20022805',
'20022806',
'20022807',
'20022808',
'20022809',
'20022810',
'20022811',
'20022812',
'20022813',
'20022814',
'20022815',
'20022816',
'20022817',
'20022818',
'20022819',
'20022820',
'20022821',
'20022822',
'20022823',
'20022824',
'20022825',
'20022826',
'20022827',
'20022828',
'20022829',
'20022830',
'20022831',
'20022832',
'20022833',
'20022834',
'20022835',
'20022836',
'20022837',
'20022838',
'20022839',
'20022840',
'20022841',
'20022842',
'20022843',
'20022844',
'20022845',
'20022846',
'20022847',
'20022848',
'20022850',
'20022851',
'20022852',
'20022853',
'20022854',
'20022855',
'20022856',
'20022857',
'20022858',
'20022859',
'20022860',
'20022861',
'20022862',
'20022863',
'20022864',
'20022865',
'20022866',
'20022867',
'20022868',
'20022876',
'20022880',
'20022881',
'20022933',
'20022934',
'20022940',
'20022944',
'20022955',
'20022956',
'20022957',
'20022958',
'20023617',
'20024021',
'20025432')
        --and aia.GL_dATE BETWEEN  '01-JAN-2017' AND '30-JUN-2017'
   ORDER BY aia.doc_sequence_value;
   
   
   select *
   from fnd_user;
     --  and aia.gl_date >= '01-JUN-2017' -- AND '30-JUN-2017';
 ;
-- PARAMETER : GL_DATE 

select *

from dbs_delivery_receipt_interface
where dr_number = 24924;







;

select trx_number
from ra_customer_trx_all rcta,

where trx_number = '980211768';

SELECT
            hca.ACCOUNT_NUMBER,
            
            hca.ACCOUNT_NAME,
            hp.party_name,
          --  rct.bill_to_site_use_id,
            hcsua.location,
            hcsua.site_use_code
            
FROM    HZ_CUST_ACCOUNTS HCA,
            RA_CUSTOMER_TRX_all RCT,
            hz_parties hp,
            hz_cust_site_uses_all hcsua

WHERE 1 = 1
            and HCA.CUST_ACCOUNT_ID=RCT.BILL_TO_CUSTOMER_ID
            and hp.party_id = hca.party_id
            and hcsua.site_use_id = rct.bill_to_site_use_id
GROUP BY  hp.party_name,
            hca.ACCOUNT_NAME,
            hca.ACCOUNT_NUMBER,
            rct.bill_to_site_use_id,
            hcsua.location,
            hcsua.site_use_code;
            
select  b.TRX_NUMBER orig_trx_number, 
          b.customer_trx_id orig_trx_id, 
          b.attribute3 orig_cs_no, a.trx_number cm_trx_number, a.customer_trx_id cm_trx_id, a.attribute3 cm_cs_no
from ra_customer_trx_all a,
ra_customer_trx_all b
where a.previous_customer_trx_id = b.customer_trx_id;
and a.trx_number like '403%';

select *
from ap_invoices_all
where doc_sequence_value  = '20002099';


select *
from hz_cust_site_uses_all
where site_use_id = 9963;


select *
from IFSAPP.CUSTOMER_ORDER_INV_HEAD;

select *
from ra_customer_trx_all
grou;

select * 
from ap_invoices_all
-- where 
where doc_sequence_value in ('20000673',
'20000833',
'20002099',
'20004131',
'20010284',
'20021302',
'20022876',
'20023617',
'20024021',
'20025432');

select *
from ap_invoices_all
where doc_sequence_value = '20000005';

select MAX(doc_sequence_value)
    --     doc_category_code
from ap_invoices_all
where doc_category_code = 'AP_BEG';

        
        
        