select distinct po.vendor_no,
         sup.name,
         sup_address.address
from PURCHASE_ORDER po,
        IFSAPP.SUPPLIER_INFO sup,
        IFSAPP.SUPPLIER_INFO_ADDRESS sup_address
where po.contract = 'PTS'
          AND sup.supplier_id = po.vendor_no
          AND sup_address.supplier_id = sup.supplier_id;

select *
from IFSAPP.SUPPLIER_INFO;

select *
from IFSAPP.SUPPLIER_INFO_ADDRESS;
/* NIP
POS
PRS
PTS
VSS
*/