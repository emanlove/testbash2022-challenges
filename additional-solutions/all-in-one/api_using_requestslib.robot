*** Settings ***
Library  RequestsLibrary
Library  DebugLibrary
Library  Collections

*** Test Cases ***
Validate A Room Reservation Through The API
    Create Session    auth    https://automationintesting.online/auth
    Create Session    room    https://automationintesting.online/room

    ${auth_req_headers}=  Create Dictionary  accept=*/*  Content-Type=application/json 
    ${auth_body}=  Create Dictionary  username=admin  password=password
    ${auth_resp}=  POST On Session  auth  /login  json=${auth_body}  headers=${auth_req_headers}
    ${cookie_header}=  Set Variable  ${auth_resp.headers}[Set-Cookie]
    @{cookies_list}=  Set Variable  ${cookie_header.split(';')}
    &{cookies}=  Create Dictionary
    FOR  ${cookie}  IN  @{cookies_list}
        ${key}  ${value}=  Set Variable  ${cookie.lstrip().split('=')}
        Set To Dictionary  ${cookies}  ${key}=${value}
    END
    ${token}=  Set Variable  ${cookies}[token]
    
    @{room_features}=  Create List  Small Bed  Nightstand with Reading Light  Toy Chest
    &{reservation}=  Create Dictionary  room=${15}  roomName=Baby Bear's Room  type=Family
    ...  accessible=${True}  image=No Image Available  description=This room is just right!
    ...  features=${room_features}  roomPrice=${143}
    ${room_headers}=  Create Dictionary  accept=*/*  Content-Type=application/json  Cookie=token=${token}
    ${post_room_resp}=  POST On Session  room  /  json=${reservation}  headers=${room_headers}
    &{room_added}=  Set Variable  ${post_room_resp.json()}

    ${verify_room_headers}=  Create Dictionary  accept=*/*  #Content-Type=application/json  Cookie=token=${token}
    ${verify_room_resp}=  GET On Session  room  /${room_added}[roomid]  headers=${verify_room_headers}
    &{room_to_verify}=  Set Variable  ${verify_room_resp.json()}

    Should Be Equal  ${reservation}[roomName]  ${room_to_verify}[roomName]
    ...  Room name added [${reservation}[roomName]] does not match room name on record [${room_to_verify}[roomName]]
    Should Be Equal  ${reservation}[type]  ${room_to_verify}[type]
    ...  Room type added [${reservation}[type]] does not match room type on record [${room_to_verify}[type]]
    Should Be Equal  ${reservation}[accessible]  ${room_to_verify}[accessible]
    ...  Room accessibility added [${reservation}[accessible]] does not match room accessibility on record [${room_to_verify}[accessible]]
    Should Be Equal  ${reservation}[image]  ${room_to_verify}[image]
    ...  Room image added [${reservation}[image]] does not match room image on record [${room_to_verify}[image]]
    Should Be Equal  ${reservation}[description]  ${room_to_verify}[description]
    ...  Room description added [${reservation}[description]] does not match room description on record [${room_to_verify}[description]]
    Should Be Equal  ${reservation}[features]  ${room_to_verify}[features]
    ...  Room features added [${reservation}[features]] does not match room features on record [${room_to_verify}[features]]
    Should Be Equal  ${reservation}[roomPrice]  ${room_to_verify}[roomPrice]
    ...  Room price added [${reservation}[roomPrice]] does not match room price on record [${room_to_verify}[roomPrice]]