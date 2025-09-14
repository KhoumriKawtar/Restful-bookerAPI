*** Settings ***
Library   RequestsLibrary

Library           OperatingSystem

Resource  ../../resources/variables/variables.robot
Resource  ../keywords/authentication_keywords.robot
Resource  ../keywords/update_booking_keywords.robot

*** Keywords ***
DELETE Booking Request
    [Documentation]    Send DELETE request
    [Arguments]        ${endpoint}    ${headers}=${EMPTY}   ${expected_status}=${HTTP_CREATED}
    ${headers}=    Get Auth Header
    # Send Delete request with authentication
    ${response}=    DELETE On Session    ${SESSION_NAME}    /booking/${endpoint}    headers=${headers}     expected_status=${expected_status}
    Validate Response Status    ${response}    ${expected_status}
    RETURN    ${response}

Delete Booking Without Auth
    [Arguments]    ${booking_id}  ${headers}  ${expected_status}
    ${response}=   Delete On Session    deletesession    /booking/${booking_id}    headers=${headers}  expected_status=${expected_status}
    Validate Response Status    ${response}    ${expected_status}
    RETURN    ${response}

Verify Deleted Booking
    [Documentation]    Verify that a booking has been deleted
    [Arguments]        ${booking_id}
    # Try to get the deleted booking - should return 404
    ${response}=    Get Booking By ID    ${booking_id}    expected_status=${HTTP_NOT_FOUND}
    Should Be Equal As Numbers    ${response.status_code}    ${HTTP_NOT_FOUND}

DELETE Booking Request Without Auth
    [Documentation]    Send DELETE request without authentication (negative tests)
    [Arguments]        ${endpoint}    ${headers}=${EMPTY}    ${expected_status}=${HTTP_FORBIDDEN}
    Create Session    ${SESSION_NAME}_NOAUTH    ${BASE_URL}
    ${response}=    DELETE On Session    ${SESSION_NAME}_NOAUTH    /booking/${endpoint}    headers=${headers}   expected_status=${expected_status}
    Validate Response Status    ${response}    ${expected_status}
    RETURN    ${response}