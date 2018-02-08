select qp_head.list_header_id,
         qp_head.name,
         qp_head.description,
         qp_head.active_flag,
         qp_lines.PRODUCT_ATTR_VAL_DISP,
         qp_lines.OPERAND,
         qp_lines.START_DATE_ACTIVE,
         QP_LINES.END_DATE_ACTIVE
from qp_secu_list_headers_v qp_head,
        qp_list_lines_v qp_lines
where 1 = 1
           and qp_head.name = 'WSP'
           and qp_lines.list_header_id = 9073
           and qp_head.list_header_id = qp_lines.list_header_id
           and QP_LINES.END_DATE_ACTIVE is null;

select *
from XXIPC_WSP_PRICELIST_V; 
drop view XXIPC_WSP_PRICELIST_V;

CREATE VIEW XXIPC_WSP_PRICELIST_V AS (
    select qp_head.list_header_id,
         qp_head.name,
         qp_head.description,
         qp_head.active_flag,
         to_char(qp_lines.PRODUCT_ATTR_VAL_DISP) PRODUCT_ATTR_VAL_DISP,
         qp_lines.OPERAND,
         qp_lines.START_DATE_ACTIVE,
         QP_LINES.END_DATE_ACTIVE
from qp_secu_list_headers_v qp_head,
        qp_list_lines_v qp_lines
where 1 = 1
           and qp_head.name = 'WSP'
           and qp_lines.list_header_id = 9073
           and qp_head.list_header_id = qp_lines.list_header_id
           and QP_LINES.END_DATE_ACTIVE is null
);

COMMIT;

SELECT *
FROM XXIPC_WSP_PRICELIST_V;


select *