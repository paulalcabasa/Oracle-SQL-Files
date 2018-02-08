select *
from fnd_sequences
where creation_date >= '01-JAN-2010';

select *
from fnd_sequences;

SELECT *
FROM FND_DOC_SEQ_274_S;
select fdsa.doc_sequence_assignment_id,
         fdsa.application_id,
         fds.doc_sequence_id,
         fdsa.category_code,
         fds.name,
         fds.db_sequence_name,
         fds.initial_value
from FND_DOC_SEQUENCE_ASSIGNMENTS fdsa,
        FND_DOCUMENT_SEQUENCES fds
where 1 = 1
          AND fdsa.doc_sequence_id = fds.doc_sequence_id
          AND fds.name LIKE 'IPC%';
          
select *
from FND_DOCUMENT_SEQUENCES
-- where name = 'IPC JV Accrual';
 where name = 'IPC JV Receipts';
-- 282
update FND_DOCUMENT_SEQUENCES
set initial_value = 80000001
where doc_sequence_id = 274;
commit;

select *
from GL_DOC_SEQUENCE_AUDIT
where doc_sequence_id =273;