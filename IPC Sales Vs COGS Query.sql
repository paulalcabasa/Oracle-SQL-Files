SELECT transaction_id,organization_id
FROM mtl_material_transactions mmt
WHERE 1 = 1
          --  and TRUNC(mmt.transaction_date) between '30-JUN-2017' AND '30-JUN-2017'
             AND mmt.transaction_date =  TO_DATE ('2017/06/30 00:00', 'yyyy/mm/dd hh24:mi') --and TO_DATE ('2017/06/30 12:30', 'yyyy/mm/dd hh24:mi')
      --      and mmt.transaction_date = TO_DATE('2017/06/30 12:30:00','yyyy/mm/dd hh:ii:ss')
order by mmt.transaction_date;

select *
from hr_organization_units;

SELECT distinct mmt.transaction_date transaction_Date
FROM mtl_material_transactions mmt
WHERE 1 = 1
        and TRUNC(mmt.transaction_date) between '30-JUN-2017' AND '30-JUN-2017'
     --        AND mmt.transaction_date between  TO_DATE ('2017/06/30 12:30:00', 'yyyy/mm/dd hh24:mi:ss') and TO_DATE ('2017/06/30 12:30:59', 'yyyy/mm/dd hh24:mi:ss')
      --      and mmt.transaction_date = TO_DATE('2017/06/30 12:30:00','yyyy/mm/dd hh:ii:ss')
order by transaction_date;



select mmt.transaction_id,
         ce.event_type,
         mty.transaction_type_name,
         mty.description
from cst_revenue_cogs_match_lines cml,
        cst_cogs_events ce,
        mtl_material_transactions mmt,
        mtl_transaction_types mty,
        cst_inv_distribution_v cid
where 1 = 1
          -- COGS
          and ce.cogs_om_line_id = cml.cogs_om_line_id
          and ce.mmt_transaction_id =mmt.transaction_id
          -- MATERIAL TRANSACTIONS
          and mmt.transaction_type_id = mty.transaction_type_id
          and cid.transaction_id = mmt.transaction_id
          
          
          -- FILTERS
          and cml.cogs_om_line_id = 2384492;
          

select *
from cst_inv_distribution_v
where transaction_id = 3841401;