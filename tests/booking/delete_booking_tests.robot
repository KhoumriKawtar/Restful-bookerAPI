*** Settings ***
Documentation       Test cases for DELETE /booking/{id} endpoint - Delete bookings
Library             RequestsLibrary
Library             Collections
Library             DateTime

Resource  ../../resources/keywords/update_booking_keywords.robot
Resource  ../../resources/keywords/get_booking_keywords.robot
Resource  ../../resources/variables/variables.robot
Resource  ../../resources/keywords/delete_booking_keywords.robot

Suite Setup    Generate Authentication Token
Test Setup     Create Booking Session

*** Test Cases ***
TC01: Delete Existing Booking Successfully
    [Documentation]    Successfully delete an existing booking
    # Create test booking
    ${booking_id}=    Create Test Booking    ${VALID_BOOKING}
    # Verify booking exists before deletion
    ${response}=    Get Booking By ID    ${booking_id}
    Validate Response Status    ${response}    ${HTTP_OK}
    # Delete the booking
    ${delete_response}=    DELETE Booking Request    ${booking_id}    expected_status=${HTTP_CREATED}
    # Validate deletion response
    Validate Response Status    ${delete_response}  ${HTTP_CREATED}
    Validate Response Time  ${response}    1500
    # Verify booking is deleted by trying to retrieve it
    Verify Deleted Booking    ${booking_id}
    Log    Booking ${booking_id} deleted successfully    level=INFO


TC02: Delete non existent Booking ID
     [Documentation]    Test deletion of non-existent booking ID - should return 405
    # Use non-existent booking ID
    ${invalid_id}=    Set Variable    999999
    # Attempt to delete non-existent booking
    ${response}=    DELETE Booking Request    ${invalid_id}   expected_status=${HTTP_METHOD_NOT_ALLOWED}

    # Validate error response (DELETE returns 405 for non-existent bookings in this API)
    Validate Response Status    ${response}    ${HTTP_METHOD_NOT_ALLOWED}

TC03: Delete booking without authentication
    [Documentation]    Test deletion of booking ID without authentication
     ${booking_id}=    Create Test Booking    ${VALID_BOOKING}
    ${headers}=       Get Auth Headers Without Token
    ${response}=      DELETE Booking Request Without Auth    ${booking_id}    ${headers}    ${HTTP_FORBIDDEN}
    Validate Response Status    ${response}    ${HTTP_FORBIDDEN}

TC04: Concurrent deletion of the same booking
    [Documentation]    deletion of the same booking
    ${booking_id}=   Create Test Booking    ${VALID_BOOKING}
    ${response1}=    DELETE Booking Request    ${booking_id}
    Validate Response Status    ${response1}    ${HTTP_CREATED}
    ${response2}=    DELETE Booking Request   ${booking_id}  expected_status=${HTTP_METHOD_NOT_ALLOWED}
    Validate Response Status    ${response2}    ${HTTP_METHOD_NOT_ALLOWED}