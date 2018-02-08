SELECT glb.currency_code,
            glb.period_net_dr,
            glb.period_net_cr,
            GLB.*
FROM gl_balances glb
           INNER JOIN gl_code_combinations gcc
                ON glb.code_combination_id = gcc.code_combination_id
where period_name = 'SEP-17'
            and gcc.segment6 = '63000';
            
            
            select *
            from 
             