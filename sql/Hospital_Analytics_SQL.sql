CREATE TABLE Patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    gender VARCHAR(10),
    date_of_birth DATE,
    age INT,
    blood_group VARCHAR(5),
    marital_status VARCHAR(20),
    race_ethnicity VARCHAR(30),
    residential_zone VARCHAR(20),
    socioeconomic_tier VARCHAR(20),
    primary_insurance_provider VARCHAR(50),
    insurance_policy_id VARCHAR(20),
    contact_phone VARCHAR(30),
    emergency_contact_phone VARCHAR(30),
    street_address VARCHAR(100),
    zip_code INT,
    baseline_bmi DECIMAL(5,2),
    smoker_status VARCHAR(20),
    baseline_charlson_comorbidity_index INT,
    registration_date DATE
)


CREATE TABLE Visits_Encounters (
    encounter_id VARCHAR(15) PRIMARY KEY,
    patient_id VARCHAR(10) NOT NULL,
    encounter_type VARCHAR(30),
    admission_datetime DATETIME,
    discharge_datetime DATETIME,
    length_of_stay_days DECIMAL(6,2),
    admission_urgency VARCHAR(30),
    department VARCHAR(50),
    attending_physician_id VARCHAR(15),
    icu_admitted INT,
    icu_days DECIMAL(5,2),
    discharge_disposition VARCHAR(50),
    news2_acuity_score INT,
    revisit_count INT,
    previous_encounter_id VARCHAR(15),
    days_since_last_discharge DECIMAL(6,2),
    readmission_30d INT,
    in_hospital_mortality INT,  
    CONSTRAINT FK_Visits_Patients FOREIGN KEY (patient_id) 
        REFERENCES Patients(patient_id)
)


CREATE TABLE Clinical_Details (
    clinical_record_id VARCHAR(15) PRIMARY KEY,
    encounter_id VARCHAR(15) NOT NULL,
    patient_id VARCHAR(10) NOT NULL,
    primary_diagnosis_code VARCHAR(10),
    primary_diagnosis_name VARCHAR(100),
    disease_category VARCHAR(50),
    disease_severity VARCHAR(20),
    secondary_diagnosis_code VARCHAR(10),
    systolic_bp_mmhg DECIMAL(6,2),
    diastolic_bp_mmhg DECIMAL(6,2),
    heart_rate_bpm DECIMAL(6,2),
    respiratory_rate_bpm DECIMAL(6,2),
    temperature_celsius DECIMAL(5,2),
    spo2_percent DECIMAL(5,2),
    blood_glucose_mg_dl DECIMAL(6,2),
    serum_creatinine_mg_dl DECIMAL(6,2),
    hemoglobin_g_dl DECIMAL(6,2),
    white_blood_cell_count DECIMAL(6,2),
    primary_procedure_code INT,
    primary_procedure_name VARCHAR(150),
    procedure_complexity VARCHAR(30),
    hospital_acquired_infection INT,
    CONSTRAINT FK_Clinical_Visits FOREIGN KEY (encounter_id) 
        REFERENCES Visits_Encounters(encounter_id)
)


CREATE TABLE Pharmacy_Prescriptions (
    pharmacy_order_id VARCHAR(15) PRIMARY KEY,
    encounter_id VARCHAR(15) NOT NULL,
    patient_id VARCHAR(10) NOT NULL,
    ndc_code VARCHAR(20),
    drug_name VARCHAR(100),
    therapeutic_class VARCHAR(50),
    dosage_form VARCHAR(50),
    dose_strength VARCHAR(30),
    administration_frequency VARCHAR(20),
    days_supply INT,
    quantity_dispensed INT,
    unit_cost_usd DECIMAL(10,2),
    total_drug_cost DECIMAL(10,2),
    insurance_covered_drug_cost DECIMAL(10,2),
    patient_copay_drug_cost DECIMAL(10,2),
    high_risk_medication_flag INT,
    CONSTRAINT FK_Pharmacy_Visits FOREIGN KEY (encounter_id) 
        REFERENCES Visits_Encounters(encounter_id)
)


CREATE TABLE Hospital_Billing (
    bill_id VARCHAR(15) PRIMARY KEY,
    encounter_id VARCHAR(15) NOT NULL,
    patient_id VARCHAR(10) NOT NULL,
    billing_date DATE,
    room_and_board_charges DECIMAL(12,2),
    physician_consultation_charges DECIMAL(12,2),
    procedure_surgical_charges DECIMAL(12,2),
    laboratory_diagnostic_charges DECIMAL(12,2),
    pharmacy_charges DECIMAL(12,2),
    gross_total_amount DECIMAL(12,2),
    discount_contractual_adjustment DECIMAL(12,2),
    insurance_covered_amount DECIMAL(12,2),
    patient_deductible_copay DECIMAL(12,2),
    patient_paid_amount DECIMAL(12,2),
    outstanding_balance DECIMAL(12,2),
    payment_status VARCHAR(30),
    claim_status VARCHAR(50),
    claim_denial_reason VARCHAR(100),
    CONSTRAINT FK_Billing_Visits FOREIGN KEY (encounter_id) 
        REFERENCES Visits_Encounters(encounter_id)
)


bulk insert Patients
from 'B:\Projects-DA\Hospital_Management_System\patients.csv'
with (
    format = 'csv',
    firstrow = 2,
    fieldterminator = ',',
    rowterminator = '\n'
    )

bulk insert Visits_Encounters
from 'B:\Projects-DA\Hospital_Management_System\visits_encounters.csv'
with (
    format = 'csv',
    firstrow = 2,
    fieldterminator = ',',
    rowterminator = '\n',
    tablock
    )



bulk insert Clinical_Details
from 'B:\Projects-DA\Hospital_Management_System\clinical_details.csv'
with (
    format = 'csv',
    firstrow = 2,
    fieldterminator = ',',
    rowterminator = '\n',
    tablock
    )


bulk insert Hospital_Billing
from 'B:\Projects-DA\Hospital_Management_System\hospital_billing.csv'
with (
    format = 'csv',
    firstrow = 2,
    fieldterminator = ',',
    rowterminator = '\n',
    tablock
    )



bulk insert Pharmacy_Prescriptions
from 'B:\Projects-DA\Hospital_Management_System\pharmacy_prescriptions.csv'
with (
    format = 'csv',
    firstrow = 2,
    fieldterminator = ',',
    rowterminator = '\n',
    tablock
    )


SELECT 'Patients' AS TableName, COUNT(*) AS TotalRows FROM Patients
UNION ALL
SELECT 'Visits_Encounters', COUNT(*) FROM Visits_Encounters
UNION ALL
SELECT 'Clinical_Details', COUNT(*) FROM Clinical_Details
UNION ALL
SELECT 'Hospital_Billing', COUNT(*) FROM Hospital_Billing
UNION ALL
SELECT 'Pharmacy_Prescriptions', COUNT(*) FROM Pharmacy_Prescriptions


SELECT TOP 5 
    p.patient_id, 
    p.first_name, 
    p.last_name, 
    v.encounter_id, 
    v.admission_datetime, 
    v.department
FROM Patients p
JOIN Visits_Encounters v ON p.patient_id = v.patient_id


select top(10)* from Patients

select 
    sum(case when first_name is null then 1 else 0 end) as Null_FirstNames
from Patients


select * from Visits_Encounters

select 
    department,
    count(encounter_id) as Total_Encounters,
    sum(readmission_30d) as Total_Readmission30d,
    rank() over (order by count(encounter_id)) as Department_Rank
from Visits_Encounters
group by department


select * from Hospital_Billing

select top(10) 
    patient_id,
    sum(gross_total_amount) as Patient_Total_Charges,
    avg(sum(gross_total_amount)) over() as Hospital_Average_Charges
from Hospital_Billing
group by patient_id
order by Patient_Total_Charges desc


create or alter view vw_hospital_summary as
select
    v.encounter_id,
    v.patient_id,
    p.first_name + ' ' + p.last_name AS patient_name,
    p.gender,
    p.age,
    p.primary_insurance_provider,
    v.encounter_type,
    v.admission_urgency,
    v.admission_datetime,
    v.discharge_datetime,
    v.length_of_stay_days,
    v.department,
    v.icu_admitted,                 
    v.icu_days,                      
    v.readmission_30d,                 
    v.in_hospital_mortality,
    h.gross_total_amount,
    h.insurance_covered_amount,
    h.patient_paid_amount,
    h.outstanding_balance,
    h.payment_status,
    h.claim_status,
    h.claim_denial_reason
from Visits_Encounters V inner join Patients P
on V.patient_id = P.patient_id
left join Hospital_Billing H 
on V.encounter_id = H.encounter_id

select * from vw_hospital_summary


create or alter view vw_pharmacy_cost as
select
    pharmacy_order_id,
    encounter_id,
    patient_id,
    drug_name,
    therapeutic_class,
    dosage_form,
    days_supply,
    quantity_dispensed,
    total_drug_cost,
    insurance_covered_drug_cost,
    patient_copay_drug_cost,
    high_risk_medication_flag
from Pharmacy_Prescriptions

select * from vw_pharmacy_cost

