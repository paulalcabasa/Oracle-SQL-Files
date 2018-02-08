CREATE TABLE IPC.IPC_FSD_SYSTEM_ACCESS (
        access_id NUMBER(10) NOT NULL,
        user_id NUMBER(10) NOT NULL,
        system_id NUMBER(10) NOT NULL,
        user_type_id NUMBER(10) NOT NULL,
        default_system_id NUMBER(10),
        start_date_active date,
        end_date_active date,
        created_by number(10) NOT NULL,
        date_created DATE,
        updated_by number(10),
        date_updated date,
        CONSTRAINT fsd_system_acess_pk PRIMARY KEY (access_id)
);

CREATE SEQUENCE IPC.IPC_FSD_S_ACCESS_SEQ
MINVALUE 1
-- MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
CACHE 20;

select *
from ipc.ipc_fsd_systems;

select fsa.access_id,
           fsa.system_id,
           fs.system_name,
           fsa.user_type_id,
           fut.name user_type_name,
           fut.user_level,
           fsa.user_id,
           fu.user_name
from IPC.IPC_FSD_SYSTEM_ACCESS fsa 
        INNER JOIN IPC.IPC_FSD_SYSTEMS fs
            ON fsa.system_id = fs.system_id
         INNER JOIN IPC.IPC_FSD_USER_TYPES fut
            ON fut.user_type_id = fsa.user_type_id
         INNER JOIN APPS.FND_USER FU
            ON fu.user_id = fsa.user_id
where 1 = 1
           and fsa.end_date_active IS NULL
          and fu.user_name = '160801'
;

select *
from fnd_user
where description like '%SALAGUBANG%';
select *
from hr_all_organization_units;

SELECT *
FROM fnd_user
where user_name IN ('962254');

select *
from ipc.ipc_fsd_user_types;



select *
from ipc.ipc_fsd_systems;

select *
from ipc.IPC_FSD_USER_TYPES;

INSERT INTO IPC.IPC_FSD_USER_TYPES (
    
);

select 
            usr.user_id,
            usr.user_name,
            IPC_DECRYPT_ORA_USR_PWD(usr.encrypted_user_password) password
from fnd_user  usr
    where usr.user_name IN ('160801');

select *
from IPC.IPC_FSD_SYSTEMS;

SELECT *
FROM IPC.IPC_FSD_USER_TYPES;


select *
from ipc.ipc_fsd_system_access
where user_id = 1294;

sekec

INSERT INTO IPC.IPC_FSD_SYSTEM_ACCESS (
    access_id,
    user_id,
    system_id,
    user_type_id,
    default_system_id,
    start_date_active,
    end_date_active,
    created_by,
    date_created,
    updated_by,
    date_updated
) VALUES(
    IPC.IPC_FSD_S_ACCESS_SEQ.NEXTVAL,
    1274, -- USER ID WHO WILL BE GIVEN ACCESS (FND_USER.USER_ID)
    8, -- INVENTORY ID
    1, -- USER_TYPE_ID - ADMINISTRATION
    NULL, --DEFAULT SYSTEM
    SYSDATE, --START DATE
    NULL, -- END DATE
    1274, -- CREATED BY
    SYSDATE, -- DATE CREATED
    NULL,
    NULL
);

select *
from ipc.ipc_fsd_systems;

update ipc.ipc_fsd_systems
set link = 'ecommerce5/ora_inventory/'
where system_id = 25;
select *
from fnd_user
where user_name = '150603';

SELECT *
FROM IPC.IPC_PPR_HEADERS pph ;

select *
from ipc.IPC_PPR_APPROVAL;

select *
from ipc.IPC_PPR_EMAIL_NOTIF;

SELECT *
FROM (select ppa.approval_id,
           ppa.approval_sequence_no,
           ppa.approver_id,
           ppa.status_id,
           ppa.ppr_header_id
FROM IPC.IPC_PPR_APPROVAL ppa
WHERE ppr_header_id = 3
             AND status_id = 21
ORDER BY ppa.approval_sequence_no DESC)
WHERE rownum = 1
;

select *
from ipc.ipc_ppr_headers;

update ipc.ipc_ppr_headers
set status_id = 1
where ppr_header_id = 3;
update ipc.ipc_ppr_approval
set status_id = 21
where approval_id= 2;

select *
from ra_customer_trx_all
where trx_number = '51100000006';

UPDATE IPC.IPC_PPR_APPROVAL
                SET status_id = 1,
                    approved_by = 1,
                    date_approved = SYSDATE
                WHERE ppr_header_id =1,
                      approver_id = 1;
                      
                      INSERT INTO IPC.IPC_PPR_EMAIL_NOTIF (
                    notif_id,
                    from_email,
                    to_email,
                    subject,
                    mail_type,
                    date_created,
                    is_message_sent,
                    mail_template_filename,
                    ppr_header_id,
                    message1,
                    message2,
                    message3,
                    message4,
                    message5,
                    cc_email,
                    bcc_email
                )
                VALUES (
                    IPC.PPR_NOTIFS_SEQ.NEXTVAL,
                    'notification1@isuzuphil.com', -- from email
                    'paul-alcabasa@isuzuphil.com', -- to email
                    'Payment Process Request Approval', -- subject
                    'mail_to_requestor', -- mail type
                    SYSDATE,
                    'N', -- is message sent
                    'mail_templates/ppr_request_approval_view', -- mail template filename
                    
                    'Your payment process request has been approved by SERVAÑEZ, MARY GRACE BUSTOS', -- ppr header id
                    NULL, -- msg1
                    NULL, -- msg2
                    NULL, -- msg3
                    NULL, --msg4
                    NULL, -- msg5
                    'grace-servanez@isuzuphil.com', -- cc email
                    'paul-alcabasa@isuzuphil.com' -- bcc email
                );