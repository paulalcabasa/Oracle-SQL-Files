select *
from gl_period_statuses
where period_name = 'AUG-17'
           and ledger_id = 2021;
           
select et.source_id_int_1, et.entity_code, et.entity_id,
ev.event_id, ev.entity_id, ev.event_type_code,
ev.event_status_code, ev.event_date,
et.SECURITY_ID_INT_1, et.ledger_id, et.transaction_number, ev.creation_date
from XLA.XLA_TRANSACTION_ENTITIES et,
XLA.XLA_EVENTS ev
where ev.event_date between to_date('&start_date', 'dd-mon-yyyy') AND to_date('&end_date', 'dd-mon-yyyy')
and ev.event_status_code not in ('P','N')
and ev.application_id = 200
and et.entity_id = ev.entity_id; 

-- C2
select * from xla.xla_ae_headers
where accounting_date BETWEEN to_date('&start_date', 'dd-mon-yyyy') AND to_date('&end_date', 'dd-mon-yyyy')
and gl_transfer_status_code <> 'Y'
and application_id = 200; 


-- C3

Select et.source_id_int_1, et.entity_code, et.entity_id,
ev.event_id, ev.entity_id, ev.event_type_code,
ev.event_status_code, ev.event_date,
et.SECURITY_ID_INT_1, et.ledger_id, et.transaction_number
From XLA.XLA_TRANSACTION_ENTITIES et,
XLA.XLA_EVENTS ev
Where ev.application_id = 200
And ev.event_id in (&eventid)
And et.entity_id = ev.entity_id; 

select *
from ap_checks_all
where check_number = '73';