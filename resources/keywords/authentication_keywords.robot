*** Settings ***
Library    RequestsLibrary
Library             Collections
Library             String
Resource  ../variables/variables.robot
*** Keywords ***

Generate Authentication Token
    [Documentation]    Create one session and get token once per suite.
    [Arguments]     ${USERNAME}=${USERNAME}    ${PASSWORD}=${PASSWORD}
    # create session once (alias = session)
    Create Session    auth    ${BASE_URL}
    # Prepare authentication payload
    ${auth_payload}=    Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    ${headers}=    Create Dictionary    Content-Type=application/json
    # Send authentication request
    ${response}=    Post On Session    auth    /auth    json=${auth_payload}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${json}=    To JSON    ${response.content}
    Set Suite Variable    ${TOKEN}    ${json['token']}
    Log    Token generated: ${TOKEN}

Get Auth Header
    [Documentation]    Return headers dict with Content-Type and token for protected endpoints.
    ${headers}=    Create Dictionary    Content-Type=application/json    Cookie=token=${TOKEN}
    Return From Keyword    ${headers}

Create Booking Session
    [Arguments]    ${with_auth}=True
    ${headers}=    Create Dictionary    Content-Type=application/json
    Run Keyword If    ${with_auth}    Set To Dictionary    ${headers}    Cookie=token=${TOKEN}
    Create Session    booking    ${BASE_URL}    headers=${headers}

Get Auth Headers Without Token
    [Documentation]    Get headers without authentication token (for negative testing)
    &{headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    RETURN    ${headers}