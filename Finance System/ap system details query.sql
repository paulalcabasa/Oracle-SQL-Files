SELECT ph.ppr_header_id,
             ph.ppr_doc_sequence_value,
             ph.status_id,
             ps.status_name,
             count(pl.ppr_line_id) total_invoices,
             sum(aia.invoice_amount) total_invoice_amount,
             sum(aia.invoice_amount - aia.amount_paid) total_balance_amount,
             ph.ap_check_voucher_no,
             ppf.full_name created_by,
             to_char(ph.date_created,'mm/dd/yyyy') date_created
FROM ipc.ipc_ppr_headers ph 
            INNER JOIN ipc.ipc_ppr_states ps
                ON ph.status_id = ps.status_id
            INNER JOIN apps.fnd_user usr
                ON usr.user_id = ph.created_by
            INNER JOIN per_all_people_f ppf
                ON ppf.person_id = usr.employee_id
            INNER JOIN ipc.ipc_ppr_lines pl
                ON pl.ppr_header_id = ph.ppr_header_id
            INNER JOIN apps.ap_invoices_all aia
                ON aia.invoice_id = pl.ap_invoice_id
WHERE 1 = 1
              AND pl.status_id = 5 -- where line is selected
              AND ph.date_created BETWEEN ? AND ?
 GROUP BY
                ph.ppr_header_id,
                ph.ppr_doc_sequence_value,
                ph.status_id,
                ps.status_name,
                ph.ap_check_voucher_no,
                ppf.full_name,
                ph.date_created;
                
