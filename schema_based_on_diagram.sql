--Create Patients Table
CREATE TABLE patients (
    id INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL
);
ALTER TABLE
    patients ADD PRIMARY KEY(id);
-- Create medical history table
CREATE TABLE medical_histories (
    id INTEGER NOT NULL,
    admitted_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    patient_id INTEGER NOT NULL,
    status VARCHAR(255) NOT NULL,
    CONSTRAINT fk_patient
    FOREIGN KEY(patient_id)
    REFERENCES patients(id)
);
ALTER TABLE
    medical_histories ADD PRIMARY KEY(id);
--Create treatment table
CREATE TABLE treatments (
    id INTEGER NOT NULL,
    type VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL

);
ALTER TABLE
    treatments ADD PRIMARY KEY(id);
-- Create invoice table
CREATE TABLE invoices (
    id INTEGER NOT NULL,
    total_amount DECIMAL(8, 2) NOT NULL,
    generated_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    payed_at TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    medical_history__id INTEGER NOT NULL
    CONSTRAINT fk_medical_history
    FOREIGN KEY (medical_history_id) 
    REFERENCES medical_histories(id)
);
ALTER TABLE
    invoices ADD PRIMARY KEY(id);
-- Create invoice_items Table
CREATE TABLE invoice_items (
    id INTEGER NOT NULL,
    unit_price DECIMAL(8, 2) NOT NULL,
    quantity INTEGER NOT NULL,
    total_price DECIMAL(8, 2) NOT NULL,
    invoice_id INTEGER NOT NULL,
    treatment_id INTEGER NOT NULL
    CONSTRAINT fk_invoice 
    FOREIGN KEY (invoice_id) 
    REFERENCES invoices(id),
    CONSTRAINT fk_treatment 
    FOREIGN KEY (treatment_id) 
    REFERENCES treatments(id)
);


ALTER TABLE
    invoice_items ADD PRIMARY KEY(id);
ALTER TABLE
    medical_histories ADD CONSTRAINT medical_histories_patient_id_foreign FOREIGN KEY(patient_id) REFERENCES patients(id);
ALTER TABLE
    invoice_items ADD CONSTRAINT invoice_items_invoice_id_foreign FOREIGN KEY(invoice_id) REFERENCES invoices(id);
ALTER TABLE
    invoices ADD CONSTRAINT invoices_medical_history__id_foreign FOREIGN KEY(medical_history__id) REFERENCES medical_histories(id);
ALTER TABLE
    invoice_items ADD CONSTRAINT invoice_items_treatment_id_foreign FOREIGN KEY(treatment_id) REFERENCES treatments(id);

--Indexes 
CREATE INDEX patient_id_index ON medical_histories(patient_id);
CREATE INDEX medical_id_index ON invoices(medical_history_id);
CREATE INDEX invoice_id_index ON invoice_items(invoice_id);
CREATE INDEX treat_id_index ON invoice_items(treatment_id);
