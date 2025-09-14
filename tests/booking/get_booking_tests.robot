*** Settings ***
Documentation    Get booking IDs with filtering capabilities
Library   RequestsLibrary
Resource         ../../resources/keywords/get_booking_keywords.robot
Resource         ../../resources/keywords/update_booking_keywords.robot

Suite Setup    Generate Authentication Token
Test Setup     Create Booking Session
*** Test Cases ***

TC01:Retrieve all booking IDs without filters
    [Documentation]   Get all Booking IDs
    ${response}=  Send GET Request  /booking
    Validate Response Time  ${response}    2000
    Validate Booking Response Structure    ${response}
    Validate Response Status  ${response}    ${HTTP_OK}
TC02: Filter booking by firstname
   [Documentation]    Filter bookings by firstname parameter
   ${params}=    Create Dictionary    firstname=${VALID_FIRSTNAME}
   ${response}=  Send GET Request  /booking   ${params}
   Validate Response Time  ${response}    2000
   Validate Booking Response Structure    ${response}
   Validate Response Status  ${response}    ${HTTP_OK}
TC03: Filter booking by lastname
     [Documentation]    Filter bookings by lastname parameter
   ${params}=    Create Dictionary    lastname=${VALID_LASTNAME}
   ${response}=  Send GET Request  /booking   ${params}
   Validate Response Time  ${response}    2000
   Validate Booking Response Structure    ${response}
   Validate Response Status  ${response}    ${HTTP_OK}
TC04: Filter booking by checkin date
    [Documentation]    Filter bookings by checkin date parameter
   ${params}=    Create Dictionary    checkin=${VALID_CHECKIN_DATE}
   ${response}=  Send GET Request  /booking   ${params}
   Validate Response Time  ${response}    2000
   Validate Booking Response Structure    ${response}
   Validate Response Status  ${response}    ${HTTP_OK}
TC05: Filter booking by checkout date
    [Documentation]    Filter bookings by checkout parameter
   ${params}=    Create Dictionary    checkout=${VALID_CHECKOUT_DATE}
   ${response}=  Send GET Request  /booking   ${params}  ${HTTP_OK}
   Validate Response Time  ${response}    2000
   Validate Booking Response Structure    ${response}
   Validate Response Status  ${response}    ${HTTP_OK}

TC06: Filter booking by firstname and lastname and checkout date
    [Documentation]    Filter bookings by firstname parameter
   ${params}=    Create Dictionary    firstname=${VALID_FIRSTNAME}  lastname=${VALID_LASTNAME}  checkin=${VALID_CHECKIN_DATE}  checkout=${VALID_CHECKOUT_DATE}
   ${response}=  Send GET Request  /booking   ${params}
   Validate Response Time  ${response}    2000
   Validate Booking Response Structure    ${response}
   Validate Response Status  ${response}    ${HTTP_OK}

TC07: Filter booking by Invalid date formats
    [Documentation]    Filter bookings by firstname parameter
   ${params}=    Create Dictionary    checkout=${INVALID_DATE}
   ${response}=  Send GET Request  /booking   ${params}
   Validate Response Time  ${response}    2000
   Validate Booking Response Structure    ${response}
   Validate Response Status  ${response}    ${HTTP_OK}
TC08: Filter booking by Invalid parameter values
    [Documentation]    Test error handling for invalid date formats
    ${params}=    Create Dictionary    firstname=${INVALID_FIRSTNAME}
    ${response}=  Send GET Request  /booking   ${params}
    Validate Response Time  ${response}    2000
    Validate Booking Response Structure    ${response}
    Validate Response Status  ${response}    ${HTTP_OK}

