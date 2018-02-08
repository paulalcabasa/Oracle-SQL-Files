select fu.user_name, fr.responsibility_name, furg.start_date, furg.end_date
from fnd_user_resp_groups_direct furg, fnd_user fu, fnd_responsibility_tl fr
where fu.user_name = :user_name
and furg.user_id = fu.user_id
and furg.responsibility_id = fr.responsibility_id
and fr.language = userenv('lang');

