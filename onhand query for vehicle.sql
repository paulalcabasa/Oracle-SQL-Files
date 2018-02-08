-- ONHAND QUERY
SELECT moq.organization_id,
            msi.inventory_item_id,
            msi.segment1 prod_model,
            msi.attribute9 sales_model,
            msi.description,
            sum (moq.transaction_quantity) transaction_quantity,
            (SELECT sum(reservation_quantity)
            FROM mtl_reservations
            WHERE inventory_item_id = msi.inventory_item_id
            and organization_id = msi.organization_id) reserved_quantity
FROM apps.mtl_onhand_quantities moq 
            INNER JOIN inv.mtl_system_items_b msi
                ON msi.inventory_item_id  = moq.inventory_item_id
                AND msi.organization_id = moq.organization_id
WHERE 1 = 1
      --       AND msi.inventory_item_id = 435236
           AND msi.organization_id = 121
GROUP BY moq.organization_id, 
                  msi.segment1, 
                  msi.description,
                  msi.inventory_item_id,
                  msi.organization_id,
                  msi.attribute9;
                  

SELECT 
            model_variant,
            sales_model,
            color,
            nvl(max(onhand),0) item_stock,
            sum(ffo_wk1) ffo_wk1,
            sum(ffo_wk2) ffo_wk2,
            sum(ffo_wk3) ffo_wk3,
            sum(ffo_wk4) ffo_wk4,
            sum(forecast_order_1) forecast_order_1,
            sum(forecast_order_2) forecast_order_2
FROM 
            (SELECT msib.inventory_item_id,
                     msib.attribute9 sales_model,
                     msib.attribute8 color,
                     vehicle_model.model_variant,
                     max (tbl_onhand.transaction_quantity) onhand,
                     SUM(
                        CASE 
                            WHEN fot.name = 'Final Firm Order' AND fl.col_sequence = 1  THEN fl.quantity
                            ELSE 0
                        END
                     ) ffo_wk1,
                     SUM(
                        CASE 
                            WHEN fot.name = 'Final Firm Order' AND fl.col_sequence = 2  THEN fl.quantity
                            ELSE 0
                        END
                     ) ffo_wk2,
                     SUM(
                        CASE 
                            WHEN fot.name = 'Final Firm Order' AND fl.col_sequence = 3  THEN fl.quantity
                            ELSE 0
                        END
                     ) ffo_wk3,
                     SUM(
                        CASE 
                            WHEN fot.name = 'Final Firm Order' AND fl.col_sequence = 4  THEN fl.quantity
                            ELSE 0
                        END
                     ) ffo_wk4,
                     SUM(
                        CASE 
                            WHEN fot.name = 'Forecast Order 1' AND fl.col_sequence = 1  THEN fl.quantity
                            ELSE 0
                        END
                     ) forecast_order_1,
                     SUM(
                        CASE 
                            WHEN fot.name = 'Forecast Order 2' AND fl.col_sequence = 1  THEN fl.quantity
                            ELSE 0
                        END
                     ) forecast_order_2
                                 
            FROM ipc_dms.forecast_lines fl
               INNER JOIN ipc_dms.forecast_headers fh
                    ON fh.forecast_header_id = fl.forecast_header_id
                    AND fh.status_id = 7           
               INNER JOIN apps.mtl_system_items_b msib
                    ON msib.inventory_item_id = fl.inventory_item_id
                    AND msib.organization_id = fl.organization_id
               LEFT JOIN ipc_dms.ipc_vehicle_models_v vehicle_model
                    ON vehicle_model.inventory_item_id = msib.inventory_item_id
                    AND vehicle_model.organization_id = msib.organization_id
               INNER JOIN ipc_dms.forecast_order_types fot
                    ON fot.forecast_order_type_id = fl.forecast_order_type_id
               LEFT JOIN (SELECT moq.organization_id,
                                            msi.inventory_item_id,
                                            msi.segment1,    
                                            msi.description,
                                            sum (moq.transaction_quantity) transaction_quantity,
                                            (SELECT sum(reservation_quantity)
                                            FROM mtl_reservations
                                            WHERE inventory_item_id = msi.inventory_item_id
                                            and organization_id = msi.organization_id) reserved_quantity
                                FROM apps.mtl_onhand_quantities moq 
                                            INNER JOIN inv.mtl_system_items_b msi
                                                ON msi.inventory_item_id  = moq.inventory_item_id
                                                AND msi.organization_id = moq.organization_id
                                WHERE 1 = 1
                                GROUP BY moq.organization_id, 
                                                  msi.segment1, 
                                                  msi.description,
                                                  msi.inventory_item_id,
                                                  msi.organization_id) tbl_onhand
               ON tbl_onhand.inventory_item_id = fl.inventory_item_id
               AND tbl_onhand.organization_id = fl.organization_id
               AND tbl_onhand.inventory_item_id = msib.inventory_item_id
               AND tbl_onhand.organization_id = msib.organization_id      
            WHERE 1 = 1
                 AND fl.line_status = 'INITIAL' 
                 AND msib.inventory_item_id =373239
       --          AND fh.date_created BETWEEN ? AND ? 
            GROUP BY msib.attribute9,
                      msib.attribute8,
                      vehicle_model.model_variant,
                      msib.inventory_item_id
                      )
  
GROUP BY ROLLUP (
            model_variant,
            sales_model,
            color
);

select *
from apps.mtl_onhand_quantities ;


                                                  
SELECT moq.organization_id,
            msi.inventory_item_id,
            msi.segment1,    
            msi.description,
            sum (moq.transaction_quantity)
FROM apps.mtl_onhand_quantities moq 
            LEFT JOIN inv.mtl_system_items_b msi
                ON msi.inventory_item_id  = moq.inventory_item_id
                AND msi.organization_id = moq.organization_id
WHERE 1 = 1
            AND moq.organization_id    = 121
            AND msi.inventory_item_id = 373239
GROUP BY moq.organization_id, 
                  msi.segment1, 
                  msi.description;

select *
from ipc_dms.ipc_vehicle_models_v
where sales_model = '180 mu-X 4x2 LS-A AT 3.0';

SELECT *
FROM MTL_SYSTEM_ITEMS_B
WHERE SEGMENT1 = '170TBR-IPCBD2LE-O.GRAY';

SELECT SUM(RESERVATION_QUANTITY)
FROM mtl_reservations
WHERE inventory_item_id = 435236
             and organization_id = 121;

SELECT    moq.subinventory_code, 
                moq.organization_id,
                moq.inventory_item_id,
                sum(moq.primary_transaction_quantity),
                sum(mrs.primary_reservation_quantity) reserve_qty
FROM mtl_onhand_quantities_detail moq, mtl_reservations mrs
WHERE moq.inventory_item_id = mrs.inventory_item_id(+)
            AND moq.organization_id = mrs.organization_id(+)
            AND moq.subinventory_code = mrs.subinventory_code(+)
            AND moq.inventory_item_id = 435236
            AND moq.organization_id = 121
GROUP BY
            moq.subinventory_code, 
            moq.organization_id,
            moq.inventory_item_id;
            
SELECT   moq.subinventory_code, moq.organization_id,

                      moq.inventory_item_id,

                        moq.primary_transaction_quantity,

                        mrs.primary_reservation_quantity reserve_qty

        FROM mtl_onhand_quantities_detail moq, mtl_reservations mrs

        WHERE moq.inventory_item_id = mrs.inventory_item_id(+)

        AND moq.organization_id = mrs.organization_id(+)

        AND moq.subinventory_code = mrs.subinventory_code(+)

        AND moq.inventory_item_id = 138645

        AND moq.organization_id = 282