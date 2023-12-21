set search_path = company_database, public;

CREATE OR REPLACE FUNCTION after_insert_employee()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO company_database.employee_versions (
        employee_id, position_id, first_name, second_name, birth_date,
        phone_number, salary, load, valid_from, valid_to
    ) VALUES (
        NEW.employee_id, NEW.position_id, NEW.first_name, NEW.second_name, NEW.birth_date,
        NEW.phone_number, NEW.salary, NEW.load, CURRENT_TIMESTAMP, '9999-01-01'
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_insert_employee_trigger
AFTER INSERT ON company_database.employee
FOR EACH ROW EXECUTE FUNCTION after_insert_employee();

CREATE OR REPLACE FUNCTION before_update_employee_is_active()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_active IS DISTINCT FROM OLD.is_active AND NEW.is_active = false THEN
        UPDATE pass
        SET is_valid = false
        WHERE employee_id = OLD.employee_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_update_employee_is_active_trigger
BEFORE UPDATE ON employee
FOR EACH ROW EXECUTE FUNCTION before_update_employee_is_active();
