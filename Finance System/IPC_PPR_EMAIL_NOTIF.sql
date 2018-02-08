SELECT *
FROM IPC.IPC_PPR_EMAIL_NOTIF;


CREATE  TABLE IPC.IPC_PPR_EMAIL_NOTIF (
    notif_id number(10) NOT NULL,
    from_email varchar2(255) NOT NULL,
    to_email varchar2(255) NOT NULL,
    subject varchar2(200) NOT NULL,
    message_body VARCHAR2(4000) NOT NULL,
    date_created date NOT NULL,
    date_sent date,
    is_message_sent char(1) NOT NULL,
    CONSTRAINT ppr_notifs_pk PRIMARY KEY (notif_id)
 );

/* Sequence for system*/
CREATE SEQUENCE IPC.PPR_NOTIFS_SEQ
MINVALUE 1
-- MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
CACHE 20;
