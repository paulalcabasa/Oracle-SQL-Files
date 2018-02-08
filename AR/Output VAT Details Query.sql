/* Formatted on 21/9/2017 5:11:16 PM (QP5 v5.163.1008.3004) */
  SELECT 
                rcta.interface_header_attribute1 sales_order_no,
                rct_dist.gl_date,
                rcta.trx_number,
                cust.customer_number,
                cust.customer_name,
                gcc.segment6,
                rctla.tax_classification_code,
                zxl.line_amt,
                zxl.tax_amt,
                org.name organization
----         --
--         CONCAT (
--            REGEXP_REPLACE (
--               TO_CHAR (TO_DATE (:P_START, 'YYYY/MM/DD hh24:mi:ss'), 'Month'),
--               '[[:space:]]',
--               ''),
--            TO_CHAR (TO_DATE (:P_START, 'YYYY/MM/DD hh24:mi:ss'), ' DD, YYYY'))
--            DATE_FROM,
--         CONCAT (
--            REGEXP_REPLACE (
--               TO_CHAR (TO_DATE (:P_END, 'YYYY/MM/DD hh24:mi:ss'), 'Month'),
--               '[[:space:]]',
--               ''),
--            TO_CHAR (TO_DATE (:P_END, 'YYYY/MM/DD hh24:mi:ss'), ' DD, YYYY'))
--            DATE_TO
--    --
    FROM ra_customer_trx_lines_all rctla
         INNER JOIN ra_cust_trx_line_gl_dist_all rct_dist
            on rctla.customer_trx_line_id = rct_dist.customer_trx_line_id
         INNER JOIN ra_customer_trx_all rcta
            ON rct_dist.customer_trx_id = rcta.customer_trx_id
         INNER JOIN ar_customers cust
            ON rcta.bill_to_customer_id = cust.customer_id
         INNER JOIN GL_code_combinations gcc
            ON rct_dist.code_combination_id = gcc.code_combination_id
         INNER JOIN zx_lines zxl
            ON rct_dist.customer_trx_line_id = zxl.trx_line_id
               AND zxl.trx_id = rcta.customer_trx_id
               AND zxl.trx_level_type = 'LINE'
         INNER JOIN hr_all_organization_units org
            ON rctla.warehouse_id = org.organization_id
   WHERE gcc.segment6 NOT IN ('02000','02004','85500')
         AND TO_DATE(rct_dist.gl_date) between  TO_DATE (:p_start_date, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:p_end_date, 'yyyy/mm/dd hh24:mi:ss')
         AND cust.customer_id = NVL (:p_cust_account_no, cust.customer_id)
         AND rcta.interface_header_attribute1 IS NOT NULL
--  HAVING SUM (B.AMOUNT) >= 1 AND F.LINE_AMT >= 1 AND F.LINE_AMT >= 1
          and rcta.trx_number = '40200012288'
ORDER BY rctla.warehouse_id ASC,
                  rcta.trx_number                 
;
SELECT *
FROM ar_customers;
SELECT *
FROM GL_JE_LINES 
WHERE DESCRIPTION LIKE '%40200012288%';

select *
from zx_lines;
GROUP BY C.INTERFACE_HEADER_ATTRIBUTE1,
         A.SALES_ORDER,
         B.GL_DATE,
         A.C.TRX_NUMBER,
         D.CUSTOMER_NUMBER,
         D.CUSTOMER_NAME,
         A.TAX_CLASSIFICATION_CODE,
         E.SEGMENT6,
         G.NAME,
         A.TAX_CLASSIFICATION_CODE,
         F.LINE_AMT,
         F.TAX_AMT