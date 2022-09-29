*** Settings ***
Library  SeleniumLibrary  plugins=SeleniumTestability;True;30 Seconds;True
Library  EyesLibrary
Library  String
Library  FakerLibrary

Test Setup  Navigate To Automation In Testing Website And Hack It
Test Teardown  Close All Browsers

*** Test Cases ***
Check The Whole Homepage With Random Locations
    Randomly Switch The Location On The Map
    Eyes Open
    Eyes Check Window  Shady Meadows Homepage  Fully
    Eyes Close Async


*** Keywords ***
Navigate To Automation In Testing Website And Hack It
    Open Browser  https://automationintesting.online/  Chrome
    Click Button  Let me hack!

Randomly Switch The Location On The Map
    ${randomStr}=  Generate Random String  1  [NUMBERS]
    ${randomInt}=  Convert To Integer  ${randomStr}
    Go To  https://automationintesting.online/#/admin
    Input Text  id:username  admin
    Input Password  id:password   password
    Click Element  id:doLogin
    Click Link  \#/admin/branding
    IF    ${randomInt}>=${3}
        # Default Location
        Log To Console  \nUsing Default Location
        ${random_latitude}=   Set Variable  52.6351204
        ${random_longitude}=  Set Variable   1.2733774
    ELSE
        Log To Console  \nUsing Random Location
        ${random_latitude}=   Latitude
        ${random_longitude}=  Longitude
    END
    Input Text  id:latitude   ${random_latitude}   # default 52.6351204
    Input Text  id:longitude  ${random_longitude}  # default  1.2733774
    Click Element  id:updateBranding
    Click Button  Close
    Go To  https://automationintesting.online/