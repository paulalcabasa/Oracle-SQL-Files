SELECT *
FROM RA_CUSTOMER_TRX_ALL;

SELECT RCTA.TRX_NUMBER,
            RCTA.TRX_DATE,
            MSIB.SEGMENT1 PART_NO,
            RCTAL.DESCRIPTION,
            RCTAL.QUANTITY_ORDERED,
            RCTAL.QUANTITY_INVOICED,
            RCTAL.UNIT_STANDARD_PRICE,
            RCTAL.UNIT_SELLING_PRICE
           
FROM RA_CUSTOMER_TRX_LINES_ALL RCTAL,
          RA_CUSTOMER_TRX_ALL RCTA,
          MTL_SYSTEM_ITEMS_B MSIB
WHERE 1 = 1
            AND RCTAL.CUSTOMER_TRX_ID = RCTA.CUSTOMER_TRX_ID
            AND MSIB.INVENTORY_ITEM_ID = RCTAL.INVENTORY_ITEM_ID
            AND MSIB.ORGANIZATION_ID = RCTAL.WAREHOUSE_ID
            AND RCTAL.WAREHOUSE_ID = 90;
            
            select *
            from ap_invoices_all
            where doc_sequence_value = '20029357';
            
            SELECT *
            FROM XLA_AE_LINES XAL,
                     XLA_AE_HEADERS XAH,
                     GL_CODE_COMBINATIONS GCC
              WHERE 1 = 1
                        AND XAH.AE_HEADER_ID = XAL.AE_HEADER_ID
                        AND GCC.CODE_COMBINATION_ID = XAL.CODE_COMBINATION_ID
                        AND GCC.SEGMENT6 = '89911'
                        AND XAH.ACCOUNTING_DATE BETWEEN '01-JAN-2017' AND '30-JUN-2017';
                          
            