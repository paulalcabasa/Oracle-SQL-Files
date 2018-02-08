CREATE TABLE IPC.IPC_FSD_SYSTEMS (
        system_id number(10) NOT NULL,
        system_name varchar2(100) NOT NULL,
        description  varchar2(150) NOT NULL,
        link varchar2(100) NOT NULL,
        link_description varchar2(100) NOT NULL,
        html_pane_bg_color varchar2(10) NOT NULL,
        html_pane_icon varchar2(100),
        CONSTRAINT fsd_systems_pk PRIMARY KEY (system_id)
);


/* Sequence for system*/
CREATE SEQUENCE IPC.IPC_FSD_SYSTEMS_SEQ
MINVALUE 1
-- MAXVALUE 999999999999999999999999999 -- THIS IS THE DEFAULT
START WITH 1
INCREMENT BY 1
NOCACHE;

        SELECT    SYSTEM_ID,
            SYSTEM_NAME,
            DESCRIPTION,
            LINK,
            LINK_DESCRIPTION,
            HTML_PANE_BG_COLOR,
            HTML_PANE_ICON,
            DISPLAY_SEQUENCE
        FROM IPC.IPC_FSD_SYSTEMS
        ORDER BY DISPLAY_SEQUENCE ASC;

SELECT a.rowid,a.*
FROM IPC.IPC_FSD_SYSTEMS a;

UPDATE IPC.IPC_FSD_SYSTEMS
SET 

UPDATE IPC.IPC_FSD_SYSTEMS
SET DISPLAY_SEQUENCE = 3
WHERE SYSTEM_ID = 5;

INSERT INTO IPC.IPC_FSD_SYSTEMS (
    SYSTEM_ID,
    SYSTEM_NAME,
    DESCRIPTION,
    LINK,
    LINK_DESCRIPTION,
    HTML_PANE_BG_COLOR,
    HTML_PANE_ICON
)
VALUES (
    IPC.IPC_FSD_SYSTEMS_SEQ.NEXTVAL,
    'Oracle Scheduled Jobs',
    'System for viewing scheduled jobs in Oracle EBS',
    'ecommerce5/jobs/',
    'Click here',
    'small-box bg-yellow',
    'ion ion-person-add'
);