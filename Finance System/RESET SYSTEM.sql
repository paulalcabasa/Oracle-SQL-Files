select *
from fnd_user
where employee_id= 749;

select *
from fnd_user;
where person_id = 749;

select *
from per_people_f
where person_id = 498;


SELECT ppf.person_id,
                         ppf.first_name || ' ' ||
                         CASE WHEN ppf.middle_names IS NOT NULL
                                   THEN substr(ppf.middle_names,1,1) || '. '
                                   ELSE ' '
                         END ||
                         ppf.last_name person_name,
                         ppf.effective_end_date,
                         fu.end_date,
                         fu.user_name,
                         IPC_DECRYPT_ORA_USR_PWD(fu.encrypted_user_password) user_pass
                FROM per_people_f ppf LEFT JOIN fnd_user fu
                            ON PPF.PERSON_ID = fu.employee_id
                WHERE 1= 1
              and fu.user_name = '151107'             
   --     and- ppf.attribute3 LIKE '%FINANCE%'
                 --        and ppf.effective_end_date = '31-DEC-4712'
                   --      and fu.end_date IS NULL
                ORDER BY ppf.last_name,
                              ppf.first_name;
                              
SELECT ph.ppr_header_id,
                           ph.ppr_doc_sequence_value,
                           ph.status_id,
                           ph.ap_check_voucher_no,
                           TO_CHAR(ph.date_created,'MONTH-D-YYYY') date_created,
                           ps.status_name,
                           ps.description,
                           ph.bank_account_num,
                           ppf.full_name created_by_name,
                           ph.created_by,
                           fu.email_address requestor_email,
                           ph.bank_name,
                           ph.bank_account_name,
                           ph.bank_account_num,
                           ph.ap_check_voucher_no,
                           ph.vendor_name,
                           ph.vendor_id,
                           TO_CHAR(ph.planned_pay_date,'MM/DD/YYYY') planned_pay_date,
                           ph.due_date
                FROM IPC.IPC_PPR_HEADERS ph LEFT JOIN IPC.IPC_PPR_STATES ps
                            ON PH.STATUS_ID = ps.status_id
                          LEFT JOIN fnd_user fu
                            ON fu.user_id = ph.created_by
                          LEFT JOIN per_all_people_f ppf
                            ON fu.employee_id = ppf.person_id
                WHERE 1 = 1
                           AND ph.ppr_header_id = 32;
                        
                           
                           
                           /* select *
                           from ipc.ipc_ppr_lines
                           where ppr_header_id = 345
                                        and ap_invoice_num = '35236';
                                        
                                            update ipc.ipc_ppr_lines
                                            set status_id = 6
                           where ppr_header_id = 345
                                        and ap_invoice_num = '35236';*/
                                        
select *
from fnd_user
where user_name = '140201';