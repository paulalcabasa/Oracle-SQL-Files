SELECT *
FROM IPC.IPC_PPR_OR_DETAILS;
drop TABLE IPC.IPC_PPR_OR_DETAILS;
CREATE  TABLE IPC.IPC_PPR_OR_DETAILS (
official_receipt_id number(10) NOT NULL,
or_number varchar2(100),
or_date date,
ap_check_id number(10),
ap_check_voucher_no varchar2(50),
ap_check_number varchar2(50),
remarks varchar2(200),
created_by number(10) NOT NULL,
date_created date NOT NULL,
updated_by number(10),
date_updated date,
CONSTRAINT ppr_or_details PRIMARY KEY (official_receipt_id)
);

DROP SEQUENCE IPC.PPR_OR_DETAILS_SEQ;
/* Sequence for system*/
CREATE SEQUENCE IPC.PPR_OR_DETAILS_SEQ
MINVALUE 1
-- MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
nocache;

/* Sequence for system*/
CREATE SEQUENCE IPC.PPR_OR_DETAILS_SEQ
MINVALUE 1
MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
CACHE 20;

select *
from ap_checks_all
where check_id = 993648;

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