
drop table IPC.IPC_USER_TYPES;
CREATE TABLE IPC.IPC_FSD_USER_TYPES (
        user_type_id number(10) NOT NULL,
        name varchar2(50) NOT NULL, 
        description varchar2(100),
        user_level number(10) NOT NULL,
        CONSTRAINT fsd_user_types_pk PRIMARY KEY (user_type_id)
);

drop sequence IPC.IPC_FSD_UTYPES_SEQ;
/* Sequence for system*/
CREATE SEQUENCE IPC.IPC_FSD_UTYPES_SEQ
MINVALUE 1
-- MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
CACHE 20;

select *
from IPC.IPC_FSD_USER_TYPES;

INSERT INTO IPC.IPC_FSD_USER_TYPES(
    user_type_id,
    name,
    description,
    user_level
)
VALUES (
    IPC.IPC_FSD_UTYPES_SEQ.NEXTVAL,
    'ReadOnly',
    'ReadOnly',
    4
);