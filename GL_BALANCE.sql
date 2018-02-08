SELECT     
      cc.concatenated_segments   "GL Account"
     ,cc.gl_account_type         "Account Type"
     ,nvl(sum(bal.begin_balance_dr - bal.begin_balance_cr),0)   "Begin Balance"
     ,bal.period_name            "Period Name"
FROM  gl_code_combinations_kfv cc
     ,gl_balances bal
WHERE cc.code_combination_id = bal.code_combination_id
AND   bal.period_name        = 'JAN-17'
AND   bal.set_of_books_id    = '2021'
GROUP BY
      cc.concatenated_segments
     ,cc.gl_account_type
     ,bal.period_name
ORDER by
      cc.concatenated_segments;
      
      SELECT *
      FROM gl_balances;

select *
from xla_ae_lines
where entered_cr  = ' 5290.16';

select *
from gl_je_headers
where status = 'U';

