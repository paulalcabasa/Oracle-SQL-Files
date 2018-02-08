-- AP XLA QUERY

select *
from (SELECT    
            distinct
            -- INVOICE
            aia.invoice_id,
            aia.doc_sequence_value,
            xah.accounting_date voucher_date,
            nvl(nvl(aps.segment1,aps2.segment1),hp.party_number) vendor_id,
            nvl(aps.vendor_name,hp.party_name) vendor_name,
            aia.payment_currency_code,
            aia.exchange_rate,
            aia.invoice_num,
            aia.invoice_amount,
            aila.line_number,
             
           -- ACCOUNTING ENTRIES
            xal.ae_line_num,
            to_char(glcc.segment6) account_no,
            DECODE(glcc.segment6,'-',
                              glcc.segment6,
                              gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,6,segment6)) account_name,
            glcc.segment2 cost_center,
            /*   Removed by Paul
                   Date:  August 2, 2017 11:30 am
                   Requested by Ms. Grace
           
            DECODE(glcc.segment2,'-',
                            glcc.segment2,
                            gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,2,glcc.segment2)) cost_center,
            */
            max(aila.tax_classification_code) tax,
            max(awt.name) wtax,
            null model, 
          glcc.segment4 budget_account,
          /*     Removed by Paul
                   Date:  August 2, 2017 11:30 am
                   Requested by Ms. Grace
           DECODE(glcc.segment4,'-',
                          glcc.segment4,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,4,glcc.segment4)) budget_acount,  
            */
            
            glcc.segment5 budget_cost_center,
            /*    Removed by Paul
                   Date:  August 2, 2017 11:30 am
                   Requested by Ms. Grace
            DECODE(glcc.segment5,'-',
                          glcc.segment5,
                          gl_flexfields_pkg.get_description_sql(glcc.chart_of_accounts_id,5,glcc.segment5)) budget_cost_center,                
            */
            xal.entered_dr,
            xal.entered_cr,
            substr(xal.description,1,55) description
FROM   
        xla.xla_ae_headers xah 
        INNER JOIN xla.xla_ae_lines xal
            ON  xah.ae_header_id = xal.ae_header_id 
            AND xal.application_id = xah.application_id
        INNER JOIN apps.gl_code_combinations glcc
            ON xal.code_combination_id = glcc.code_combination_id
        INNER  JOIN xla.xla_transaction_entities xte
            ON xah.entity_id = xte.entity_id
            AND xte.application_id = xal.application_id
        INNER JOIN xla_distribution_links xdl
            ON xah.ae_header_id = xdl.ae_header_id
            and xdl.event_id = xah.event_id
            and xdl.ae_line_num = xal.ae_line_num
            and xdl.application_id = xah.application_id
        INNER JOIN ap_invoice_distributions_all aida
            ON xdl.source_distribution_id_num_1 = aida.invoice_distribution_id
        INNER JOIN ap_invoices_all aia
            ON  aia.invoice_id = aida.invoice_id
        INNER JOIN ap_invoice_lines_all aila
            ON aila.invoice_id = aia.invoice_id
            and aila.line_number = aida.invoice_line_number 
        LEFT JOIN ap_awt_groups awt
            ON aila.awt_group_id = awt.group_id   
        LEFT JOIN ap_suppliers aps
            ON aps.vendor_id = aia.vendor_id
        LEFT JOIN hz_parties hp
            ON hp.party_id = aia.party_id
        LEFT JOIN ap_suppliers aps2
            ON aps2.party_id = hp.party_id
            
WHERE 1 = 1
            AND xte.entity_code = 'AP_INVOICES' 
            AND xdl.source_distribution_type = 'AP_INV_DIST'
--            and aia.gl_date between '01-SEP-2017' AND '10-SEP-2017'
           and aia.doc_sequence_value between :p_start_voucher and :p_end_voucher
            and glcc.segment6 = '67000'
group by 
            xal.ae_line_num,
            aila.line_number,
            aia.invoice_id,
            aia.invoice_num,
            aia.doc_sequence_value,
            glcc.segment6,
            xal.entered_dr ,
            aps.segment1,
            aps2.segment1,
            hp.party_name,
            xal.entered_cr ,
            glcc.chart_of_accounts_id,
            glcc.segment2,
            glcc.segment7,
            glcc.segment4,
            glcc.segment5,
            hp.party_number,
            xal.description,
            xah.ae_header_id,
            aia.vendor_id,
            aps.vendor_name,
            aia.payment_currency_code,
            aia.exchange_rate,
            aia.invoice_amount,
            xah.accounting_date
having nvl(xal.entered_cr,0) - nvl(xal.entered_dr,0) <> 0);

-- DFF AP QUERY

select
        aia.doc_sequence_value,
        aia.invoice_id,
        aila.line_number, 
        aila.attribute1 Sup_ID, 
        case when AILA.ATTRIBUTE1 is null then null
                else
                    case when AILA.ATTRIBUTE2 is null then
                          aps.vendor_name
                         else
                          AILA.ATTRIBUTE2
                    end
        end  DFF_SUP_NAME,
        case when AILA.ATTRIBUTE1 is null then null
        else
            case when AILA.ATTRIBUTE3 is null then
                   aps.vat_registration_num
                 --assa.vat_registration_num
                 else AILA.ATTRIBUTE3
            end 
        end DFF_TIN,
        case when AILA.ATTRIBUTE1 is null then
        null
        else
            case when AILA.ATTRIBUTE4 is null then
                   ASSA.ADDRESS_LINE1 || ' ' || ASSA.ADDRESS_LINE2
                 else AILA.ATTRIBUTE4
            end 
        END    DFF_ADDRESS,
       case when aila.tax_classification_code in ('V2(S)','V2(OCG)','V2(IMP)') THEN 
               round((aila.amount)/ 1.12, 2)
               else aila.amount
       end amount,
       aila.tax_classification_code vat_code,
       case when aila.tax_classification_code in ('V2(S)','V2(OCG)','V2(IMP)') THEN 
               round(((aila.amount)/ 1.12)* 0.12, 2)
               when aila.tax_classification_code IN ('V0(VE)') THEN 0
               ELSE round(aila.amount * 0.12, 2)
       end vat_amount,
       awt.name invoice_witholding_tax_group,
       case when aila.tax_classification_code in ('V2(S)','V2(OCG)','V2(IMP)') THEN 
               round(((aila.amount)/ 1.12)* (awtra.tax_rate / 100), 2)
               else
            round(aila.amount * (awtra.tax_rate / 100), 2)
       end w_amount
from ap_invoice_lines_all aila
        INNER JOIN ap_invoices_all aia
            ON aila.invoice_id = aia.invoice_id
        INNER JOIN ap_awt_groups awt
            ON awt.group_id = aila.awt_group_id
        LEFT JOIN ap_suppliers aps
            ON aps.segment1 = aila.attribute1
        LEFT JOIN ap_supplier_sites_all assa
            ON aps.vendor_id = assa.vendor_id
        LEFT JOIN ap_awt_tax_rates_all awtra
            ON awt.name = awtra.tax_name
where 1 = 1
        and aila.attribute1 is not null
        and aila.tax_classification_code IN ('V2(S)')
        and aia.doc_sequence_value = :DOC_SEQUENCE_VALUE
;

select *
from ar_payment_schedules_all
where trx_number = '40300013271';
SELECT aia.doc_sequence_value,
            aila.line_number,
            aida.distribution_line_number,
             aia.gl_date,
             gcc.segment6 account,
             aida.amount vat_amount,
             aps.segment1 supplier_id,
             aps.vendor_name supplier_name,
             aida.description,
             aila.tax_classification_code tax_code,
             aia.invoice_num,
             aps_third_party.segment1 third_party_supplier_id,
             aps_third_party.vendor_name third_party_supplier,
             cbb.bank_name,
             aca.check_date,
             aca.check_number,
             aipa.amount payment_amount,
             TO_CHAR(aca.treasury_pay_date,'MM/DD/YYYY') release_date,
             ipc_or.or_number or_no,
             TO_CHAR(ipc_or.or_date,'MM/DD/YYYY') or_date,
             TO_CHAR(ipc_or.date_created,'MM/DD/YYYY') entry_date,
             null application_period,
             aida.distributi
FROM ap_invoice_lines_all aila
           INNER JOIN ap_invoice_distributions_all aida 
               ON aida.invoice_id = aila.invoice_id
               AND aida.invoice_line_number = aila.line_number
           INNER JOIN ap_invoices_all aia
               ON aia.invoice_id = aila.invoice_id
           INNER JOIN gl_code_combinations gcc
               ON gcc.code_combination_id = aida.dist_code_combination_id
           INNER JOIN ap_suppliers aps_third_party
               ON aps_third_party.segment1 = aila.attribute1
           INNER JOIN ap_suppliers aps
                ON aps.vendor_id = aia.vendor_id
           LEFT JOIN ap_invoice_payments_all aipa
                ON aipa.invoice_id = aia.invoice_id
           LEFT JOIN (SELECT * FROM ap_checks_all WHERE status_lookup_code <> 'VOIDED') aca
                ON aca.check_id = aipa.check_id
           LEFT JOIN ce_payment_documents cpb
                ON cpb.payment_document_id = aca.payment_document_id
           LEFT JOIN ce_bank_acct_uses_all cbaua
                ON aca.ce_bank_acct_use_id = cbaua.bank_acct_use_id
           LEFT JOIN ce_bank_accounts cba
                ON cba.bank_account_id = cbaua.bank_account_id
           LEFT JOIN ce_bank_branches_v cbb
                ON cbb.bank_party_id = cba.bank_id
           LEFT JOIN ipc.ipc_ppr_or_details ipc_or
                ON ipc_or.ap_check_id = aca.check_id
where  1 = 1
--         and aila.invoice_id = 1372832
--         and aia.invoice_num = '22804A'
            and gcc.segment6 = '67000'
            and aila.tax_classification_code = 'V2(S)'
            and aila.attribute1 is not null
            and aia.cancelled_date IS NULL
            and aia.attribute1 is not null
--           and aia.gl_date between :p_start_date and :p_end_date
--            and aia.doc_sequence_value = '20041581'
            and aila.org_id = 82;

select *
from ap_invoice_lines_all;

select *
from ap_invoice_distributions_all;

select *
from ap_invoice_payments_all;

select *
from ap_checks_all;

select *
from ap_invoices_all;
-- 17053
select invoice_num
from ap_invoice_lines_all aila,
         ap_invoices_all aia
where 1 = 1
            and aila.invoice_id = aia.invoice_id
--            and tax_classification_code = 'V2(S)'
            and aila.default_dist_ccid = 17053
--            and aila.attribute1 is null
            and aia.INVOICE_TYPE_LOOKUP_CODE = 'STANDARD';
            
            SELECT doc_sequence_value, ATTRIBUTE1
            FROM AP_INVOICES;