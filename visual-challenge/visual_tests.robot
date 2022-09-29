*** Settings ***
Library  SeleniumLibrary  plugins=SeleniumTestability;True;30 Seconds;True
Library  EyesLibrary

Test Setup  Navigate To Automation In Testing Website And Hack It

*** Test Cases ***
Check The Map Section Of The Homepage
    Eyes Open
    Eyes Check Region By Selector    css:.map  Map Of The Three Bears
    Eyes Close Async
    Close All Browsers

Check The Whole Homepage
    Eyes Open
    Eyes Check Window  Shady Meadows Homepage  Fully
    Eyes Close Async
    Close All Browsers


*** Keywords ***
Navigate To Automation In Testing Website And Hack It
   Open Browser  https://automationintesting.online/  Chrome
   Click Button  Let me hack!