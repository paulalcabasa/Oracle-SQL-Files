-- Sequence for PPR HEADERS
CREATE SEQUENCE IPC.PPR_HEADERS_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;
 
-- DELETE FROM  IPC.IPC_PPR_HEADERS;
 
CREATE SEQUENCE IPC.PPR_HEADERS_DOC_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

-- Sequence for PPR Lines
CREATE SEQUENCE IPC.PPR_LINES_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;

-- DELETE FROM IPC.IPC_PPR_LINES;

DROP SEQUENCE IPC.PPR_NOTIFS_SEQ;

CREATE SEQUENCE IPC.PPR_NOTIFS_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE 
  NOORDER;
  
--  DELETE FROM IPC.IPC_PPR_EMAIL_NOTIF;

SELECT * FROM IPC.IPC_PPR_APPROVAL;

DELETE FROM IPC.IPC_PPR_APPROVAL;

DROP SEQUENCE IPC.PPR_APPROVAL_SEQ;

CREATE SEQUENCE IPC.PPR_APPROVAL_SEQ
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;
