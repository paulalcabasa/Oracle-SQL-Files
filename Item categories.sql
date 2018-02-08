/* Formatted on 17/5/2017 5:19:07 PM (QP5 v5.163.1008.3004) */
  SELECT FLEX_VALUE,
         FLEX_VALUE_MEANING,
         DESCRIPTION,
         ENABLED_FLAG,
         START_DATE_ACTIVE,
         END_DATE_ACTIVE,
         SUMMARY_FLAG,
         HIERARCHY_LEVEL,
         FLEX_VALUE_SET_ID,
         PARENT_FLEX_VALUE_LOW,
         PARENT_FLEX_VALUE_HIGH,
         FLEX_VALUE_ID,
         LAST_UPDATE_DATE,
         LAST_UPDATED_BY,
         STRUCTURED_HIERARCHY_LEVEL,
         COMPILED_VALUE_ATTRIBUTES,
         VALUE_CATEGORY,
         ATTRIBUTE1,
         ATTRIBUTE2,
         ATTRIBUTE3,
         ATTRIBUTE4,
         ATTRIBUTE5,
         ATTRIBUTE6,
         ATTRIBUTE7,
         ATTRIBUTE8,
         ATTRIBUTE9,
         ATTRIBUTE10,
         CREATED_BY,
         CREATION_DATE,
         LAST_UPDATE_LOGIN,
         ATTRIBUTE11,
         ATTRIBUTE12,
         ATTRIBUTE13,
         ATTRIBUTE14,
         ATTRIBUTE15,
         ATTRIBUTE16,
         ATTRIBUTE17,
         ATTRIBUTE18,
         ATTRIBUTE19,
         ATTRIBUTE20,
         ATTRIBUTE21,
         ATTRIBUTE22,
         ATTRIBUTE23,
         ATTRIBUTE24,
         ATTRIBUTE25,
         ATTRIBUTE26,
         ATTRIBUTE27,
         ATTRIBUTE28,
         ATTRIBUTE29,
         ATTRIBUTE30,
         ATTRIBUTE31,
         ATTRIBUTE32,
         ATTRIBUTE33,
         ATTRIBUTE34,
         ATTRIBUTE35,
         ATTRIBUTE36,
         ATTRIBUTE37,
         ATTRIBUTE38,
         ATTRIBUTE39,
         ATTRIBUTE40,
         ATTRIBUTE41,
         ATTRIBUTE42,
         ATTRIBUTE43,
         ATTRIBUTE44,
         ATTRIBUTE45,
         ATTRIBUTE46,
         ATTRIBUTE47,
         ATTRIBUTE48,
         ATTRIBUTE49,
         ATTRIBUTE50,
         ATTRIBUTE_SORT_ORDER,
         ROW_ID
    FROM FND_FLEX_VALUES_VL
   WHERE ( ('' IS NULL)
          OR (structured_hierarchy_level IN
                 (SELECT hierarchy_id
                    FROM fnd_flex_hierarchies_vl h
                   WHERE h.flex_value_set_id = 1014947
                         AND h.hierarchy_name LIKE '')))
         AND (FLEX_VALUE_SET_ID = 1014947)
ORDER BY flex_value;

select *
from mtl_item_categories
where inventory_item_id = 105375
and organization_id = 102;

select *
from mtl_categories;

SELECT *
FROM mtl_category_sets_b;

select *
from mtl_system_items_b
where segment1 = '8932908543'
and organization_id = 102;