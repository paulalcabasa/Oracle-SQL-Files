CREATE OR REPLACE FUNCTION IPC_DECRYPT_ORA_USR_PWD(p_encrypted_user_pwd IN varchar2) 
RETURN VARCHAR2 IS v_user_password varchar2(100);
BEGIN
 SELECT   APPS.IPC_PKG_GET_ORA_PWD.decrypt
          ((SELECT (SELECT APPS.IPC_PKG_GET_ORA_PWD.decrypt
                              (fnd_web_sec.get_guest_username_pwd,
                               usertable.encrypted_foundation_password
                              )
                      FROM DUAL) AS apps_password
              FROM fnd_user usertable
             WHERE usertable.user_name =
                      (SELECT SUBSTR
                                  (fnd_web_sec.get_guest_username_pwd,
                                   1,
                                     INSTR
                                          (fnd_web_sec.get_guest_username_pwd,
                                           '/'
                                          )
                                   - 1
                                  )
                         FROM DUAL)),
           p_encrypted_user_pwd
          ) into v_user_password
     FROM DUAL;
return v_user_password;
END;