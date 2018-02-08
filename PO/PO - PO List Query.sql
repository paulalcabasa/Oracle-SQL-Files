select pha.segment1 po_num,
            pv.segment1 supplier_id,
            pv.vendor_name supplier_name,
            sum(pla.quantity*pla.unit_price) order_value,
            pha.currency_code currency,
            TO_CHAR(pha.creation_date,'DD/MM/YYYY') order_date,
            pha.authorization_status status,
            TO_CHAR(pha.creation_date,'DD/MM/YYYY') creation_date,
            fu.description created_by
from po_headers_all pha
        INNER JOIN po_vendors pv
            ON pv.vendor_id = pha.vendor_id
        LEFT JOIN po_lines_all pla
            ON pha.po_header_id = pla.po_header_id
        INNER JOIN fnd_user fu
            ON fu.user_id = pha.created_by 
where 1 = 1
           and TO_DATE(pha.creation_date) between  TO_DATE (:P_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
group by
            pha.segment1 ,
            pv.segment1 ,
            pv.vendor_name,
            pha.currency_code ,
            pha.authorization_status,
            pha.creation_date,
            fu.description
            ;
select segment1
from mtl_system_items_b
where organization_id = 121;