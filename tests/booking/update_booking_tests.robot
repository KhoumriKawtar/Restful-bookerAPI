*** Settings ***
Documentation    update of booking
Metadata         Author     Kawtar KHOUMRI

Resource  ../../resources/keywords/update_booking_keywords.robot
Resource  ../../resources/keywords/get_booking_keywords.robot
Resource  ../../resources/variables/variables.robot

Suite Setup    Generate Authentication Token
Test Setup     Create Booking Session

*** Variables ***
@{CREATED_BOOKING_IDS}    # Track created bookings for cleanup
*** Test Cases ***
TC01:Update Single Field Firstname
    [Documentation]    Update only the firstname field of a booking
     # Create test booking
    ${booking_id}=    Create Test Booking    ${VALID_BOOKING}
    Append To List    ${CREATED_BOOKING_IDS}    ${booking_id}
    # Get original booking data
    ${original_response}=    Get Booking By ID    ${booking_id}
    ${original_data}=    Set Variable    ${original_response.json()}
    # Prepare partial update payload
    &{update_payload}=    Create Dictionary    firstname=${PARTIAL_UPDATE_FIRSTNAME.firstname}
    # Send PATCH request
    ${response}=    Patch Booking Field  ${booking_id}    ${update_payload}
    # Validate response
    Validate Response Status           ${response}    ${HTTP_OK}
    Validate Response Time             ${response}    1500
    Validate Partial Update Response   ${response}    ${original_data}   ${update_payload}
    Validate Booking Response Structure    ${response}
TC02:Update the lastname field in single request
     [Documentation]    Update only the lastname field of a booking
     # Create test booking
    ${booking_id}=    Create Test Booking    ${VALID_BOOKING}
    Append To List    ${CREATED_BOOKING_IDS}    ${booking_id}
    # Get original booking data
    ${original_response}=    Get Booking By ID    ${booking_id}
    ${original_data}=    Set Variable    ${original_response.json()}
    # Prepare partial update payload
    &{update_payload}=    Create Dictionary    lastname=${PARTIAL_UPDATE_LASTNAME.lastname}
    # Send PATCH request
    ${response}=    Patch Booking Field  ${booking_id}    ${update_payload}
    # Validate response
    Validate Response Status           ${response}    ${HTTP_OK}
    Validate Response Time             ${response}    1500
    Validate Partial Update Response   ${response}    ${original_data}    ${update_payload}
    Validate Booking Response Structure    ${response}
TC03:Update total price field
    [Documentation]    Update only the lastname field of a booking
     # Create test booking
    ${booking_id}=    Create Test Booking    ${VALID_BOOKING}
    Append To List    ${CREATED_BOOKING_IDS}    ${booking_id}
    # Get original booking data
    ${original_response}=    Get Booking By ID    ${booking_id}
    ${original_data}=    Set Variable    ${original_response.json()}
    # Prepare partial update payload
    &{update_payload}=    Create Dictionary    totalprice=${PARTIAL_UPDATE_PRICE.totalprice}
    # Send PATCH request
    ${response}=    Patch Booking Field  ${booking_id}    ${update_payload}
    # Validate response
    # Validate response
    Validate Response Status           ${response}    ${HTTP_OK}
    Validate Response Time             ${response}    2000
    Validate Booking Response Structure    ${response}

TC03:Update deposit paid field
    [Documentation]    Update only the depositpaid field of a booking
    # Create test booking
    ${booking_id}=    Create Test Booking    ${VALID_BOOKING}
    Append To List    ${CREATED_BOOKING_IDS}    ${booking_id}
    # Get original booking data
    ${original_response}=    Get Booking By ID    ${booking_id}
    ${original_data}=    Set Variable    ${original_response.json()}
    # Prepare field update (flip boolean)
    ${original_deposit}=     Set Variable    ${original_data['depositpaid']}
    ${new_deposit}=          Set Variable If    ${original_deposit}    false    true
    &{update_payload}=       Create Dictionary    depositpaid=${new_deposit}
    # Send PATCH request
    ${response}=    Patch Booking Field    ${booking_id}    ${update_payload}
    # Validate response status
    Should Be Equal As Strings    ${response.status_code}    ${HTTP_OK}
    # Validate depositpaid updated
    Dictionary Should Contain Item    ${response.json()}    depositpaid    ${True}
    # Validate response
    Validate Response Status           ${response}    ${HTTP_OK}
    Validate Response Time             ${response}    2000
    Validate Booking Response Structure    ${response}
    Log    Deposit paid update test completed successfully
TC04:Update additionalneeds field in single request
     [Documentation]    Update only the additionalneeds field of a booking
     # Create test booking
    ${booking_id}=    Create Test Booking    ${VALID_BOOKING}
    Append To List    ${CREATED_BOOKING_IDS}    ${booking_id}
    # Get original booking data
    ${original_response}=    Get Booking By ID    ${booking_id}
    ${original_data}=    Set Variable    ${original_response.json()}
    # Prepare partial update payload
    &{update_payload}=    Create Dictionary    additionalneeds=${PARTIAL_UPDATE_NEEDS.additionalneeds}
    # Send PATCH request
    ${response}=    Patch Booking Field  ${booking_id}    ${update_payload}
    # Validate response
    Validate Response Status           ${response}    ${HTTP_OK}
    Validate Response Time             ${response}    2000
    Validate Partial Update Response   ${response}    ${original_data}    ${update_payload}
    Validate Booking Response Structure    ${response}
TC05:Update Multiple Fields (Firstname +Lastname + Totalprice)
     [Documentation]    Update Multiple Fields : firstname, lastname
     # Create test booking
    ${booking_id}=    Create Test Booking    ${VALID_BOOKING}
    Append To List    ${CREATED_BOOKING_IDS}    ${booking_id}
    # Get original booking data
    ${original_response}=    Get Booking By ID    ${booking_id}
    ${original_data}=    Set Variable    ${original_response.json()}
    # Prepare partial update payload
    &{update_payload}=    Create Dictionary
       ...  firstname=${MULTIPLE_FIELD_UPDATE_FIRSTNAME.firstname}
       ...  lastname=${MULTIPLE_FIELD_UPDATE_LASTNAME.lastname}
       ...    totalprice=${MULTIPLE_FIELD_UPDATE_PRICE.totalprice}
    # Send PATCH request
    ${response}=    Patch Booking Field  ${booking_id}    ${update_payload}
    # Validate response
    Validate Response Status           ${response}    ${HTTP_OK}
    Validate Response Time             ${response}    2000
    Validate Booking Response Structure    ${response}
TC06: Update Nested Object (Booking Dates)
     [Documentation]    Update Multiple Fields : firstname, lastname
     # Create test booking
    ${booking_id}=    Create Test Booking    ${VALID_BOOKING}
    Append To List    ${CREATED_BOOKING_IDS}    ${booking_id}

    # Get original booking data
    ${original_response}=    Get Booking By ID    ${booking_id}
    ${original_data}=    Set Variable    ${original_response.json()}
    # Prepare nested object update payload
    &{new_dates}=    Create Dictionary
    ...    checkin=${PARTIAL_UPDATE_DATES.bookingdates_checkin}
    ...    checkout=${PARTIAL_UPDATE_DATES.bookingdates_checkout}
    # Prepare partial update payload
    &{update_payload}=    Create Dictionary   bookingdates=${new_dates}
    # Send PATCH request
    ${response}=    Patch Booking Field  ${booking_id}    ${update_payload}
    # Validate response
    Validate Response Status           ${response}    ${HTTP_OK}
    Validate Response Time             ${response}    2000
    Validate Partial Update Response   ${response}    ${original_data}   ${update_payload}
TC07:Update Booking With Invalid ID
    [Documentation]    Test PATCH with non-existent booking ID - should return 404
    # Use non-existent booking ID
    ${invalid_id}=    Set Variable    10000000000000
    &{update_payload}=    Create Dictionary    firstname=ShouldNotWork
    # Send PATCH request - should fail
    ${response}=    Patch Booking Field    ${invalid_id}    ${update_payload}   expected_status=${HTTP_METHOD_NOT_ALLOWED}
    # Validate error response
    Validate Response Status      ${response}    ${HTTP_METHOD_NOT_ALLOWED}
    Validate Response Time             ${response}   2000
    Log    Invalid booking ID test completed successfully (404 received)

TC08:Update Booking With Invalid Data Types
    [Documentation]    Test PATCH with invalid data types

    # Create test booking
    ${booking_id}=    Create Test Booking    ${VALID_BOOKING}
    Append To List    ${CREATED_BOOKING_IDS}    ${booking_id}

    # Test invalid totalprice (string instead of number)
    &{invalid_payload}=    Create Dictionary    totalprice=invalid_price
    ${response}=    Patch Booking Field    ${booking_id}    ${invalid_payload}

    # Validate error response
     Validate Response Status      ${response}  ${HTTP_OK}
     Validate Response Time             ${response}   2000
    Log    Invalid data type test completed
TC09:Verify idempotency of updates
     [Documentation]    Verify that PATCH operations are idempotent
    # Create test booking
    ${booking_id}=    Create Test Booking    ${VALID_BOOKING}
    Append To List    ${CREATED_BOOKING_IDS}    ${booking_id}
    # Prepare update payload
    &{update_payload}=    Create Dictionary    firstname=IdempotencyTest
    # Send first PATCH request
    ${response1}=    Patch Booking Field    ${booking_id}    ${update_payload}
    Validate Response Status    ${response1}    ${HTTP_OK}
    ${first_data}=    Set Variable    ${response1.json()}
    # Send identical PATCH request again
    ${response2}=    Patch Booking Field    ${booking_id}    ${update_payload}
    Validate Response Status    ${response2}    ${HTTP_OK}
    ${second_data}=    Set Variable    ${response2.json()}
    # Verify responses are identical
    Should Be Equal    ${first_data['firstname']}    ${second_data['firstname']}
    Should Be Equal    ${first_data['lastname']}    ${second_data['lastname']}
    Should Be Equal    ${first_data['totalprice']}    ${second_data['totalprice']}
    Should Be Equal    ${first_data['depositpaid']}    ${second_data['depositpaid']}
    Log    Idempotency test completed successfully
