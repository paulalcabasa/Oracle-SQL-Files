

CREATE  TABLE IPC.IPC_PPR_LINES (
    ppr_line_id number(10) NOT NULL,
    ppr_header_id number(10) NOT NULL,
    ap_invoice_id number(20) NOT NULL,
    ap_invoice_num varchar2(150) NOT NULL,
    ap_document_sequence_value varchar2(150) NOT NULL,
    org_id number(10),
    status_id number(10),
    created_by number(10) NOT NULL,
    date_created date NOT NULL,
    updated_by number(10),
    date_updated date,
    CONSTRAINT ppr_lines_pk PRIMARY KEY (ppr_line_id),
    CONSTRAINT fk_ppr_headers 
    FOREIGN KEY (ppr_header_id)
    REFERENCES IPC.IPC_PPR_HEADERS(ppr_header_id)
 );

SELECT *
FROM  IPC.IPC_PPR_HEADERS;

    select IPC.PPR_LINES_SEQ.currval
from dual;

select *
from ipc.IPC_PPR_HEADERS;

/* Sequence for system*/
CREATE SEQUENCE IPC.PPR_LINES_SEQ
MINVALUE 1
-- MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
CACHE 20;

/* Sequence for system*/
CREATE SEQUENCE IPC.PPR_HEADERS_DOC_SEQ
MINVALUE 1
MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
CACHE 20;