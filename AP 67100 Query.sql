SELECT aia.invoice_num,
        gcc.segment6
FROM ap_invoice_lines_all aila,
     ap_invoices_all aia,
     gl_code_combinations gcc
WHERE 1 = 1
      AND aila.invoice_id = aia.invoice_id
      AND aila.DEFAULT_DIST_CCID = gcc.code_combination_id
      AND gcc.segment6 LIKE '67%'
      ;
      
      select *
      from ap_invoice_lines_all;
      
      select *
      from ap_invoices_all;
      
      SELECT *
      FROM gl_code_combinations
      where segment6 = '67100';