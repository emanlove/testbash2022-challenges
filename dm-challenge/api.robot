*** Settings ***
Library  RequestsLibrary
Library  DataDriver  file=bulk_room_data-UTF8.csv  encoding=utf_8  dialect=unix
Library  Collections

Suite Setup  Create API Requests Sessions
Test Template  Add A Room Through The API

*** Test Cases ***
Placeholder Test Case Name

*** Keywords ***
Add A Room Through The API
    [Arguments]  ${name}  ${type}  ${accessible}  ${image}  ${description}  ${features}  ${price}
    ${auth_token}=  Login To Authentication API    admin    password
    &{room_to_create}=  Create Dictionary  room=${1}  roomName=${name}  type=${type}
    ...  accessible=${accessible}  image=${image}  description=${description}
    ...  features=${features}  roomPrice=${price}
    ${id_room_created}=  Create Room Through The API  ${auth_token}  ${room_to_create}
    # ${room_in_db}=  Get Room Information Via API    ${id_room_created}
    # Verify Room Created Is Same As Room In The System    ${room_to_create}    ${room_in_db}

Create API Requests Sessions
    Create Session    auth    https://automationintesting.online/auth  verify=True
    Create Session    room    https://automationintesting.online/room  verify=True

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
