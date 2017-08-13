*** Settings ***
Documentation     Page Objects For Demo Home Page

Resource   ../Resources/Common.robot

*** Variables ***
# These are the page objects that the keywords will interact with
# Prefixes = btn, txt, date, pass, lnk, slct, tbl, chk
# Sort alphabetically via PyCharm's Sort Plugin
# Expicitly state identifier for better readability
# If the element has a unique ID, use it.  Otherwise xpath or css selectors work but are more brittle than element id's.
${imgLogo}             xpath=//*[@id="static-content"]/div/div[1]/div/div[1]

*** Keywords ***
Check Existence Of Logo
   #Step 1: Check the element is on the page and visible
   Element Should Be Visible  ${imgLogo}
   #Step 2: Use the Requests Library to make sure the img href returns an HTTP 200 response
   Create session  img  https://cdn.zapier.com  disable_warnings=1
   ${response}  Get Request  img  /static/1DGcoC/images/frontend/onboarding/zapier-small-orange-logo.png  # URL is relative to the session URL
   Should be equal as integers  ${response.status_code}  200
   ...  The image returned unexpected status code
   #Step 3: Capture a screenshot for the logs
   Capture Page Screenshot
