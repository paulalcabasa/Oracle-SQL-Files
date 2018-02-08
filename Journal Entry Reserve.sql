-- PARAMETERS
SELECT
            BC.DISTRIBUTION_SOURCE_BOOK             dbk,
            nvl (DP.PERIOD_CLOSE_DATE, sysdate)     ucd,
            DP.PERIOD_COUNTER                       upc,
            min (DP_FY.PERIOD_OPEN_DATE)            tod,
            min (DP_FY.PERIOD_COUNTER)              tpc 
FROM
            FA_DEPRN_PERIODS        DP,
            FA_DEPRN_PERIODS        DP_FY, 
            FA_BOOK_CONTROLS        BC
WHERE
            1 = 1
            AND DP.BOOK_TYPE_CODE       =  'IPC_ASSETS BOOK'
            AND DP.PERIOD_NAME          =  :P_PERIOD
            AND DP_FY.BOOK_TYPE_CODE    =  'IPC_ASSETS BOOK' 
            AND DP_FY.FISCAL_YEAR       =  DP.FISCAL_YEAR
            AND BC.BOOK_TYPE_CODE       =  'IPC_ASSETS BOOK'
GROUP BY
            BC.DISTRIBUTION_SOURCE_BOOK,
            DP.PERIOD_CLOSE_DATE,
            DP.PERIOD_COUNTER;



SELECT 
         '' AS "Period Name",  --to reflect period name
       dhcc.segment1 AS "Company",
       dhcc.segment2 AS "Cost Center", dhcc.segment3 AS "ID",
       dhcc.segment4 AS "Budget Account",
       dhcc.segment5 AS "Budget Cost Center", dhcc.segment6 AS "Account",
       dhcc.segment7 AS "Model", dh.asset_id AS "Asset ID",
       
--   DH.CODE_COMBINATION_ID DH_CCID,
       cb.deprn_reserve_acct AS "Depreciation Reserve Account",
         cb.asset_cost_acct as "Asset Cost Account",
       books.date_placed_in_service AS "Date in Service",
       books.deprn_method_code AS "Depreciation Method",
       books.life_in_months AS "Life", books.adjusted_rate AS "Rate",
       dd_bonus.COST AS "Cost",
       DECODE (dd_bonus.period_counter,
               :upc, dd_bonus.deprn_amount - dd_bonus.bonus_deprn_amount,
               0
              ) AS "Depreciation Amount",
       DECODE (SIGN (:tpc - dd_bonus.period_counter),
               1, 0,
               dd_bonus.ytd_deprn - dd_bonus.bonus_ytd_deprn
              ) AS "YTD Depreciation",
         dd_bonus.deprn_reserve
       - NVL (dd_bonus.bonus_deprn_reserve, 0) AS "Depreciation Reserve",
       DECODE (dh.transaction_header_id_out,
               NULL, DECODE (th_rt.transaction_type_code,
                             'FULL RETIREMENT', 'F',
                             DECODE (books.depreciate_flag, 'NO', 'N')
                            ),
               'TRANSFER', 'T',
               'TRANSFER OUT', 'P',
               'RECLASS', 'R'
              ) AS "Type",
       
--      DD_BONUS.PERIOD_COUNTER,
--                   :ucd,
  --                 '',
       ad.asset_number, ad.description, ds.bonus_rate
  FROM fa_deprn_detail dd_bonus,
       fa_distribution_history dh,
       fa_asset_history ah,
       fa_books books,
       fa_transaction_headers th_rt,
       fa_category_books cb,
       fa_additions ad,
       fa_deprn_summary ds,
       gl_code_combinations dhcc
WHERE dhcc.code_combination_id(+) = dh.code_combination_id
   AND books.book_type_code = :p_book
   AND books.asset_id = dd_bonus.asset_id                            --7721457
   AND books.asset_id = ad.asset_id
--               AND AD.ASSET_ID               BETWEEN  start_asset_id
  --                                            AND     end_asset_id
   AND NVL (books.period_counter_fully_retired, :upc) >= :tpc
   AND books.date_effective <= :ucd
   AND NVL (books.date_ineffective, SYSDATE + 1) > :ucd
   AND cb.book_type_code = books.book_type_code
   AND cb.category_id = ah.category_id
   AND ah.asset_id = dd_bonus.asset_id                               --7721457
   AND dd_bonus.book_type_code = books.book_type_code
   AND dd_bonus.distribution_id = dh.distribution_id
   AND dd_bonus.period_counter IN (
          SELECT NVL (MAX (period_counter), 0) period_counter
            FROM fa_deprn_detail
           WHERE book_type_code = :dbk
             AND period_counter <= :upc
             AND distribution_id = dd_bonus.distribution_id)
--               AND DD_BONUS.ASSET_ID  BETWEEN start_asset_id AND end_asset_id
   AND ah.date_effective < :ucd
   AND NVL (ah.date_ineffective, SYSDATE) >= :ucd
   AND ah.asset_type = 'CAPITALIZED'
   AND th_rt.book_type_code = books.book_type_code
   AND th_rt.transaction_header_id = books.transaction_header_id_in
   AND dh.book_type_code = :dbk
   AND dh.date_effective <= :ucd
   AND NVL (dh.date_ineffective, SYSDATE) > :tod
   AND ds.book_type_code = dd_bonus.book_type_code
   AND ds.period_counter = dd_bonus.period_counter
   AND ds.asset_id = dd_bonus.asset_id

