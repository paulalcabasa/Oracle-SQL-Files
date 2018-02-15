select sum(gjl.accounted_dr) DR,
          sum( gjl.accounted_cr) CR,
           sum(gjl.accounted_dr) -
          sum( gjl.accounted_cr) NET
from gl_je_lines gjl,
        gl_code_combinations gcc,
        gl_je_headers gjh
where gjl.code_Combination_id = gcc.code_combination_id
            and gjh.je_header_id = gjl.je_header_id
            and gcc.segment6 IN('63000','66904')
            and gjh.default_effective_date <= '31-DEC-2016';
            
            select *
            from ipc_dbs_backorder_v;