*** Settings ***
Library  SeleniumLibrary
Library  ReactLibrary
Library  FakerLibrary

*** Variables ***
${message}  Well, the Meadows really wasn't that shady.
*** Test Cases ***
Verify Contact Form Message
   Open Browser  https://automationintesting.online/  Chrome
   Click Button  Let me hack!
   #Wait for react
   Sleep  2secs
   ${random_city}=  City
   ${Goldilocks}=  Set Variable  Goldilocks of the ${random_city}
   Input Text  id:name  ${Goldilocks}
   Input Text  id:email  locks@gold-i-mail.com
   Input Text  id:phone  111-111-1837
   Input Text  id:subject  This bed was too soft!
   Input Text  id:description  ${message}
   Click Element  id:submitContact
   Go To  https://automationintesting.online/#/admin
   Input Text  id:username  admin
   Input Password  id:password   password
   Click Element  id:doLogin
   #Wait for react
   Sleep  2secs
   Click Link  \#/admin/messages
   #Wait for react
   Sleep  1secs
   ${count}=  Get Element Count  css:div[data-testid]:first-of-type
   FOR  ${index}  IN RANGE  ${count}
      ${name_el}=  Get WebElement    xpath://*[@data-testid="message${index}"]
      ${name}=  Get Text  ${name_el}
      #${name}=  Get Text  xpath://*[@data-testid="message${index}"]
      IF  $name != $Goldilocks  CONTINUE
      ${subject}=   Get Text  xpath://*[@data-testid="messageDescription${index}"]
   END
   ${foundName}=  Run Keyword And Return Status   Variable Should Exist  ${subject}
   IF  not $foundName  Fail  Did not find matching name in messages
   Click Element  ${name_el}
   #Wait for react
   Sleep  1sec
   ${msg_from_line}=  Get Text  xpath://div[@data-testid='message']/div[1]/div[1]
   ${msg_email_line}=  Get Text  xpath://div[@data-testid='message']/div[2]/div
   ${msg_subject}=  Get Text  xpath://div[@data-testid='message']/div[3]/div
   ${msg_message}=  Get Text  xpath://div[@data-testid='message']/div[4]/div
   Should Be equal  ${message}  ${msg_message}

   Close All Browsers
#    #Get Names
#    ${names}= Get WebElements    css:.row div[data-testid]:first-of-type
#    FOR  ${name}  IN  @{names}:
#        ${match}