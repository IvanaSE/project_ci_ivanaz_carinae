*** Settings ***
Resource                        ../credentials/environment_variables.robot

*** Keywords ***
Setup
    Set Environment Variable                   ${driver_name}          ${chromedriver_location}
    Open Browser                               ${base_url}             browser=${browser}
    Maximize Browser Window            
    Set Selenium Speed                         .2
    Set Selenium Timeout                       20    
    Delete all cookies 
    Location Should Be                          ${base_url}
    
Teardown
    Close all Browsers
