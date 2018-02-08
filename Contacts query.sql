
SELECT site_use_id,
            LTRIM(MAX(SYS_CONNECT_BY_PATH(contact_person,'; '))
            KEEP (DENSE_RANK LAST ORDER BY curr),'; ') AS contacts
FROM   (SELECT  b.site_use_id,
                          (a2.person_first_name || ' ' || a2.person_middle_name || ' ' || a2.person_last_name) contact_person,
                          ROW_NUMBER() OVER (PARTITION BY b.site_use_id ORDER BY a2.person_first_name) AS curr,
                          ROW_NUMBER() OVER (PARTITION BY b.site_use_id ORDER BY a2.person_first_name) -1 AS prev
              FROM   hz_parties a,
                        hz_parties a2,
                        hz_customer_profiles b,
                        hz_cust_profile_classes c,
                        hz_cust_accounts d,
                        hz_cust_acct_sites_all e,
                        hz_party_sites f,
                        hz_cust_site_uses_all g,
                        hr_all_organization_units h,
                        hz_cust_profile_amts i,
                        hz_relationships j,
                        hz_cust_account_roles k
              WHERE  a.party_id = b.party_id
                        AND b.profile_class_id = c.profile_class_id
                        AND a.party_id = d.party_id
                        AND d.cust_account_id = e.cust_account_id
                        AND a.party_id = f.party_id
                        AND f.party_site_id = e.party_site_id
                        AND d.cust_account_id = b.cust_account_id
                        AND d.cust_account_id = e.cust_account_id
                        AND e.cust_acct_site_id = g.cust_acct_site_id
                        AND d.cust_account_id = b.cust_account_id
                        AND g.site_use_id = b.site_use_id
                        AND e.org_id = h.organization_id
                        AND b.cust_account_id = i.cust_account_id(+)
                        AND b.site_use_id = i.site_use_id(+)
                        AND  d.party_id  =  j.object_id
                        AND k.party_id = j.party_id
                        AND k.cust_acct_site_id = e.cust_acct_site_id
                        AND j.subject_id = a2.party_id(+)
                        AND k.role_type = 'CONTACT'
                        AND e.status = 'A'
                        AND k.current_role_state = 'A'
                        AND d.cust_account_id = 15089
                        and b.site_use_id = 9926
                
)
GROUP BY site_use_id
CONNECT BY prev = PRIOR curr AND site_use_id = PRIOR site_use_id
START WITH curr = 1;


 SELECT --d.cust_account_id, 
           --                     d.account_number,
             --                   d.account_name,
              --                  d.party_id, 
              --                  e.orig_system_reference, 
                                b.site_use_id,
              --                  c.name group_name,
              --                  i.overall_credit_limit,
              --                  a.party_number,
              --                  a.party_name,
              --                  a.jgzz_fiscal_code tin,
              --                  k.cust_acct_site_id,
              --                  a.address1 || ' ' || a.address2 || ' ' || a.country address,
                                WM_CONCAT(SUBSTR(a2.person_first_name, 1, 40) || " " || SUBSTR(a2.person_middle_name, 1, 40) || " " || SUBSTR(a2.person_last_name, 1, 50))
                              
                      FROM   hz_parties a,
                                hz_parties a2,
                                hz_customer_profiles b,
                                hz_cust_profile_classes c,
                                hz_cust_accounts d,
                                hz_cust_acct_sites_all e,
                                hz_party_sites f,
                                hz_cust_site_uses_all g,
                                hr_all_organization_units h,
                                hz_cust_profile_amts i,
                                hz_relationships j,
                                hz_cust_account_roles k
                      WHERE  a.party_id = b.party_id
                                AND b.profile_class_id = c.profile_class_id
                                AND a.party_id = d.party_id
                                AND d.cust_account_id = e.cust_account_id
                                AND a.party_id = f.party_id
                                AND f.party_site_id = e.party_site_id
                                AND d.cust_account_id = b.cust_account_id
                                AND d.cust_account_id = e.cust_account_id
                                AND e.cust_acct_site_id = g.cust_acct_site_id
                                AND d.cust_account_id = b.cust_account_id
                                AND g.site_use_id = b.site_use_id
                                AND e.org_id = h.organization_id
                                AND b.cust_account_id = i.cust_account_id(+)
                                AND b.site_use_id = i.site_use_id(+)
                                AND  d.party_id  =  j.object_id
                                AND k.party_id = j.party_id
                                AND k.cust_acct_site_id = e.cust_acct_site_id
                                AND j.subject_id = a2.party_id(+)
                                AND k.role_type = 'CONTACT'
                                AND e.status = 'A'
                                AND k.current_role_state = 'A'
                                AND d.cust_account_id = 15089
                                and b.site_use_id = 9926
                          group by b.site_use_id;
                          
                          
                          select release_name from apps.fnd_product_groups;
                          
                          
                          CREATE TABLE test_wm (

column_1 VARCHAR2(5),

column_2 VARCHAR2(20));



INSERT INTO test_wm VALUES (111, 'This');

INSERT INTO test_wm VALUES (111, 'is');

INSERT INTO test_wm VALUES (111, 'a');

INSERT INTO test_wm VALUES (111, 'test');

INSERT INTO test_wm VALUES (222, 'This is not');

SELECT * FROM test_wm;



SELECT column_1,
       LTRIM(MAX(SYS_CONNECT_BY_PATH(column_2,'; '))
       KEEP (DENSE_RANK LAST ORDER BY curr),'; ') AS elements
FROM   (SELECT column_1,
               column_2,
               ROW_NUMBER() OVER (PARTITION BY column_1 ORDER BY column_2) AS curr,
               ROW_NUMBER() OVER (PARTITION BY column_1 ORDER BY column_2) -1 AS prev
        FROM   test_wm)
GROUP BY column_1
CONNECT BY prev = PRIOR curr AND column_1 = PRIOR column_1
START WITH curr = 1;
