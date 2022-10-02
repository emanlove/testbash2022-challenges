*** Settings ***
Library  RequestsLibrary
Library  DebugLibrary
Library  Collections

Suite Setup  Create API Requests Sessions

*** Test Cases ***
Validate A Room Reservation Through The API

    ${auth_token}=  Login To Authentication API    admin    password
    ${room_to_create}=   Define Baby Bear's Room
    ${id_room_created}=  Create Room Through The API  ${auth_token}  ${room_to_create}
    ${room_in_db}=  Get Room Information Via API    ${id_room_created}
    Verify Room Created Is Same As Room In The System    ${room_to_create}    ${room_in_db}

*** Keywords ***
Create API Requests Sessions
    Create Session    auth    https://automationintesting.online/auth
    Create Session    room    https://automationintesting.online/room

Define Baby Bear's Room
    @{room_features}=  Create List  Small Bed  Nightstand with Reading Light  Toy Chest
    &{b_bears_room}=  Create Dictionary  room=${15}  roomName=Baby Bear's Room  type=Family
    ...  accessible=${True}  image=No Image Available  description=This room is just right!
    ...  features=${room_features}  roomPrice=${143}
    [Return]  ${b_bears_room}

Create Room Through The API
    [Arguments]  ${token}  ${room}
    ${room_headers}=  Create Dictionary  accept=*/*  Content-Type=application/json  Cookie=token=${token}
    ${post_room_resp}=  POST On Session  room  /  json=${room}  headers=${room_headers}
    &{room_added}=  Set Variable  ${post_room_resp.json()}
    [Return]  ${room_added}[roomid]

Login To Authentication API
    [Arguments]  ${uname}  ${pword}
    ${auth_req_headers}=  Create Dictionary  accept=*/*  Content-Type=application/json 
    ${auth_body}=  Create Dictionary  username=${uname}  password=${pword}
    ${auth_resp}=  POST On Session  auth  /login  json=${auth_body}  headers=${auth_req_headers}
    ${cookie_header}=  Set Variable  ${auth_resp.headers}[Set-Cookie]
    @{cookies_list}=  Set Variable  ${cookie_header.split(';')}
    &{cookies}=  Create Dictionary
    FOR  ${cookie}  IN  @{cookies_list}
        ${key}  ${value}=  Set Variable  ${cookie.lstrip().split('=')}
        Set To Dictionary  ${cookies}  ${key}=${value}
    END
    ${token}=  Set Variable  ${cookies}[token]
    [Return]  ${token}

Get Room Information Via API
    [Arguments]  ${room_id}
    ${get_room_headers}=  Create Dictionary  accept=*/*  #Content-Type=application/json  Cookie=token=${token}
    ${get_room_resp}=  GET On Session  room  /${room_id}  headers=${get_room_headers}
    &{room_received}=  Set Variable  ${get_room_resp.json()}
    [Return]  ${room_received}

Verify Room Created Is Same As Room In The System
    [Arguments]  ${reservation}  ${room_within_system}
    Should Be Equal  ${reservation}[roomName]  ${room_within_system}[roomName]
    ...  Room name added [${reservation}[roomName]] does not match room name on record [${room_within_system}[roomName]]
    Should Be Equal  ${reservation}[type]  ${room_within_system}[type]
    ...  Room type added [${reservation}[type]] does not match room type on record [${room_within_system}[type]]
    Should Be Equal  ${reservation}[accessible]  ${room_within_system}[accessible]
    ...  Room accessibility added [${reservation}[accessible]] does not match room accessibility on record [${room_within_system}[accessible]]
    Should Be Equal  ${reservation}[image]  ${room_within_system}[image]
    ...  Room image added [${reservation}[image]] does not match room image on record [${room_within_system}[image]]
    Should Be Equal  ${reservation}[description]  ${room_within_system}[description]
    ...  Room description added [${reservation}[description]] does not match room description on record [${room_within_system}[description]]
    Should Be Equal  ${reservation}[features]  ${room_within_system}[features]
    ...  Room features added [${reservation}[features]] does not match room features on record [${room_within_system}[features]]
    Should Be Equal  ${reservation}[roomPrice]  ${room_within_system}[roomPrice]
    ...  Room price added [${reservation}[roomPrice]] does not match room price on record [${room_within_system}[roomPrice]]