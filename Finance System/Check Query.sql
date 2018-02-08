SELECT aps.segment1 supplier_id,
                            aca.vendor_name supplier_name,
                            cpb.payment_document_name,
                            aca.check_number,
                            aca.doc_sequence_value check_voucher_no,
                            aca.amount check_amount,
                            TO_CHAR(aca.check_date,'MM/DD/YYYY') check_date,
                            aca.status_lookup_code status,
                            cbb.bank_name,
                            TO_CHAR(aca.treasury_pay_date,'MM/DD/YYYY') release_date,
                            ipc_or.or_number or_no,
                            TO_CHAR(ipc_or.or_date,'MM/DD/YYYY') or_date,
                            TO_CHAR(ipc_or.date_created,'MM/DD/YYYY') entry_date,
                             aca.check_id,
                            ipc_or.remarks remarks,
                            ipc_or.official_receipt_id
                FROM ap_checks_all aca 
                       LEFT JOIN ap_suppliers aps
                            ON aps.vendor_id = aca.vendor_id
                       LEFT JOIN ipc.ipc_ppr_or_details ipc_or
                            ON ipc_or.ap_check_voucher_no = aca.doc_sequence_value
                            AND ipc_or.ap_check_number = aca.check_number
                       INNER JOIN ce_payment_documents cpb
                            ON cpb.payment_document_id = aca.payment_document_id
                        INNER JOIN ce_bank_acct_uses_all cbaua
                            ON aca.ce_bank_acct_use_id = cbaua.bank_acct_use_id
                       INNER JOIN ce_bank_accounts cba
                            ON cba.bank_account_id = cbaua.bank_account_id
                       INNER JOIN ce_bank_branches_v cbb
                            ON cbb.bank_party_id = cba.bank_id
                       INNER JOIN fnd_user fu
                            ON fu.user_id = aca.created_by
                WHERE 1 = 1 
                        and aca.doc_sequence_value = '30003422'
                --TO_DATE(aca.check_date) BETWEEN ? AND ?
                   --   $release_status_cond
                  --    $check_number_cond
                ORDER BY aca.check_number ASC;

select a.rowid,a.*
from ipc.ipc_ppr_or_details a
where a.ap_check_voucher_no IN (
-- find duplicates    
select a.ap_check_voucher_no
--           to_char(aca.check_date) check_date,
--            count(ap_check_voucher_no) count,
--            aca.check_number,
--            to_char(max(a.date_created)) last_date_create
from ipc.ipc_ppr_or_details a left join ap_checks_all aca
        on a.ap_check_id = aca.check_id
where a.ap_check_voucher_no <> -1
group by a.ap_check_voucher_no,
               aca.check_date, 
               aca.check_number
having count(ap_check_voucher_no) > 1
--order by
--              count(ap_check_voucher_no) DESC
)

ORDER BY AP_CHECK_VOUCHER_NO;

select *
from ipc.ipc_ppr_or_details;

select *             
from ipc.ipc_ppr_or_details a
where a.ap_check_voucher_no = '30003422';
                
                -- 1537
                
                select *
                from  ipc.ipc_ppr_or_details;
             