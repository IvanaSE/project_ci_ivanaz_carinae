*** Settings ***
Resource                            page_new_bedroom.robot
Resource                            ../page_dashboard.robot

*** Variables ***
${bedroomlist_label}                   List

${bedroomlist_button_createnew}        xpath=//a[@class='btn btn-primary']
${bedroomlist_button_index}            xpath=//a[@class='btn btn-default']


*** Keywords ***
Go to create new bedroom form   
    Page should contain element              ${bedroomlist_button_createnew}
    Click Element                            ${bedroomlist_button_createnew}
    Wait Until Page Contains                 ${bedroomnew_label_title}
    
Back to dashboard from bedroom list
    Click Element                            ${bedroomlist_button_index}
    Wait Until Page Contains                 ${dashboard_pg_label_dashboard}   
    
            
