SELECT   
             fp.period_name AS "Period Name", 
             dhcc.segment1 AS "Company",
         dhcc.segment2 AS "Cost Center", 
             dhcc.segment3 AS "ID",
         dhcc.segment4 AS "Budget Account",
         dhcc.segment5 AS "Budget Cost Center", 
             dhcc.segment6 AS "Account",
         dhcc.segment7 AS "Model",
         TO_CHAR (adt.asset_number) AS "Asset Number",
         adt.description AS "Description",
         cat.segment1 AS "Major Asset Category",
         cat.segment2 AS "Minor Asset Category",
         bks.date_placed_in_service "Acquistion Date",
         bks.original_cost AS "Original Cost",
         ROUND (SUM (  DECODE (bks.period_counter_fully_retired, '', bks.COST, 0 ) * dh.units_assigned / ah.units ), 2 ) AS "Cost",
         ROUND (SUM (NVL (dn.deprn_amount, 0) * dh.units_assigned / ah.units), 2 ) AS "Depreciation Amount",
         ROUND (SUM (NVL (dn.deprn_reserve, 0) * dh.units_assigned / ah.units), 2 ) AS "Depreciation Reserve",
         ROUND (SUM (NVL (dn.ytd_deprn, 0) * dh.units_assigned / ah.units), 2 ) AS "YTD Depreciation",
         ROUND (SUM (  DECODE (bks.period_counter_fully_retired,  '', (bks.COST - dn.deprn_reserve),  0 ) * dh.units_assigned  / ah.units  ),  2 ) AS "Net Book Value"
            
FROM 
       fa_distribution_history dh,
      fa_asset_history ah,
      fa_additions adt,
      fa_categories_b cat,
      fa_books bks,
      gl_code_combinations dhcc,
      fa_deprn_summary dn,
      fa_deprn_periods fp
      
WHERE 
        fp.book_type_code = 'IPC_ASSETS BOOK'
        AND dn.book_type_code = 'IPC_ASSETS BOOK'
        AND dn.period_counter =
            (SELECT dp.period_counter
               FROM fa_deprn_periods dp
              WHERE dp.book_type_code = 'IPC_ASSETS BOOK'
                AND dp.period_counter =
                       (SELECT MAX (dpz.period_counter)
                          FROM fa_deprn_summary dsz, fa_deprn_periods dpz
                         WHERE dpz.book_type_code = 'IPC_ASSETS BOOK'
                           AND dpz.period_counter <= fp.period_counter
                           AND dsz.book_type_code = 'IPC_ASSETS BOOK'
                           AND dsz.period_counter = dpz.period_counter
                           AND dsz.asset_id = dn.asset_id))
     AND bks.book_type_code = 'IPC_ASSETS BOOK'
     AND bks.asset_id = dn.asset_id
     AND NVL (bks.date_ineffective, SYSDATE) >
            TO_DATE (TO_CHAR (NVL (fp.period_close_date, SYSDATE), 'DD-MM-YYYY HH24:MI:SS'  ),  'DD-MM-YYYY HH24:MI:SS' )
     AND bks.date_effective <
            TO_DATE (TO_CHAR (NVL (fp.period_close_date, SYSDATE),  'DD-MM-YYYY HH24:MI:SS' ),  'DD-MM-YYYY HH24:MI:SS' )
     AND NVL (bks.period_counter_fully_retired, fp.period_counter) IN (
            SELECT dpy.period_counter
              FROM fa_deprn_periods dpy
             WHERE dpy.book_type_code = 'IPC_ASSETS BOOK'
               AND dpy.fiscal_year = fp.fiscal_year)
     AND adt.asset_id = dn.asset_id
     AND adt.asset_category_id = cat.category_id
     AND adt.asset_id = dh.asset_id
     AND dh.book_type_code = 'IPC_ASSETS BOOK'
     AND NVL (dh.date_ineffective, SYSDATE) >
            TO_DATE (TO_CHAR (NVL (fp.period_close_date, SYSDATE), 'DD-MM-YYYY HH24:MI:SS' ),  'DD-MM-YYYY HH24:MI:SS' )
     AND dh.date_effective <
            TO_DATE (TO_CHAR (NVL (fp.period_close_date, SYSDATE), 'DD-MM-YYYY HH24:MI:SS' ), 'DD-MM-YYYY HH24:MI:SS' )
     AND dhcc.code_combination_id(+) = dh.code_combination_id
     AND ah.asset_id = adt.asset_id
     AND NVL (ah.date_ineffective, SYSDATE) >
            TO_DATE (TO_CHAR (NVL (fp.period_close_date, SYSDATE),  'DD-MM-YYYY HH24:MI:SS' ), 'DD-MM-YYYY HH24:MI:SS' )
     AND ah.date_effective <
            TO_DATE (TO_CHAR (NVL (fp.period_close_date, SYSDATE),   'DD-MM-YYYY HH24:MI:SS'  ), 'DD-MM-YYYY HH24:MI:SS' )
      and fp.period_name = :p_period ---parameter    
GROUP BY fp.period_name,
         dhcc.segment1,
         dhcc.segment2,
         dhcc.segment2,
         dhcc.segment4,
         dhcc.segment3,
         dhcc.segment5,
         dhcc.segment6,
         dhcc.segment7,
         dhcc.segment8,
         adt.asset_number,
         adt.tag_number,
         cat.segment1,
         cat.segment2,
         adt.description,
         bks.date_placed_in_service,
         bks.original_cost;


select * from fa_deprn_periods
order by fiscal_year asc, period_num asc;

select *
from ap_invoices_all;