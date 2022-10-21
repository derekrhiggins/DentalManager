-- |========================================================================
-- addAppointments.sql
-- Add appointments for patients

-- SPECIFY THE DETAILS HERE:

SET @treatment = '1';
SET @patientID = '7';
SET @DATE = '2022-05-11';
SET @TIME = '10:00:00';
SET @staffID = '1';


INSERT INTO `dentalman`.`appointments` (

	`PatientID`,
	`Date`,
	`Time`,
	`TreatmentID`,
	`StaffID`,
	`Cost`
	) 

VALUES (
	@patientID,				-- PatientID
	@DATE,	-- Date
	@TIME,		-- Time
	@treatment,		-- TreatmentID
	@staffID, 				-- StaffID
	(SELECT treatments.cost FROM treatments WHERE treatments.treatmentID=@treatment) -- LOOKUP FOR TREATMENT COST
);


-- |========================================================================
-- addPatient.sql
-- Add a new patient

INSERT INTO patients (NAME) VALUES ('Bruce');


-- |========================================================================
-- addReferral.sql
-- Create a referral for a patient using the PatientID and the specialistID to be referred to

INSERT INTO referrals (patientID, specialistID, DATE) VALUES ('1', '1', SYSDATE());


-- |========================================================================
-- addStaff.sql

INSERT INTO staff (NAME, RoleID) VALUES ('Mark', '1');


-- |========================================================================
-- addTreatment.sql

INSERT INTO `treatments` (`title`, `description`, `cost`) VALUES ('Veneer', 'Veneer treatment to tooth', '5000');



-- |========================================================================
-- amendAppointment.sql
-- Amend an appointment time


UPDATE appointments

SET DATE = '2022-05-26', TIME='11:00' -- CHANGE TO THIS APPOINTMENT DATE AND TIME

WHERE PatientID = '9' AND DATE = '2022-05-25' AND TIME='10:00'; -- FOR THIS PATIENTS APPOINTMENT AT DATE AND TIME


-- |========================================================================
-- cancelAppointment.sql

-- Cancel Appointment

SET @patientID = '9';
SET @DATE = '2022-05-26';
SET @TIME = '11:00:00';


UPDATE appointments

SET cancelled = '1' 

WHERE patientID=@patientID AND DATE = @DATE AND TIME = @TIME;


UPDATE patients

SET patients.outstandingBalance = (patients.outstandingBalance + (SELECT treatments.cost FROM treatments, appointments 

				WHERE appointments.patientID = @patientID AND appointments.DATE = @DATE 
				AND appointments.TIME = @TIME AND appointments.TreatmentID = treatments.treatmentID
															))
															
WHERE patients.PatientID = @patientID; 


-- |========================================================================
-- checkedIn.sql
-- Mark a patient as CheckedIn


SET @patientID = '6';
SET @DATE = '2022-05-03';
SET @TIME = '16:00:00';


UPDATE appointments

SET checkedIn = '1' 

WHERE patientID=@patientID AND DATE = @DATE AND TIME = @TIME;


-- |========================================================================
-- generateBills.sql
-- Generate Bills from appointments marked as unpaid and checkedIn


SELECT 	

	-- VALUES TO SHOW IN QUERY
	appointments.PatientID, -- ID
	patients.Name,
	patients.address, 			

	-- Amount Due
	
	SUM(appointments.Cost) +patients.outstandingBalance
	
			
	FROM appointments JOIN patients
	ON appointments.PatientID=patients.PatientID
	
	WHERE appointments.Billed='0' AND appointments.checkedIn='1'
	
	GROUP BY PatientID;
	

-- |========================================================================
-- listAppointments.sql
-- SHOW THE APPOINTMENTS ON A CERTAIN DATE RANGE

SELECT 	

	-- VALUES TO SHOW IN QUERY
	appointments.PatientID, -- ID
	patients.Name, 			-- Name
	`treatments`.title,		-- Treatment Title
	appointments.`Date`,		-- Appointment Date
	appointments.`Time`,		-- Appointment Time
	treatments.duration		-- Treatment Duration
			
	FROM appointments, treatments, patients
	WHERE appointments.TreatmentID=treatments.treatmentID AND appointments.PatientID=patients.PatientID
	
	-- APPOINTMENT SEARCH CAN BE NARROWED TO A CERTAIN DATE RANGE
	AND appointments.`Date`BETWEEN '2022-04-25' AND '2022-04-27';


-- |========================================================================
-- nextWeekAppointments.sql
-- SHOW THE APPOINTMENTS FOR NEXT WEEK

SELECT 	

	-- VALUES TO SHOW IN QUERY
	nextweek.PatientID, -- ID
	patients.Name, 			-- Name
	`treatments`.title,		-- Treatment Title
	nextweek.`Date`,		-- Appointment Date
	nextweek.`Time`,		-- Appointment Time
	treatments.duration		-- Treatment Duration
			
	FROM nextweek, treatments, patients
	WHERE nextweek.TreatmentID=treatments.treatmentID AND nextWeek.PatientID=patients.PatientID;


-- |========================================================================
-- listReferrals.sql
-- List Referrals

SELECT referrals.patientID, patients.Name, referrals.specialistID, specialists.name, referrals.date, referrals.reportID  FROM referrals, patients, specialists

WHERE referrals.patientID = patients.PatientID AND referrals.specialistID = specialists.specialistID;


-- |========================================================================
-- listSpecialists.sql
-- LIST specialists

SELECT * FROM specialists;


-- |========================================================================
-- searchPatients.sql
-- Search Patients

-- Patient names can be searched by the starting letter specified below and verified by date of birth or address

SELECT * FROM patients WHERE NAME LIKE 'o%';


-- |========================================================================
-- takePayments.sql
-- Take payments

SET @patientID = '1';
SET @DATE = SYSDATE();
SET @TIME = SYSDATE();
SET @amount = '100';
SET @paymentType = '0'; -- 0 Cash / 1 Card / 2 Cheque
SET @paidWhere = '0'; -- 0 Person / 1 Post / 2 Phone
SET @billNo = '1';


INSERT INTO payments (patientID, DATE, TIME, amount, paymentType, paidWhere, billno)

VALUES (@patientID, @DATE, @TIME, @amount, @paymentType, @paidwhere, @billNo);

UPDATE patients

SET patients.outstandingBalance = (patients.outstandingBalance - @amount)
															
WHERE patients.PatientID = @patientID; 


-- |========================================================================
-- generateBills.sql
-- Generate Bills from appointments marked as unpaid and checkedIn
-- add to bills table

INSERT INTO bills (patientID, amount)

VALUES ((SELECT DISTINCT patientID FROM appointments WHERE  appointments.Billed='0' AND appointments.checkedIn='1'),

		(SELECT DISTINCT (SUM(appointments.Cost) +patients.outstandingBalance)
			
					
			FROM appointments JOIN patients
			ON appointments.PatientID=patients.PatientID
			
			WHERE appointments.Billed='0' AND appointments.checkedIn='1' )
			
	
	);
	

-- |========================================================================
-- updateOutstandingBalances.sql
-- Update Balances following preparation of bills

UPDATE 
	patients p
	INNER JOIN 
		(
			
			SELECT patients.PatientID, (SUM(appointments.Cost) + patients.outstandingBalance) sumCost
			
			FROM appointments JOIN patients
			ON appointments.PatientID=patients.PatientID
			
			WHERE appointments.Billed='0' 
			
			GROUP BY appointments.PatientID
				
	) t
	
	 ON p.PatientID = t.PatientID

SET p.outstandingBalance = t.sumCost

WHERE p.PatientID=t.PatientID;

-- Then mark appointments as billed

UPDATE appointments

SET appointments.Billed='1'

WHERE appointments.Billed='0' AND appointments.checkedIn='1';


-- |========================================================================
-- updateTreatmentCosts.sql
-- UPDATES ALL APPOINTMENTS COSTS TO CURRENT TREATMENT COSTS

UPDATE `dentalman`.`appointments`, treatments SET appointments.`Cost`=treatments.cost WHERE  appointments.TreatmentID=treatments.treatmentID;


-- |========================================================================
-- updateTreatmentFee.sql
-- Update Treatment Fee

UPDATE treatments

SET cost = '60'

WHERE treatmentID = '1';


-- |========================================================================	
-- viewAppointments.sql
-- View Appointments; for seeing available appointment slots

SELECT 	appointments.patientID, patients.name AS 'Patient Name', appointments.date, appointments.time AS 'starts', 
			CAST(appointments.time + treatments.duration AS TIME) AS 'ends', treatments.title, staff.Name AS 'Dentist'

FROM appointments, treatments, staff, patients

WHERE appointments.patientID = patients.patientID AND appointments.treatmentID = treatments.treatmentID AND appointments.staffID = staff.staffID

-- RESULTS CAN BE NARROWED TO A CERTAIN DATE RANGE HERE

AND appointments.date BETWEEN '2022-04-25' AND '2022-04-28';


-- |========================================================================
-- viewNextWeek.sql
-- This shows the nextWeek view of upcoming appointments and the required details for issuing reminder letters

SELECT nextweek.patientID, patients.NAME, address, DATE, TIME, treatments.title, nextweek.cost FROM nextWeek, patients, treatments

WHERE nextweek.patientID = patients.patientID AND nextweek.TreatmentID = treatments.treatmentID;

