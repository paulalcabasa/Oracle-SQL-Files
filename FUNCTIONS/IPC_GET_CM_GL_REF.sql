CREATE OR REPLACE FUNCTION APPS.IPC_GET_CM_GL_REF (P_CUSTOMER_TRX_ID IN VARCHAR2)
RETURN VARCHAR2 IS v_gl_refs VARCHAR2(250);
BEGIN
   
          select LISTAGG(doc_sequence_value, ', ' ) WITHIN GROUP (ORDER BY  doc_sequence_value ASC) into v_gl_refs
            from (SELECT gjh.doc_sequence_value -- LISTAGG(gjh.doc_sequence_value, ', ' ) WITHIN GROUP (ORDER BY  gjh.doc_sequence_value ASC)
                        FROM xla.xla_ae_headers xah 
                                INNER JOIN xla.xla_ae_lines xal
                                    ON  xah.ae_header_id = xal.ae_header_id 
                                    AND xal.application_id = xah.application_id
                                INNER  JOIN xla.xla_transaction_entities xte
                                    ON xah.entity_id = xte.entity_id
                                    AND xte.application_id = xal.application_id
                                INNER JOIN apps.gl_import_references gir
                                    ON gir.gl_sl_link_id = xal.gl_sl_link_id
                                    AND gir.gl_sl_link_table = xal.gl_sl_link_table
                                INNER JOIN apps.gl_je_headers gjh         
                                    ON gjh.je_header_id = gir.je_header_id
            where   xte.source_id_int_1 = P_CUSTOMER_TRX_ID
                            and xte.entity_code = 'TRANSACTIONS'
            group by gjh.doc_sequence_value);
            
        RETURN v_gl_refs;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                RETURN 0;
END;
/
