/*** AR INVOICE QUERY ***/
select    --distinct rcta.trx_number,
        --    rcta.trx_date invoice_date,
      distinct 
        --    gjh.je_header_id,
        gjh.doc_sequence_value GL_VOUCHER_NUM,
        rcta.trx_number invoice_number,
        rcta.attribute3 cs_no,
      --  rcta.attribute4 lot_no,
        rcta.comments ifs_invoice_no,
        msib.segment1 part_no,
        msib.description,
        mck.segment1 as item_category_family,
        mck.segment2 as item_category_class,
       msib.item_type,
       flv.meaning  item_type_description,
  --      rctal.description,
        rcta.trx_date invoice_date,

        xah.accounting_date            AS "Accounting Date",
        xah.gl_transfer_status_code    AS "GL Transfer Status Code",
        xah.gl_transfer_date           AS "GL Transfer Date",
        gjl.je_line_num GL_LINE_NUM,
        --       xal.ae_line_num,
        gcc.segment6                   AS "Account",
        xal.entered_dr                 AS "XLA Entered Debit",
        xal.entered_cr                 AS "XLA Entered Credit",
        gjl.entered_dr "GL Entered Debit",
        gjl.entered_cr "GL Entered Credit",
        --       xdl.application_id             AS "Application ID",
        xdl.source_distribution_type   AS "Source Distribution Type",
        --        xdl.source_distribution_id_num_1 AS "Source Distribution Id Num",
        --         xdl.ae_header_id               AS "AE Header ID",
        --       xdl.ae_line_num                AS "AE Line Num",
            xal.accounting_class_code      AS "Accounting Class Code",
            xdl.accounting_line_code       AS "Accounting Line Code",
            xdl.line_definition_code       AS "Line Definition Code",
            xdl.event_class_code           AS "Event Class Code",
            xdl.event_type_code            AS "Event Type Code",
            xdl.rounding_class_code        AS "Rounding Class Code",
            xah.je_category_name           AS "JE Category Name",
            xah.accounting_entry_type_code AS "Accounting Entry Type Code",
            xah.doc_sequence_value         AS "Document Sequence Value",
            
            xah.description                AS "Description",
            xal.description                AS "Line Description",
            xal.displayed_line_number      AS "Line Number",
            xah.period_name                AS "Period Name"
      --      rct_gl.amount,
from -- SLA TABLES
        xla_ae_headers xah,
        xla_ae_lines xal,
        xla_distribution_links xdl,
        -- LINK TO SLA TABLE
        ra_cust_trx_line_gl_dist_all rct_gl,
        gl_code_combinations gcc,
        -- AR TABLE
        ra_customer_trx_lines_all rctal,
        ra_customer_trx_all rcta,
        -- GL TABLES
        GL_IMPORT_REFERENCES gir,
        gl_je_headers gjh,
        gl_je_lines gjl,
        -- ITEM
        mtl_system_items_b msib,
        mtl_item_categories  mtc,
        mtl_categories_kfv mck,
        fnd_lookup_values flv
where 1 = 1
        -- SLA 
        and xah.ae_header_id = xdl.ae_header_id
        and xah.ae_header_id = xal.ae_header_id
        and xah.application_id = xal.application_id
        and xdl.source_distribution_id_num_1 = rct_gl.cust_trx_line_gl_dist_id
        and xdl.source_distribution_type = 'RA_CUST_TRX_LINE_GL_DIST_ALL'
        and xal.code_combination_id = gcc.code_combination_id
         -- GL 
        and xal.gl_sl_link_id = gir.gl_sl_link_id(+)
        and xal.gl_sl_link_table = gir.gl_sl_link_table(+)
        and gir.je_header_id = gjh.je_header_id
        and gir.je_line_num = gjl.je_line_num
        and gjh.je_header_id = gjl.je_header_id
        and xdl.ae_line_num = gjl.je_line_num
  --    and gjl.reference_8 =  xal.ae_line_num  
        -- INVOICE
        and rcta.customer_trx_id = rct_gl.customer_trx_id
        and rcta.customer_trx_id = rctal.customer_trx_id
       -- ITEM
       and rctal.inventory_item_id = msib.inventory_item_id
       and to_number(rcta.interface_header_attribute10) =  msib.organization_id
        and msib.inventory_item_id = mtc.inventory_item_id 
        and msib.organization_id = mtc.organization_id 
        and mtc.category_id =mck.category_id  
        and  msib.item_type = flv.lookup_code  
        and  flv.lookup_type = 'ITEM_TYPE'
        and  mck.structure_id = '50388'
        
        --FILTERS
    --  and rcta.trx_number = '40300000371'
        and xal.accounting_date between '01-JAN-2017' AND '31-MAY-2017'
   --    and gcc.segment6 between '01200' and '01300'
        and gcc.segment6 IN( '01200' ,'01300')
   --     and rcta.trx_number like '402%';
      --  and gcc.segment6  = '85500' -- and '02099'
--order by gjl.je_line_num;
;
select * 
from mtl_item_categories;



select *
from ra_customer_trx_all
where trx_number = '40300000371';

select *
from ra_customer_trx_lines_all
where customer_trx_id = 36503;

      --  and xah.accounting_date BETWEEN '01-JAN-2017' AND '15-JAN-2017';
      
      -- 40200011762
      -- 40200010128

select *
from xla_ae_headers
where ae_header_id = 12799828;

select *
from xla_ae_lines
where ae_header_id = 12799828;

select *
from gl_je_lines
where je_header_id = 931033;

select *
from GL_IMPORT_REFERENCES
where je_header_id = 931033;

select *
from ra_cust_trx_line_gl_dist_all
where cust_trx_line_gl_dist_id IN (880797,
880889,
880888,
880887,
899990,
899989,
899988);

select *
from ra_customer_trx_all
where trx_number like '403%';

select *
from xla_distribution_links
where Source_distribution_id_num_1 IN  (880797,
880889,
880888,
880887,
899990,
899989,
899988)
AND SOURCE_DISTRIBUTION_TYPE = 'RA_CUST_TRX_LINE_GL_DIST_ALL';


SELECT gcc.concatenated_segments Code_combination,
            SUM(NVL(gb.begin_balance_dr,0)-NVL(gb.begin_balance_cr,0)) beginning_bal,
            SUM(NVL(gb.begin_balance_dr,0)-NVL(gb.begin_balance_cr,0) + (NVL(gb.period_net_Dr,0) - NVL(gb.period_net_cr,0))) end_bal
FROM gl_balances gb,
  gl_code_combinations_kfv gcc
WHERE gb.code_combination_id = gcc.code_combination_id
AND gcc.SEGMENT6 = '01100' -- Enter GL Account
AND gb.ledger_id             = 2021 -- Enter the Ledger
AND gb.Actual_flag           = 'A'
-- AND gb.period_name           = 'FEB-17' --Enter the Period
-- AND gb.currency_code         = (SELECT currency_code FROM gl_ledgers WHERE ledger_id = gb.ledger_id)
GROUP BY gcc.concatenated_segments;

SELECT *
FROM gl_balances;