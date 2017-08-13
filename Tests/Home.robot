*** Settings ***
Documentation     Verifies elements on the Home Page

Resource          ../PageObjects/Home.robot

*** Test Cases ***
Verify Home Page Elements
    [Tags]	 Smoke   Critical  Home
    Home.Check Existence Of Logo

