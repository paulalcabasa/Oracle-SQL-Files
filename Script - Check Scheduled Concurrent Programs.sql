select *
from (select  r.request_id,
            p.user_concurrent_program_name || nvl2(r.description,' ('||r.description||')',null) Conc_prog,
            s.user_name REQUESTOR,
            s.description requestor_name,
            r.argument_text arguments,
            TO_CHAR(r.requested_start_date,'MM/DD/YYYY HH24:MI:SS') next_run,
            r.last_update_date LAST_RUN,
            r.hold_flag on_hold,
            r.increment_dates,
            decode(c.class_type,
                        'P', 'Periodic',
                        'S', 'On Specific Days',
                        'X', 'Advanced',
                        c.class_type
            ) schedule_type,
            case
                when c.class_type = 'P' then
                'Repeat every ' ||
                substr(c.class_info, 1, instr(c.class_info, ':') - 1) ||
                decode(substr(c.class_info, instr(c.class_info, ':', 1, 1) + 1, 1),
                    'N', ' minutes',
                     'M', ' months',
                    'H', ' hours',
                    'D', ' days') ||
                decode(substr(c.class_info, instr(c.class_info, ':', 1, 2) + 1, 1),
                    'S', ' from the start of the prior run',
                    'C', ' from the completion of the prior run')
                when c.class_type = 'S' then
                 nvl2(dates.dates, 'Dates: ' || dates.dates || '. ', null) ||
                decode(substr(c.class_info, 32, 1), '1', 'Last day of month ') ||
                decode(sign(to_number(substr(c.class_info, 33))),
                '1', 'Days of week: ' ||
            decode(substr(c.class_info, 33, 1), '1', 'Su ') ||
            decode(substr(c.class_info, 34, 1), '1', 'Mo ') ||
            decode(substr(c.class_info, 35, 1), '1', 'Tu ') ||
            decode(substr(c.class_info, 36, 1), '1', 'We ') ||
            decode(substr(c.class_info, 37, 1), '1', 'Th ') ||
            decode(substr(c.class_info, 38, 1), '1', 'Fr ') ||
            decode(substr(c.class_info, 39, 1), '1', 'Sa '))
            end as schedule,
            c.date1 start_date,
            c.date2 end_date,
            c.class_info
from fnd_concurrent_requests r,
        fnd_conc_release_classes c,
        fnd_concurrent_programs_tl p,
        fnd_user s,
        (with date_schedules as (
            select release_class_id,
            rank() over(partition by release_class_id order by s) a, s
            from (select c.class_info, l,
                        c.release_class_id,
                        decode(substr(c.class_info, l, 1), '1', to_char(l)) s
                        from (select level l from dual connect by level <= 31),
                        fnd_conc_release_classes c
            where c.class_type = 'S'
                and instr(substr(c.class_info, 1, 31), '1') > 0)
                where s is not null)
SELECT release_class_id, substr(max(SYS_CONNECT_BY_PATH(s, ' ')), 2) dates
FROM date_schedules
START WITH a = 1
CONNECT BY nocycle PRIOR a = a - 1
group by release_class_id) dates
where r.phase_code = 'C'
and r.status_Code  IN ('R','I','C')
and c.application_id = r.release_class_app_id
and s.user_name = '161124'
and c.release_class_id = r.release_class_id
and nvl(c.date2, sysdate + 1) > sysdate
and c.class_type is not null
and p.concurrent_program_id = r.concurrent_program_id
and p.language = 'US'
and dates.release_class_id(+) = r.release_class_id
and r.requested_by = s.user_id
order by s.user_name, conc_prog, on_hold, next_run); 


select *
from fnd_user
where user_name = '161124';

select fcr.request_id,
            fcp.user_concurrent_program_name || nvl2(fcr.description,' ('||fcr.description||')',null) Conc_prog,
           fcr.phase_code,
           fcr.status_code,
          TO_CHAR(fcr.request_date,'MM/DD/YYYY HH24:MI:SS') request_date,
           TO_CHAR(fcr.requested_start_date,'MM/DD/YYYY HH24:MI:SS') run_date
from fnd_concurrent_requests fcr
        LEFT JOIN fnd_concurrent_programs_tl fcp
            ON  fcr.concurrent_program_id = fcp.concurrent_program_id
where fcr.requested_by = 1776
            and TRUNC(fcr.requested_start_date) BETWEEN '05-JAN-2018' AND '06-JAN-2018'
            ;