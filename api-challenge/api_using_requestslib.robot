*** Settings ***
Library  RequestsLibrary
Library  DebugLibrary
Library    Collections

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
    ...  accesible=${True}  image=No Image Available  description=This room is just right!
    ...  features=${room_features}  roomPrice=${143}
    ${room_headers}=  Create Dictionary  accept=*/*  Content-Type=application/json  Cookie=token=${token}
    ${post_room_resp}=  POST On Session  room  /  json=${reservation}  headers=${room_headers}
    #Debug
