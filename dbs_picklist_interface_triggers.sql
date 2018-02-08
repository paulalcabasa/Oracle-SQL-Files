CREATE OR REPLACE TRIGGER dbs_after_insert AFTER INSERT ON MTL_TXN_REQUEST_HEADERS
FOR EACH ROW
BEGIN
    INSERT INTO dbs_picklist_interface (
        picklist_id,
        header_id ,
        request_number ,
        header_status ,
        organization_id ,
        move_order_type  ,
        transaction_type_id ,
        status_date ,
        creation_date  
    )
    values(
        dbs_picklist_interface_seq.nextval,
        :new.header_id,
        :new.request_number,
        :new.header_status,
        :new.organization_id,
        :new.move_order_type,
        :new.transaction_type_id,
        :new.status_date,
        :new.creation_date
    );
END;



CREATE OR REPLACE TRIGGER dbs_after_delete 
    AFTER DELETE 
    ON MTL_TXN_REQUEST_HEADERS
    FOR EACH ROW
BEGIN
        DELETE FROM dbs_picklist_interface
        WHERE header_id = :old.header_id;
    END;