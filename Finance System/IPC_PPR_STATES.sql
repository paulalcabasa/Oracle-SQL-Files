SELECT *
FROM IPC.IPC_PPR_STATES;

CREATE  TABLE IPC.IPC_PPR_STATES (
    status_id number(10) NOT NULL,
    status_name varchar2(50) NOT NULL,
    description varchar2(100) NOT NULL,
    created_by number(10) NOT NULL,
    date_created date NOT NULL,
    updated_by number(10),
    date_updated date,
    active varchar2(1) NOT NULL,
    CONSTRAINT ppr_states_pk PRIMARY KEY (status_id)
    
 );

/* Sequence for system*/
CREATE SEQUENCE IPC.PPR_STATES_SEQ
MINVALUE 1
-- MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
CACHE 20;

INSERT INTO IPC.IPC_PPR_STATES (
    status_id,
    status_name,
    description,
    created_by,
    date_created,
    active
)
VALUES (
    IPC.PPR_STATES_SEQ.NEXTVAL,
    'Not yet approved',
    'Payment process request is not yet approved',
    1274,
    SYSDATE,
    'Y'
);

INSERT INTO IPC.IPC_PPR_STATES (
    status_id,
    status_name,
    description,
    created_by,
    date_created,
    active
)
VALUES (
    IPC.PPR_STATES_SEQ.NEXTVAL,
    'Paid',
    'Payment process request was tagged with a check voucher no',
    1274,
    SYSDATE,
    'Y'
);

INSERT INTO IPC.IPC_PPR_STATES (
    status_id,
    status_name,
    description,
    created_by,
    date_created,
    active
)
VALUES (
    IPC.PPR_STATES_SEQ.NEXTVAL,
    'Cancelled',
    'Payment process request was cancelled by the user.',
    1274,
    SYSDATE,
    'Y'
);

INSERT INTO IPC.IPC_PPR_STATES (
    status_id,
    status_name,
    description,
    created_by,
    date_created,
    active
)
VALUES (
    IPC.PPR_STATES_SEQ.NEXTVAL,
    'Submitted',
    'Payment process request was submitted to AR',
    1274,
    SYSDATE,
    'Y'
);

INSERT INTO IPC.IPC_PPR_STATES (
    status_id,
    status_name,
    description,
    created_by,
    date_created,
    active
)
VALUES (
    IPC.PPR_STATES_SEQ.NEXTVAL,
    'Selected',
    'An Invoice is selected for payment in payment process request',
    1274,
    SYSDATE,
    'Y'
);

INSERT INTO IPC.IPC_PPR_STATES (
    status_id,
    status_name,
    description,
    created_by,
    date_created,
    active
)
VALUES (
    IPC.PPR_STATES_SEQ.NEXTVAL,
    'Removed',
    'An Invoice was removed in payment process request',
    1274,
    SYSDATE,
    'Y'
);