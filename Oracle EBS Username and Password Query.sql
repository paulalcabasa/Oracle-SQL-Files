/* Formatted on 8/8/2017 9:16:08 AM (QP5 v5.163.1008.3004) */
--Query to execute

SELECT usr.user_name,
       ppf.full_name,
       ppf.attribute2 division,
       ppf.attribute3 department,
       ppf.attribute4 section
  FROM    fnd_user usr
       LEFT JOIN
          per_all_people_f ppf
       ON usr.employee_id = ppf.person_id
 WHERE usr.user_name = '150603'
       AND usr.end_date IS NULL
       AND IPC_GET_PWD.decrypt (
              (SELECT (SELECT IPC_GET_PWD.decrypt (
                                 fnd_web_sec.get_guest_username_pwd,
                                 usertable.encrypted_foundation_password)
                         FROM DUAL)
                         AS apps_password
                 FROM fnd_user usertable
                WHERE usertable.user_name =
                         (SELECT SUBSTR (
                                    fnd_web_sec.get_guest_username_pwd,
                                    1,
                                    INSTR (
                                       fnd_web_sec.get_guest_username_pwd,
                                       '/')
                                    - 1)
                            FROM DUAL)),
              usr.encrypted_user_password) = 'kalabasa1';
              
CREATE TABLE IPC.IPC_FSD_USERS (
    user_id number(10) NOT NULL,
    user_name varchar2(50) NOT NULL,
    user_password varchar2(150) NOT NULL,
    first_name varchar2(50),
    middle_name varchar2(50),
    last_name varchar2(50),
    start_date_active date,
    end_date_active date,
    created_by varchar2(50),
    date_created date  ,
    updated_by varchar2(50),
    date_updated date,
    CONSTRAINT ipc_fsd_users_pk PRIMARY KEY (user_id)

);             

select *
from ipc.IPC_FSD_USERS;

select *
from fnd_user;