DROP TABLE IPC.IPC_FSD_USERS;
/* Query for the table created of custom users for the system */
CREATE TABLE IPC.IPC_FSD_USERS (
        user_id number(10) NOT NULL,
        user_name varchar2(30) NOT NULL,
        user_password  varchar2(150) NOT NULL,
        first_name varchar2(100) NOT NULL,
        middle_name varchar2(100),
        last_name varchar2(100) NOT NULL,
        start_date_active date,
        end_date_active date,
        created_by number(10) NOT NULL,
        date_created date,
        updated_by number(10),
        date_updated date,
        CONSTRAINT fsd_users_pk PRIMARY KEY (user_id)
);

select *
from apps.fnd_user
where user_name = '150603';

DROP SEQUENCE IPC.IPC_FSD_USERS_SEQ;
/* Sequence for users*/
CREATE SEQUENCE IPC.IPC_FSD_USERS_SEQ
MINVALUE 1
-- MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
CACHE 20;


 -- 1274
SELECT *
FROM IPC.IPC_FSD_USERS;

INSERT INTO IPC.IPC_FSD_USERS (
    user_id,
    user_name,
    user_password,
    first_name,
    middle_name,
    last_name,
    start_date_active,
    end_date_active,
    created_by,
    date_created,
    updated_by,
    date_updated
)
VALUES (
    IPC.IPC_FSD_USERS_SEQ.NEXTVAL, -- user_id
    'nyk', -- user_name
    'nyk', -- password
    'Ana', -- first name
    NULL, -- middle name
    'Tagapulot', -- last name
    SYSDATE, -- start_date_active
    NULL, -- end date active
    1274, -- created by
    SYSDATE, -- date created
    NULL, -- updated by
    NULL -- date updated
);

select *
from fnd_user;