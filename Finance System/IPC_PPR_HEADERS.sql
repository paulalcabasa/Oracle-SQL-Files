SELECT *
FROM IPC.IPC_PPR_HEADERS;

CREATE  TABLE IPC.IPC_PPR_HEADERS (
        ppr_header_id number(10) NOT NULL,
        ppr_doc_sequence_value number(20) NOT NULL,
        status_id number(10) NOT NULL,
        ap_check_voucher_no varchar2(100),
        created_by number(10) NOT NULL,
        date_created date NOT NULL,
        updated_by number(10),
        date_updated date,
        CONSTRAINT ppr_headers_pk PRIMARY KEY (ppr_header_id)
);

SELECT *
FROM  IPC.IPC_PPR_HEADERS;

select IPC.PPR_HEADERS_SEQ.CURRVAL
from DUAL;

/* Sequence for system*/
CREATE SEQUENCE IPC.PPR_HEADERS_SEQ
MINVALUE 1
-- MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
CACHE VALUE;

/* Sequence for system*/
CREATE SEQUENCE IPC.PPR_HEADERS_DOC_SEQ
MINVALUE 1
MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
CACHE 20;

select receipt_number
from ar_cash_receipts_all
where doc_sequence_value like '701%7776';

CREATE SEQUENCE IPC.TEST_SEQ;

SELECT  IPC.TEST_SEQ.NEXTVAL
FROM DUAL;

select *
from IPC.IPC_FSD_SYSTEM_ACCESS;

SELECT *
FROM IPC.IPC_USER_TYPES;

SELECT *
FROM IPC.IPC_FSD_USER_TYPES;



IPC.IPC_FSD_UTYPES_SEQ