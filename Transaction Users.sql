-- GL USERS
select gjh.je_category,
          gjh.je_source,
          usr.user_name,
          usr.description
from gl_je_headers gjh
        LEFT JOIN fnd_user usr
            ON gjh.created_by = usr.user_id
where gjh.default_effective_date BETWEEN '01-JAN-2017' AND '30-JUN-2017'
GROUP BY 
        gjh.je_category,
          gjh.je_source,
          usr.user_name,
          usr.description;

-- MATERIAL TRANSACTION USERS
SELECT mtt.transaction_type_name,
             usr.user_name,
             usr.description
FROM mtl_material_transactions mmt
            INNER JOIN fnd_user usr
                ON mmt.created_by = usr.user_id
            INNER JOIN mtl_transaction_types mtt
                ON mtt.transaction_type_id = mmt.transaction_type_id
WHERE 1 = 1 
            AND mmt.transaction_date between '01-JAN-2017' AND '30-JUN-2017'
GROUP BY 
            mtt.transaction_type_name,
            usr.user_name,
            usr.description;
                
          