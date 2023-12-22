set search_path = company_database, public;

CREATE OR REPLACE FUNCTION prevent_concurrent_booking()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM company_database.room_booking rb
        WHERE rb.room_id = NEW.room_id
          AND rb.booking_date = NEW.booking_date
          AND (
            (NEW.start_booking BETWEEN rb.start_booking AND rb.end_booking)
            OR (NEW.end_booking BETWEEN rb.start_booking AND rb.end_booking)
            OR (NEW.start_booking <= rb.start_booking AND NEW.end_booking >= rb.end_booking)
          )
    ) THEN
        RAISE EXCEPTION 'Concurrent booking is not allowed for room % and date %',
            NEW.room_id, NEW.booking_date;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_concurrent_booking_trigger
BEFORE INSERT OR UPDATE
ON company_database.room_booking
FOR EACH ROW
EXECUTE FUNCTION prevent_concurrent_booking();

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
