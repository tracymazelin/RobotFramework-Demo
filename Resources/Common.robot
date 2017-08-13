*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported Selenium2Library.


Library           Selenium2Library
Library           RequestsLibrary
Library           String
Library           DateTime
Library           Collections
Library           OperatingSystem
Library           DateTime


*** Variables ***
${ENV}              prod
${BROWSER}          Chrome
${DELAY}            0
${VALID USER}
${VALID PASSWORD}
&{SERVER}           qa=https://zapier.com
...                 staging=https://zapier.com
...                 prod=https://zapier.com
${HOME}             ${SERVER.${ENV}}/

*** Keywords ***
# These are some generic keywords that I have found useful in the tests I write

Begin Web Test
  Open Browser    ${HOME}     ${BROWSER}
  Maximize Browser Window
  Set Selenium Speed    ${DELAY}

Go To Home Page
   Begin Web Test
   Title Should Be    The best apps. Better together. - Zapier

Verify Link Returns HTTP 200 Response
    [Arguments]  ${elementID}
    Page Should Contain Element   ${elementID}
    ${href}=  Get Element Attribute   ${elementID}@href
    Create session  link  ${href}  disable_warnings=1
    ${response}  Get Request  link  /  # URL is relative to the session URL
    Should be equal as integers  ${response.status_code}  200
    ...  Link '${href}' returned unexpected status code

Generate Random Number In Range
    [Arguments]    ${min}=0    ${max}=sys.maxint
    [Documentation]    Returns random integer between min and max values. Min defaults to 0 and max to maxint.
    ${num}    Evaluate    random.randint(${min}, ${max})    random,sys
    [Return]    ${num}

Select Random Item From Select List
    [Arguments]    ${selectList}
    [Documentation]    Returns random item from given select list
    ${items}    Get List Items    ${selectList}
    ${length}   Get Length    ${items}
    ${index}    Generate Random Number In Range    1     ${length}-1
    # Oddly, this keyword requires a string not an int for the index
    ${random}   Convert To String    ${index}
    ${item}     Select From List By Index    ${selectList}     ${random}

Get Timestamp
    ${timestamp}    Get Current Date  exclude_millis=yes
    Set Suite Variable  ${TIMESTAMP}  ${timestamp}

Get Current Date By Format
    ${simple date}=     Get Current Date  result_format=%m/%d/%Y
    Set Suite Variable  ${SIMPLE DATE}   ${simple date}

Get Current Year
    ${year}=    Get Current Date    result_format=%Y
    Set Global Variable   ${CURRENT_YEAR}  ${year}
    [Return]  ${year}

Get Current Month
    ${month}=  Get Current Date  result_format=%B
    Set Global Variable   ${CURRENT_MONTH}  ${month}
    [Return]  ${month}

Verify Text Input
    [Arguments]  ${textIdentifier}   ${textValue}
    ${verify}=       Get Value    ${textIdentifier}
    Should Be Equal   ${textValue}    ${verify}

Verify Select Box Selection
    [Arguments]  ${selectBoxIdentifier}   ${selectBoxValue}
    ${verify}=   Get Selected List Label   ${selectBoxIdentifier}
    Should Be Equal   ${selectBoxValue}  ${verify}

Verify A List Of Text Items
    [Arguments]     @{TEXT LIST}
    @{TEXT LIST}  Create List   @{TEXT LIST}
    :FOR   ${TEXT}  IN  @{TEXT LIST}
    \       Page Should Contain       ${TEXT}

Verify A List Of Page Links
    [Arguments]     @{LINKS}
    @{LINKS}  Create List   @{LINKS}
    :FOR   ${LINK}  IN  @{LINKS}
    \       Page Should Contain Link       ${LINK}


Verify A List Of Items In A Table
    [Arguments]     ${TABLE}   @{ITEMS}
    @{ITEMS}  Create List   @{ITEMS}
    :FOR   ${ITEM}  IN  @{ITEMS}
    \       Table Should Contain    ${TABLE}       ${ITEM}


Get The Number of Rows In a Data Table
     [Arguments]   ${XPath}
     [Documentation]  Returns the number of rows in a data table minus the header
     ${TableRowCount}=    Get Matching Xpath Count
    ...    xpath=${XPath}
    ${TableRowCount}=  Evaluate   ${TableRowCount} - 1  # minus the header row
    [Return]  ${TableRowCount}

Verify An Image Is Visible
    [Arguments]  ${elementID}
    [Documentation]
    ...  This keyword fails if the given image element is not visible.
    ...  Three checks are performed: that the element is on the page,
    ...  that selenium thinks the element is visible, and that the
    ...  src attribute of the image points to a resource that is
    ...  accessible.
    # Step 1: verify the page contains the given element
    Page should contain image  ${elementID}
    # Step 2: verify that the element is visible
    Element should be visible  ${elementID}
    # Step 3: verify the src attribute of the image is accessible
    ${img src}=  Get element attribute  ${elementID}@src
    Create session  img-src  ${img src}    disable_warnings=1
    ${response}  Get Request  img-src  /  # URL is relative to the session URL
    Should be equal as integers  ${response.status_code}  200
    ...  image url '${img src}' returned unexpected status code '${response.status_code}'
    ...  show_values=False
