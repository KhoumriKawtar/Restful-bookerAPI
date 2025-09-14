*** Settings ***
Library   RequestsLibrary
Library           OperatingSystem
Library    DateTime

Resource  ../../resources/variables/variables.robot
Resource  ../keywords/authentication_keywords.robot


*** Keywords ***
Send GET Request
     [Documentation]    Send GET request
     [Arguments]    ${endpoint}    ${params}=${None}   ${expected_status}=${HTTP_OK}
     IF    $params == $None
        ${response}=    GET On Session    ${SESSION_NAME}    ${endpoint}   expected_status=${expected_status}
     ELSE
        ${response}=    GET On Session    ${SESSION_NAME}    ${endpoint}    params=${params}   expected_status=${expected_status}
     END
     Should Be Equal As Numbers    ${response.status_code}    ${expected_status}
    Log    Status code validation passed: ${response.status_code}

    RETURN    ${response}
Validate Booking Response Structure
    [Documentation]    Validate booking response has correct structure
    [Arguments]        ${response}
    ${response}=    GET On Session   ${SESSION_NAME}    /booking
    Should Be Equal As Strings    ${response.status_code}    ${HTTP_OK}
    ${body}=    To JSON    ${response.content}
    FOR    ${booking}    IN    @{body}
        Should Contain Any    ${booking}    bookingid
        ${id}=    Evaluate    int(${booking['bookingid']})
        Should Be True    ${id} > 0    bookingid should be a positive integer
    END
Validate Response Time
    [Documentation]    Validate that response time
    [Arguments]    ${response}    ${max_ms}=1000
    ${elapsed}=    Evaluate    ${response.elapsed.total_seconds()} * 1000
    Log    Response time: ${elapsed} ms
    Should Be True    ${elapsed} < ${max_ms}    Response took too long: ${elapsed} ms