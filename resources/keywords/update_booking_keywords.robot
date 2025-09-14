*** Settings ***
Library   RequestsLibrary
Library           OperatingSystem


Resource  ../../resources/keywords/update_booking_keywords.robot
Resource  ../../resources/keywords/get_booking_keywords.robot
Resource  ../../resources/variables/variables.robot

*** Keywords ***
Send POST Request
    [Arguments]    ${endpoint}     ${payload}    ${headers}=${EMPTY}   ${expected_status}=${HTTP_OK}
    ${headers}=    Get Auth Header
    ${response}=    POST On Session    ${SESSION_NAME}    ${endpoint}    json=${payload}    headers=${headers}    expected_status=${expected_status}
    RETURN    ${response}
Create Test Booking
    [Documentation]    Create a test booking and return booking ID
    [Arguments]        ${booking_data}=${VALID_BOOKING}
    # Prepare booking data
    &{booking_payload}=    Create Dictionary
    ...    firstname=${BOOKING_DATA.firstname}
    ...    lastname=${BOOKING_DATA.lastname}
    ...    totalprice=${BOOKING_DATA.totalprice}
    ...    depositpaid=${BOOKING_DATA.depositpaid}
    ...    bookingdates=${BOOKING_DATES}
    ...    additionalneeds=${BOOKING_DATA.additionalneeds}
    # Create booking
    ${response}=    Send POST Request    /booking    ${booking_payload}    expected_status=${HTTP_OK}
    # Extract booking ID
    ${booking_id}=    Get From Dictionary    ${response.json()}    bookingid
    Should Be True   ${booking_id} > 0
    Log    Created test booking with ID: ${booking_id}

    RETURN    ${booking_id}
Get Booking By ID
    [Documentation]    Retrieve a specific booking by ID
    [Arguments]        ${booking_id}    ${expected_status}=${HTTP_OK}
    ${response}=    Send GET Request     /booking/${booking_id}    expected_status=${expected_status}
    RETURN    ${response}

Patch Booking Field
    [Arguments]  ${booking_id}    ${fields}   ${expected_status}=${HTTP_OK}
    # Send PATCH request with authentication
    ${response}=    PATCH On Session  ${SESSION_NAME}    url=/booking/${booking_id}    json=${fields}   expected_status=${expected_status}
    [Return]    ${response}

Validate Partial Update Response
    [Documentation]    Validate response after partial update
    [Arguments]   ${response}    ${original_data}    ${updated_fields}
    ${updated_data}=    Set Variable    ${response.json()}
    # Validate updated fields have new values
    FOR    ${field}    ${new_value}    IN    &{updated_fields}
        Run Keyword If    '${field}' == 'bookingdates_checkin'
        ...    Should Be Equal    ${updated_data['bookingdates']['checkin']}    ${new_value}
        ...    ELSE IF    '${field}' == 'bookingdates_checkout'
        ...    Should Be Equal    ${updated_data['bookingdates']['checkout']}    ${new_value}
        ...    ELSE
        ...    Should Be Equal    ${updated_data['${field}']}    ${new_value}
    END
    Log    Partial update response validation passed

Validate Response Status
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Strings    ${response.status_code}    ${expected_status}

