SELECT 
                                                                assembly_model,
                                                                sales_model,
                                                                MAX(body_color) body_color,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 1 THEN 1 ELSE NULL END) day_1,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 2 THEN 1 ELSE NULL END) day_2,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 3 THEN 1 ELSE NULL END) day_3,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 4 THEN 1 ELSE NULL END) day_4,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 5 THEN 1 ELSE NULL END) day_5,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 6 THEN 1 ELSE NULL END) day_6,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 7 THEN 1 ELSE NULL END) day_7,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 8 THEN 1 ELSE NULL END) day_8,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 9 THEN 1 ELSE NULL END) day_9,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 10 THEN 1 ELSE NULL END) day_10,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 11 THEN 1 ELSE NULL END) day_11,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 12 THEN 1 ELSE NULL END) day_12,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 13 THEN 1 ELSE NULL END) day_13,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 14 THEN 1 ELSE NULL END) day_14,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 15 THEN 1 ELSE NULL END) day_15,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 16 THEN 1 ELSE NULL END) day_16,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 17 THEN 1 ELSE NULL END) day_17,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 18 THEN 1 ELSE NULL END) day_18,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 19 THEN 1 ELSE NULL END) day_19,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 20 THEN 1 ELSE NULL END) day_20,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 21 THEN 1 ELSE NULL END) day_21,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 22 THEN 1 ELSE NULL END) day_22,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 23 THEN 1 ELSE NULL END) day_23,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 24 THEN 1 ELSE NULL END) day_24,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 25 THEN 1 ELSE NULL END) day_25,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 26 THEN 1 ELSE NULL END) day_26,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 27 THEN 1 ELSE NULL END) day_27,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 28 THEN 1 ELSE NULL END) day_28,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 29 THEN 1 ELSE NULL END) day_29,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 30 THEN 1 ELSE NULL END) day_30,
                                                                COUNT(CASE WHEN EXTRACT (day from to_date(buyoff_date,'MM/DD/YYYY')) = 31 THEN 1 ELSE NULL END) day_31,
                                                                COUNT(*) total
                                                                FROM (
                                                                SELECT msn.serial_number, msib.segment1 assembly_model, msib.attribute9 sales_model,
                                                                                 msib.attribute8 body_color, 
                                                                                 CASE
                                                                                    WHEN REGEXP_LIKE (msn.attribute5,
                                                                                                      '^[0-9]{2}-\w{3}-[0-9]{2}$' --     DD-MON-YY
                                                                                                     )
                                                                                       THEN TO_CHAR (msn.attribute5, 'MM/DD/YYYY')
                                                                                    WHEN REGEXP_LIKE (msn.attribute5,
                                                                                                      '^[0-9]{2}-\w{3}-[0-9]{4}$'  -- DD-MON-YYYY
                                                                                                     )
                                                                                       THEN TO_CHAR (msn.attribute5, 'MM/DD/YYYY')
                                                                                    WHEN REGEXP_LIKE (msn.attribute5,
                                                                                                      '^[0-9]{4}/[0-9]{2}/[0-9]{2}' -- YYYY/MM/DD
                                                                                                     )
                                                                                       THEN TO_CHAR (TO_DATE (msn.attribute5,
                                                                                                              'YYYY/MM/DD HH24:MI:SS'
                                                                                                             ),
                                                                                                     'MM/DD/YYYY'
                                                                                                    )
                                                                                        WHEN REGEXP_LIKE (msn.attribute5,
                                                                                                      '^[0-9]{2}/[0-9]{2}/[0-9]{4}' -- MM/DD/YYYY
                                                                                                    )
                                                                                       THEN TO_CHAR (TO_DATE (msn.attribute5,
                                                                                                              'MM/DD/YYYY'
                                                                                                             ),
                                                                                                     'MM/DD/YYYY'
                                                                                                    )
                                                                                    ELSE TO_CHAR(to_Date(msn.attribute5, 'MM/DD/YYYY'),'MM/DD/YYYY')
                                                                                 END buyoff_date
                                                                            FROM mtl_system_items_b msib, mtl_serial_numbers msn
                                                                           WHERE 1 = 1
                                                                             AND msn.inventory_item_id = msib.inventory_item_id
                                                                             AND msn.current_organization_id = msib.organization_id
                                                                             AND msib.item_type = 'FG'
                                                                             AND msn.c_attribute30 is null)
                                                                               WHERE 1 = 1
                                                                     AND TO_DATE (buyoff_date, 'MM/DD/YYYY') BETWEEN ? AND ?
                                                                     AND ROWNUM <= 300
                                                                     GROUP BY rollup (sales_model, assembly_model)
