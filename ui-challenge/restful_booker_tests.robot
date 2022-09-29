*** Settings ***
Library  SeleniumLibrary  plugins=SeleniumTestability;True;30 Seconds;True
Library  FakerLibrary

Test Setup     Navigate To Automation In Testing Website And Hack It
Test Teardown  Close All Browsers

*** Variables ***
${message}  Well, the Meadows really wasn't that shady.

*** Test Cases ***
Verify Contact Form Message

   ${Goldilocks}=  Create Random Name
   Fill Out Contact Us Form And Submit  ${Goldilocks}  locks@gold-i-mail.com  111-111-1837
   ...  This bed was too soft!  ${message}

   Login To Admin Portal
   Navigate To Messages With Admin Portal
   ${name_el}=  Search For Message Based Upon Name  ${Goldilocks}
   Click Element  ${name_el}

   ${msg_from}  ${msg_email}  ${msg_subject}  ${msg_message}=  Extract Message Information From Message Overlay
   Should Be Equal  ${message}  ${msg_message}  Message in system doesn't not match message submitted!


*** Keywords ***
Navigate To Automation In Testing Website And Hack It
   Open Browser  https://automationintesting.online/  Chrome
   Click Button  Let me hack!

Create Random Name
   ${random_city}=  City
   ${random_name}=  Set Variable  Goldilocks of the ${random_city}
   RETURN  ${random_name}

Fill Out Contact Us Form And Submit
   [Arguments]  ${name}  ${email}  ${phone}  ${subject}  ${description}
   Input Text  id:name   ${name}
   Input Text  id:email  ${email}
   Input Text  id:phone  ${phone}
   Input Text  id:subject  ${subject}
   Input Text  id:description  ${description}
   Click Element  id:submitContact

Login To Admin Portal
   Go To  https://automationintesting.online/#/admin
   Input Text  id:username  admin
   Input Password  id:password   password
   Click Element  id:doLogin

Navigate To Messages With Admin Portal
   Click Link  \#/admin/messages

Search For Message Based Upon Name
   [Arguments]  ${search_name}
   ${count}=  Get Element Count  css:div[data-testid]:first-of-type
   FOR  ${index}  IN RANGE  ${count}
      ${name_el}=  Get WebElement    xpath://*[@data-testid="message${index}"]
      ${name}=  Get Text  ${name_el}
      IF  $name != $search_name  CONTINUE
      ${subject}=   Get Text  xpath://*[@data-testid="messageDescription${index}"]
   END
   ${foundName}=  Run Keyword And Return Status   Variable Should Exist  ${subject}
   IF  not $foundName  Fail  Did not find matching name in messages
   RETURN  ${name_el}

Extract Message Information From Message Overlay
   ${from_line}=  Get Text  xpath://div[@data-testid='message']/div[1]/div[1]
   ${email_line}=  Get Text  xpath://div[@data-testid='message']/div[2]/div
   ${subject_line}=  Get Text  xpath://div[@data-testid='message']/div[3]/div
   ${message_line}=  Get Text  xpath://div[@data-testid='message']/div[4]/div

   RETURN  ${from_line}  ${email_line}  ${subject_line}  ${message_line}