select mpt.mixed_payment_id,
         mpt.statement_no,
         TO_CHAR(mpt.mixed_payment_date) payment_date,
         mpt.voucher_no_ref,
         mpt.voucher_date_ref,
         mpt.voucher_type_ref,
         mpt.voucher_text,
         mpt.currency,
         mpt.short_name,
         mpt.rowstate,
         mpt_lines.lump_sum_trans_no,
         mpt_lines.curr_amount,
         mpt_lines.dom_amount,
         mpt_lines.cash_acc_amount,
         mpt_lines.text,
         mpt_lines.currency,
         mpt_lines.code_a,
         mpt_lines.code_b
from mixed_payment_tab mpt,
        MIXED_PAYMENT_LUMP_SUM mpt_lines
where 1 = 1
          and mpt.rowstate = 'Approved'
          and mpt_lines.mixed_payment_id = mpt.mixed_payment_id(+)
          and mpt.mixed_payment_date BETWEEN '01-MAY-2017' AND '31-MAY-2017'
ORDER BY mpt.mixed_payment_date asc;

select *
from mixed_payment_lump_sum_tab
where mixed_payment_id = 30069;

select *
from IFSAPP.MIXED_PAYMENT_LUMP_SUM;

select *
from IFSAPP.MIXED_PAYMENT_LUMP_SUM;



SELECT *
FROM payment_transaction_tab
where payment_id = 30089; 

select    invoice.invoice_no,
            invoice.due_date,
            invoice.state,
            invoice.invoice_date,
            invoice.arrival_date,
            payment.due_date,
            payment.curr_amount,
            payment.curr_rate,
            payment.curr_code
from IFSAPP.MAN_SUPP_INVOICE invoice,
        IFSAPP.MAN_SUPP_INVOICE_PLAN payment
where 1 = 1
          and invoice.invoice_id = payment.invoice_id (+)
          and invoice.invoice_no IN ('TEI-MAR17-008',
'IMI16BA021',
'B1709044',
'IMI16BC182A',
'INVC17005',
'IBCT1701-0042',
'B1709029B',
'IMI16BB177-5 A',
'IMI16BB192-2 A',
'IMI16BB192-3 A',
'IMI16BK315',
'IMI16BB242-4',
'IMI16BB192-5',
'IMI16BB242-2',
'IMI16BB242-3A',
'IMI16BB192-4',
'IMI16BB242-1',
'IMI16BB143-8',
'IMI17AK019',
'IMI16BC199',
'IMI16BK314',
'IMI17AC003',
'IMI17AK043',
'IMI17AA001',
'IMI17AK020',
'IMITDN17038',
'IMI17AK044',
'IBCT1702-0003',
'B1710052',
'IMI16BB242-4A',
'IMI16BB242-7',
'IMI17AB018-2',
'IMI16BB242-6',
'IMI17AB018-1',
'IBCT1701-0007',
'B1710032',
'IMI17AK045',
'IMI16BB242-5',
'IMI17AB018-1(A)',
'IMI17AK046',
'IMI17AB072-2',
'IMI17AK085 A',
'IMI17AK086',
'IMI17AB072-3-A',
'IMI16BB242-6(B)',
'IMI17AB018-1(B)',
'B1711130',
'IMI17AA010',
'IMI17AB018-5',
'IMI17AB072-4',
'IMI17AB072-5',
'IBCT1703-0004',
'B1711130A',
'IBCT1703-0004A',
'IMI17AB072-3(B)',
'IMI17AB072-4(B)',
'IMI17AB018-3-A',
'IMI17AB018-2 B',
'IMI17AK087-A',
'IMI17AK088-A',
'IMI17AB018-4-A',
'IMI17AB072-1-A',
'IMI16BB242-7 D',
'IMI17AC053-A',
'IMI16BB242-6(C)',
'IMCT-DBN17-SP-00024',
'TEI-IPC-01-17',
'IMI17AB072-3(C)',
'B1801029',
'IMI17AK117-A',
'IMI17AB072-7-A',
'IMI17AK118-A',
'B1712068',
'IMI17AB072-5(D)',
'IMI17AK115-A',
'IMI17AB176-1-a',
'MI17AB072-6-A',
'IMI17AB176-2 A',
'IBCT1704-0001-A',
'IMI17AK116-A',
'IMI17AB176-3',
'IMI17AK119',
'B1712068-A',
'B1712116-A',
'B1801031',
'IMCT-DBN17-SP-00093',
'IMI17AB072-4(D)',
'IMI17AB018-5(B)',
'IMI17AC102',
'IMCT-DBN17-SP-00093A');

SELECT due_date,
            curr_amount,
            curr_rate,
            curr_code
FROM IFSAPP.MAN_SUPP_INVOICE_PLAN
WHERE INVOICE_ID = 1000086;

select invoice_no,
         due_date,
         state,
         invoice_date,
         arrival_date
from IFSAPP.MAN_SUPP_INVOICE
WHERE INVOICE_NO LIKE '%IMI16BB177-5%';