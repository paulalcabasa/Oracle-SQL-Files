/* ORACLE LOGIN QUERY */
SELECT usr.user_id,
            usr.user_name,
            ppf.first_name,
            ppf.middle_names middle_name,
            ppf.last_name,
            ppf.full_name,
            ppf.attribute2 division,
            ppf.attribute3 department,
            ppf.attribute4 section
                FROM fnd_user usr LEFT JOIN per_all_people_f ppf
                       ON usr.employee_id = ppf.person_id
                 WHERE usr.user_name = :p_user_name
                       AND usr.end_date IS NULL
                       AND IPC_DECRYPT_ORA_USR_PWD(usr.encrypted_user_password) = :p_user_password;

/* CUSTOM TABLE LOGIN QUERY */
SELECT usr.user_id,
             usr.user_name,
             usr.first_name,
             usr.middle_name,
             usr.last_name,
             null full_name,
             null division,
             null department,
             null section
FROM IPC.IPC_FSD_USERS usr
WHERE usr.end_date_active = NULL
             and usr.user_name = :p_user_name
             and usr.user_password = :p_user_password;
             
 /* Combination Oracle and Custom Table Login Query*/
 SELECT *
 FROM (SELECT usr.user_id,
            usr.user_name,
            ppf.first_name,
            ppf.middle_names middle_name,
            ppf.last_name,
            ppf.full_name,
            ppf.attribute2 division,
            ppf.attribute3 department,
            ppf.attribute4 section
                FROM fnd_user usr LEFT JOIN per_all_people_f ppf
                       ON usr.employee_id = ppf.person_id
                 WHERE usr.user_name = :p_user_name
                       AND usr.end_date IS NULL
                       AND IPC_DECRYPT_ORA_USR_PWD(usr.encrypted_user_password) = :p_user_password
            UNION ALL
            SELECT usr.user_id,
                         usr.user_name,
                         usr.first_name,
                         usr.middle_name,
                         usr.last_name,
                         null full_name,
                         null division,
                         null department,
                         null section
            FROM IPC.IPC_FSD_USERS usr
            WHERE usr.end_date_active is NULL
                         and usr.user_name = :p_user_name
                         and usr.user_password = :p_user_password
 );
 
 SELECT *
 FROM  IPC.IPC_FSD_USERS 
 WHERE USER_NAME = 'nyk';
 
 select *
 from ap_invoices_all
 where invoice_id = 1224461;
 
 select *
 from ap_invoice_lines_all
 where po_header_id = 1225427;
 
 select *
 from ap_invoices_all
 where invoice_num = '145560';
 
 select *
 from po_headers_all
 where segment1 = '20100004153';