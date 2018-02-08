SELECT fad.asset_id,
            fad.asset_number,
            fad.description,
            fad.asset_category_id,
            fct.description,
            fad.asset_key_ccid,
            fkey.segment1 asset_key,
            fad.current_units,
            fad.asset_type,
            fad.in_use_flag,
            fad.inventorial,
            fbk.book_type_code,
            fbk.date_placed_in_service,
            fbk.original_cost,
            fbk.prorate_date,
            fbk.prorate_convention_code,
            fbk.life_in_months,
            fbk.deprn_method_code,
            fbk.salvage_value,
            fbk.cost,
            fbk.adjusted_cost,
            fdh.code_combination_id,
            fal.segment1 || '.' ||
            fal.segment2 || '.' ||
            fal.segment3 || '.' ||
            fal.segment4 location,
            gcc.segment1 || '.' ||
            gcc.segment2 || '.' ||
            gcc.segment3 || '.' ||
            gcc.segment4 || '.' ||
            gcc.segment5 || '.' ||
            gcc.segment6   code_combination,
            fds.ytd_deprn YTD_DEPRECIATION,
            fds.deprn_reserve ACCUMULATED_DEPRECIATION
FROM FA_ADDITIONS fad,
          FA_CATEGORIES_TL fct,
          FA_ASSET_KEYWORDS fkey,
          FA_BOOKS fbk,
          FA_DISTRIBUTION_HISTORY fdh,
          fa_locations fal,
          gl_code_combinations gcc,
          fa_deprn_summary fds
WHERE 1 = 1
            AND fad.asset_category_id = fct.category_id
            AND fkey.code_combination_id = fad.asset_key_ccid
            AND fbk.asset_id = fad.asset_id
            AND fdh.asset_id = fad.asset_id
            AND fal.location_id =  fdh.location_id
            AND gcc.code_combination_id =   fdh.code_combination_id
            AND fds.asset_id = fad.asset_id
        --    AND fad.description lik%'
        --    AND fds.ytd_deprn <> 0
           AND fad.asset_number = '18-5';
;
SELECT *ROM FA_BOOKS;

select *
from ra_customer_trx_all;

select *
from fa_deprn_summary
where asset_id = 2273;  

select substr(c.asset_number,6,1) asset_number,sum(a.deprn_reserve) nbt_depr_op_bal
from fa_deprn_summary a,fa_deprn_periods b,fa_additions c
where a.period_counter = b.period_counter
--and b.calendar_period_close_date < pf_date
--AND b.book_type_code = nbt_book_type
and a.asset_id = c.asset_id
and substr(c.asset_number,1,3) = 82
and a.period_counter = (select max(d.period_counter) from fa_deprn_summary d,fa_deprn_periods e
where a.asset_id = d.asset_id
and d.period_counter = e.period_counter
--and e.calendar_period_close_date < pf_date)
group by substr(c.asset_number,6,1); 

SELECT *
FROM XLA_AE_HEADERS
WHERE AE_HEADER_ID = 37001;

select *
from DBS_DELIVERY_RECEIPT_INTERFACE;


select *
from oe_order_headers_all
where order_number = '3010006638';

select *
from ra_customer_trx_all
where comments = '980243488';

select *
from XXIPC_VEHICLE_INQUIRY_V;

SELECT *
FROM XXIPC_VEHICLE_INQUIRY_V;

CREATE OR REPLACE FORCE VIEW APPS.XXIPC_VEHICLE_INQUIRY_V
(
   SUBINVENTORY_CODE,
   INVENTORY_ITEM_ID,
   ORGANIZATION_CODE,
   ITEM_MODEL,
   CS_NUMBER,
   LOT_NUMBER,
   CHASSIS_NO,
   BODY_NUMBER,
   ENGINE_NO,
   ENGINE_MODEL,
   KEY_NUMBER,
   BODY_COLOR,
   AC_NO,
   AC_BRAND,
   STEREO_NO,
   STEREO_BRAND,
   FM_DATE,
   BUYOFF_DATE,
   ITEM_TYPE
)
AS
     SELECT msn.current_subinventory_code subinventory_code,
            msi.inventory_item_id,
            mp.organization_code,
            msi.segment1 item_model,
            msn.serial_number cs_number,
            msn.lot_number lot_number,
            msn.attribute2 chassis_no,
            msn.attribute4 body_number,
            msn.attribute3 engine_no,
            msi.attribute11 engine_model,
            msn.attribute6 key_number,
            msi.attribute8 body_color,
            SUBSTR (msn.attribute7, 1, INSTR (msn.attribute7, '/') - 1) ac_no,
            SUBSTR (msn.attribute7, -INSTR (reverse (msn.attribute7), '/') + 1)
               ac_brand,
            SUBSTR (msn.attribute9, 1, INSTR (msn.attribute9, '/') - 1)
               stereo_no,
            SUBSTR (msn.attribute9, -INSTR (reverse (msn.attribute9), '/') + 1)
               stereo_brand,
            SUBSTR (msn.attribute11,
                    -INSTR (reverse (msn.attribute11), '/') + 1)
               fm_date,
            msn.attribute5 AS buyoff_date,
            msi.item_type
       FROM mtl_system_items_b msi
            LEFT JOIN mtl_serial_numbers msn
               ON msi.inventory_item_id = msn.inventory_item_id
                  AND msi.organization_id = msn.current_organization_id
            LEFT JOIN mtl_parameters mp
               ON msi.organization_id = mp.organization_id
      WHERE     1 = 1
            AND mp.organization_code IN ('IVS')
            AND CURRENT_STATUS in (3,4)
   ORDER BY msn.serial_number DESC;
