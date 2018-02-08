SELECT *
FROM MTL_TRANSACTION_TYPES;

-- Move Order Issue
-- Move Order Transfer
-- MMT.TRANSACTION_TYPE_ID
-- cid.organization_id

SELECT   cid.organization_code
            , hro.name organization_name
            , to_char(MMT.TRANSACTION_ID) transaction_id
            , mck.segment1 as ITEM_CATEGORY_FAMILY
            , mck.segment2 as ITEM_CATEGORY_CLASS
            , MSI.ITEM_TYPE
            , FLV.MEANING as ITEM_TYPE_DESCRIPTION
            , MTY.TRANSACTION_TYPE_NAME
            , MSI.SEGMENT1 as item
            , MSI.DESCRIPTION
            , TRUNC(MMT.TRANSACTION_DATE) AS TRANSACTION_DATE
            , MMT.TRANSACTION_QUANTITY
            , MMT.TRANSACTION_UOM
            , MMT.TRANSACTION_SOURCE_NAME
            , CID.UNIT_COST
            , NVL(MMT.ACTUAL_COST,0) AS ACTUAL_COST
            , max(CASE WHEN CID.BASE_TRANSACTION_VALUE > 0 THEN GCC.SEGMENT6 END) debit_account
            , max(CASE WHEN CID.BASE_TRANSACTION_VALUE > 0 THEN CID.BASE_TRANSACTION_VALUE END) DEBIT
            , max(CASE WHEN CID.BASE_TRANSACTION_VALUE < 0 THEN GCC.SEGMENT6 END) credit_account
            , max(CASE WHEN CID.BASE_TRANSACTION_VALUE < 0 THEN CID.BASE_TRANSACTION_VALUE END) CREDIT
FROM     MTL_MATERIAL_TRANSACTIONS      MMT
            , MTL_SYSTEM_ITEMS_B             MSI
            , HR_ALL_ORGANIZATION_UNITS      HRO
            , MTL_TRANSACTION_TYPES          MTY
            , CST_INV_DISTRIBUTION_V         CID
            , GL_CODE_COMBINATIONS_KFV       GCC
            , FND_LOOKUP_VALUES_VL     FLV
            , MTL_ITEM_CATEGORIES  mtc
            ,  mtl_categories_kfv mck
WHERE 1 = 1
            AND  msi.inventory_item_id = mtc.inventory_item_id 
            AND  MMT.ORGANIZATION_ID = mtc.ORGANIZATION_ID 
            AND  mtc.CATEGORY_ID =mck.CATEGORY_ID 
            AND  MMT.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
            AND  MMT.ORGANIZATION_ID = MSI.ORGANIZATION_ID
            AND  MMT.ORGANIZATION_ID = HRO.ORGANIZATION_ID
            AND  MMT.TRANSACTION_TYPE_ID = MTY.TRANSACTION_TYPE_ID
            AND  MMT.TRANSACTION_ID =  CID.TRANSACTION_ID
            AND  MMT.ORGANIZATION_ID = CID.ORGANIZATION_ID
            AND  CID.REFERENCE_ACCOUNT = GCC.CODE_COMBINATION_ID
            AND  FLV.LOOKUP_TYPE = 'ITEM_TYPE'
            AND  MSI.ITEM_TYPE = FLV.LOOKUP_CODE  
            AND  MCK.STRUCTURE_ID = '50388'
            AND CID.BASE_TRANSACTION_VALUE <> 0 
          --  AND MMT.TRANSACTION_ID = 900485
      --      AND to_date(MMT.TRANSACTION_DATE) BETWEEN TO_DATE (:P_TRANS_START_DATE, 'yyyy/mm/dd hh24:mi:ss') and TO_DATE (:P_TRANS_END_DATE, 'yyyy/mm/dd hh24:mi:ss')
            AND CID.ORGANIZATION_ID = NVL(:P_ORGANIZATION,CID.ORGANIZATION_ID)
GROUP BY  CID.ORGANIZATION_CODE
            , HRO.NAME
            , MMT.TRANSACTION_ID
            , cid.organization_id
            , mck.segment1
            , mck.segment2
            , MSI.ITEM_TYPE
            , FLV.MEANING
            , MTY.TRANSACTION_TYPE_NAME
            , MMT.TRANSACTION_TYPE_ID
            ,  MSI.SEGMENT1
            ,  MSI.DESCRIPTION
            ,  TRUNC(MMT.TRANSACTION_DATE) 
            , MMT.TRANSACTION_QUANTITY
            , MMT.TRANSACTION_UOM
            , MMT.TRANSACTION_SOURCE_NAME
            , CID.UNIT_COST
            , MMT.ACTUAL_COST
            , ACTUAL_COST;
ORDER BY MMT.TRANSACTION_ID;
-- 2017/01/01 00:00:00, 2017/01/10 00:00:00,
-- MORE THAN 3, DISPLAY ALL ROWS
-- IF ONLY 2, DISPLAY IN ONE LINE
    --        AND cid.organization_code IN ('DBS','IPS')
      --      and mmt.transaction_id = 635357
 --           and   MTY.TRANSACTION_TYPE_NAME IN('Move Order Issue', 'Move Order Transfer')
      --      AND  mmt.transaction_id = 1154172       

select *
from hr_all_organization_units;

select *
from ra_customer_trx_all rcta
where (select sum(extended_amount)
           from ra_customer_trx_lines rctal
           where rctal.customer_trx_id = rcta.customer_trx_id
          ) BETWEEN '53525.85' AND '53526';
          
          
          select *
          from mtl_material_transactions
          where transaction_id = 3168962;