-- Keep a log of any SQL queries you execute as you solve the mystery.

--Check out what crimes were committed on July 7 on Chamberlain Street:
SELECT description
FROM crime_scene_reports
WHERE month = 7 AND day = 28
AND street = "Humphrey Street";
-- RETURN: Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery.There is three witnesses who
--              were present at the time – each of their interview transcripts mentions the bakery.


--Check out all interviews at this time and place
SELECT name, transcript
FROM interviews
WHERE month = 7 AND day = 28
AND transcript LIKE "%bakery%";
-- RETURN: Ruth - saw how within 10 minutes the thief get into the car in the bakery parking,
--         Eugene - recognize the thief, he withdraw money by the ATM on Leggett Street
--         Raymond - saw the thief made the phone call where said that he would take the earliest flight, and his assistant bought a ticket 1 minute after


--Bakery parking checking out
SELECT name
FROM people JOIN bakery_security_logs
ON bakery_security_logs.license_plate = people.license_plate
WHERE month = 7 AND day = 28 AND hour = 10 AND minute >= 15 AND minute <= 25
AND activity="exit";
    --RETURN: Suspects: Vanessa, Bruce, Barry, Luca, Sofia, Iman, Diana, Kelsey


-- Check out all people who withdraw money as Eugene said
SELECT name
FROM atm_transactions JOIN bank_accounts JOIN people
ON atm_transactions.account_number = bank_accounts.account_number
AND bank_accounts.person_id = people.id
WHERE month = 7 AND day = 28
AND atm_location = "Leggett Street"
AND transaction_type="withdraw"
AND name IN
    (SELECT name
    FROM people JOIN bakery_security_logs
    ON bakery_security_logs.license_plate = people.license_plate
    WHERE month = 7 AND day = 28 AND hour = 10 AND minute >= 15 AND minute <= 25
    AND activity="exit")
ORDER BY name;
--RETURN: Suspects: Bruce, Diana, Iman, Luca


--Check out all people, who made phone call in this day with duration less than 1 minute (60 sec)
--!the thief was caller
SELECT  name
FROM phone_calls JOIN people
ON phone_calls.caller = people.phone_number
WHERE month = 7 AND day = 28
AND duration <= 60
AND name IN
    (SELECT name
    FROM atm_transactions JOIN bank_accounts JOIN people
    ON atm_transactions.account_number = bank_accounts.account_number
    AND bank_accounts.person_id = people.id
    WHERE month = 7 AND day = 28
    AND atm_location = "Leggett Street"
    AND transaction_type="withdraw"
    AND name IN
        (SELECT name
        FROM people JOIN bakery_security_logs
        ON bakery_security_logs.license_plate = people.license_plate
        WHERE month = 7 AND day = 28 AND hour = 10 AND minute >= 15 AND minute <= 25
        AND activity="exit"))
ORDER BY name;
--Return: Suspects: Bruce, Diana

--Check out the earliest tomorrow flight
SELECT flights.id, airports.city
FROM flights JOIN airports
ON flights.destination_airport_id = airports.id
WHERE month = 7 AND day = 29
ORDER BY hour, minute
LIMIT 1;
--RETURN: flight's id 36 - destination - New York


--Check out the earliest tomorrow flight's passengers
SELECT people.name
FROM flights JOIN passengers JOIN people
ON flights.id = passengers.flight_id
AND passengers.passport_number = people.passport_number
WHERE month = 7 AND day = 29
AND flights.id IN
    (SELECT flights.id
    FROM flights
    WHERE flights.id IN
        (SELECT flights.id
        FROM flights JOIN airports
        ON flights.destination_airport_id = airports.id
        WHERE month = 7 AND day = 29
        ORDER BY hour, minute
        LIMIT 1))
AND people.name IN
    (SELECT  name
    FROM phone_calls JOIN people
    ON phone_calls.caller = people.phone_number
    WHERE month = 7 AND day = 28
    AND duration <= 60
    AND name IN
        (SELECT name
        FROM atm_transactions JOIN bank_accounts JOIN people
        ON atm_transactions.account_number = bank_accounts.account_number
        AND bank_accounts.person_id = people.id
        WHERE month = 7 AND day = 28
        AND atm_location = "Leggett Street"
        AND transaction_type="withdraw"
        AND name IN
            (SELECT name
            FROM people JOIN bakery_security_logs
            ON bakery_security_logs.license_plate = people.license_plate
            WHERE month = 7 AND day = 28 AND hour = 10 AND minute >= 15 AND minute <= 25
            AND activity="exit")));
--RETURN: Thief is Bruce

--Check out who helped him
SELECT  name
FROM phone_calls JOIN people
ON phone_calls.receiver = people.phone_number
WHERE month = 7 AND day = 28
AND duration <= 60
AND phone_calls.caller IN
    (SELECT phone_number
    FROM people
    WHERE name = "Bruce");
--RETURN: Assisstant is James

