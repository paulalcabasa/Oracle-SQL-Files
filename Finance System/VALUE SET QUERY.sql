SELECT ffvs.flex_value_set_id ,
            ffvs.flex_value_set_name ,
            ffv.flex_value,
            ffvt.description value_description,
            ffv.enabled_flag
FROM fnd_flex_value_sets ffvs,
            fnd_flex_values ffv,
            fnd_flex_values_tl ffvt
WHERE 1 = 1
            AND ffvs.flex_value_set_id = ffv.flex_value_set_id
            AND ffv.flex_value_id = ffvt.flex_value_id
            AND ffv.enabled_flag = 'Y'
            AND ffvt.language = USERENV('LANG')
            AND flex_value_set_name = 'TRANSACTION TYPE'
            ORDER BY flex_value ASC;