select xdl.*
from   xla_ae_lines         xal,
 xla_distribution_links xdl
where
  xal.ae_header_id = xdl.ae_header_id and 
  xal.ae_line_num = xdl.ae_line_num and 
 xal.ae_header_id = '9188939';


select * from xla_distribution_links xdl
where xdl.ae_header_id = '9188939';
