*** Settings ***
Documentation       End-to-end integration tests for Restful-booker API
Library             RequestsLibrary
Library             Collections
Library             DateTime

Resource  ../../resources/keywords/delete_booking_keywords.robot
Resource  ../../resources/keywords/update_booking_keywords.robot
Resource  ../../resources/keywords/get_booking_keywords.robot
Resource  ../../resources/variables/variables.robot
Resource  ../keywords/authentication_keywords.robot
Suite Setup    Generate Authentication Token
Test Setup     Create Booking Session
*** Test Cases ***
Complete Booking Lifecycle Test
    [Documentation]    Test complete booking lifecycle: Create -> Read -> Update -> Delete

    # Step 1: Create a new booking
    Log    Step 1: Creating new booking    level=INFO
    ${booking_id}=    Create Test Booking    ${VALID_BOOKING}

    # Step 2: Retrieve the created booking
    Log    Step 2: Retrieving created booking    level=INFO
    ${get_response}=    Get Booking By ID    ${booking_id}
    Validate Response Status    ${get_response}    ${HTTP_OK}
    Validate Booking Response Structure    ${get_response}

    ${created_data}=    Set Variable    ${get_response.json()}
    Should Be Equal    ${created_data['firstname']}    ${VALID_BOOKING.firstname}
    Should Be Equal    ${created_data['lastname']}    ${VALID_BOOKING.lastname}

    # Step 3: Update the booking
    Log    Step 3: Updating booking    level=INFO
    &{update_payload}=    Create Dictionary
    ...    firstname=UpdatedFirst
    ...    lastname=UpdatedLast
    ...    totalprice=500

    ${patch_response}=    Patch Booking Field    ${booking_id}    ${update_payload}
    Validate Response Status    ${patch_response}    ${HTTP_OK}
    Validate Booking Response Structure    ${patch_response}

    ${updated_data}=    Set Variable    ${patch_response.json()}
    Should Be Equal    ${updated_data['firstname']}    UpdatedFirst
    Should Be Equal    ${updated_data['lastname']}    UpdatedLast
    Should Be Equal As Numbers    ${updated_data['totalprice']}    500

    # Step 4: Verify the update persisted
    Log    Step 4: Verifying update persistence    level=INFO
    ${verify_response}=    Get Booking By ID    ${booking_id}
    Validate Response Status    ${verify_response}    ${HTTP_OK}

    ${verified_data}=    Set Variable    ${verify_response.json()}
    Should Be Equal    ${verified_data['firstname']}    UpdatedFirst
    Should Be Equal    ${verified_data['lastname']}    UpdatedLast
    Should Be Equal As Numbers    ${verified_data['totalprice']}    500

    # Step 5: Delete the booking
    Log    Step 5: Deleting booking    level=INFO
    ${delete_response}=    DELETE Booking Request    ${booking_id}   expected_status=${HTTP_CREATED}
    Validate Response Status    ${delete_response}    ${HTTP_CREATED}

    # Step 6: Verify deletion
    Log    Step 6: Verifying deletion    level=INFO
    Verify Deleted Booking    ${booking_id}

    Log    Complete booking lifecycle test passed successfully    level=INFO
