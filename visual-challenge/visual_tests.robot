*** Settings ***
Library  SeleniumLibrary
Library  EyesLibrary

*** Test Cases ***
Check The Map Section Of The Homepage
    Open Browser  https://automationintesting.online/  Chrome
    Click Button  Let me hack!
    Sleep  2secs
    Eyes Open
    #Eyes Check Region By Selector    css:.map  With Name  Map Of The Three Bears
    #Eyes Check Region By Selector    css:.map  Map Of The Three Bears
    Eyes Check Region By Selector    css:.hotel-img  Map Of The Three Bears
    Eyes Close Async
    Close All Browsers
