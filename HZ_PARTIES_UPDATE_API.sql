DECLARE
   l_person_rec_type     hz_party_v2pub.person_rec_type;
   l_party_rec           hz_party_v2pub.party_rec_type;
   l_party_obj_version   NUMBER                         := 1;
   x_profile_id          NUMBER;
   x_return_status       VARCHAR2 (1);
   x_msg_count           NUMBER;
   x_msg_data            VARCHAR2 (4000);
BEGIN
   l_party_rec.party_id := 1154460;
   l_party_rec.status := 'A';
   l_person_rec_type.person_first_name := 'Sam';
   l_person_rec_type.person_last_name := 'Ku';
   l_person_rec_type.party_rec := l_party_rec;
   hz_party_v2pub.update_person
                       (p_init_msg_list                    => fnd_api.g_true,
                        p_person_rec                       => l_person_rec_type,
                        p_party_object_version_number      => l_party_obj_version,
                        x_profile_id                       => x_profile_id,
                        x_return_status                    => x_return_status,
                        x_msg_count                        => x_msg_count,
                        x_msg_data                         => x_msg_data
                       );
   DBMS_OUTPUT.put_line ('API Status: ' || x_return_status);

   IF (x_return_status <> 'S')
   THEN
      DBMS_OUTPUT.put_line ('ERROR :' || x_msg_data);
   END IF;

   DBMS_OUTPUT.put_line ('update_person is completed');
--COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Error::::' || SQLERRM);
      ROLLBACK;
END;