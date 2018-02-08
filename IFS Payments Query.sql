SELECT c.identity AS PAYEE_CODE,
f.name as PAYEE_NAME,
c.cash_account AS CHECK_BANK,
CONCAT (a.ledger_item_series_id, a.ledger_item_id) AS INVOICE_NO,
b.pay_date AS CHECK_DATE,
d.invoice_date AS INVOICE_DATE,
c.ledger_item_id AS CHECK_NO,
CONCAT (b.voucher_type, b.voucher_no) AS REFERENCE_NUMBER,
c.full_curr_amount AS CHECK_AMOUNT,
a.curr_amount AS INVOICE_AMOUNT,
c.rowstate AS STATE,
g.ACCOUNT AS ACCOUNT_NO,
e.VAT_CODE, e.VAT_CURR_AMOUNT, e.WHT_CODE, e.WHT_AMOUNT, e.NET_CURR_AMOUNT, e.NET_CURR_AMOUNT + e.VAT_CURR_AMOUNT AS GROSS_AMOUNT
FROM payment_transaction_tab a, payment_tab b, ledger_item_tab c, invoice_tab d, invoice_item_tab e, supplier_info_tab f, payment_address_tab g
WHERE b.payment_id = a.payment_id And c.payment_id = a.payment_id And d.invoice_no = a.ledger_item_id And d.identity = c.identity And e.invoice_id = d.invoice_id AND f.supplier_id = c.identity AND f.supplier_id = g.identity (+)
AND b.pay_date BETWEEN TO_DATE ('01/01/2017', 'mm/dd/yyyy')
AND TO_DATE ('01/31/2017', 'mm/dd/yyyy')
--AND c.cash_account = '" & checkbank & "'
AND b.series_id = 'SUPAY'
AND a.ledger_item_series_id = 'SI'
AND d.rowstate in ('PaidPosted', 'PartlyPaidPosted')
-- AND c.rowstate = 'Printed'
AND c.release_date is NULL
AND e.net_curr_amount + e.vat_curr_amount <> 0
AND c.payment_id = b.payment_id
AND f.supplier_id = d.identity
ORDER BY A.CHILD_TRANS_ID;

SELECT *
FROM payment_tab;

select *
from payment_transaction_tab;