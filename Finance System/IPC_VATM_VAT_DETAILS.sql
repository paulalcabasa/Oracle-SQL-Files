

select * from IPC.IPC_VATM_VAT_DETAILS;
CREATE  TABLE IPC.IPC_VATM_VAT_DETAILS (
    vat_detail_id number(10) NOT NULL,
    ap_voucher_num number(10) NOT NULL,
    ap_invoice_line_num number(10) NOT NULL,
    ap_distribution_line_num number(10) NOT NULL,
    application_period varchar(50) NOT NULL,
    created_by number(10),
    date_created date NOT NULL,
    updated_by number(10),
    date_updated date,
    status char(10),
    CONSTRAINT vatm_vat_detail_id PRIMARY KEY (vat_detail_id)
);

select *
from IPC.IPC_VATM_VAT_DETAILS;

drop sequence  IPC.VATM_VAT_DETAILS_SEQ;
/* Sequence for system*/
CREATE SEQUENCE IPC.VATM_VAT_DETAILS_SEQ
MINVALUE 1
-- MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
noCACHE;