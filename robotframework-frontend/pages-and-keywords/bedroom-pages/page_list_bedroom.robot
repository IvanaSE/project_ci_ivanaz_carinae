*** Settings ***
Resource                            page_new_bedroom.robot
Resource                            page_view_bedroom.robot
Resource                            ../page_dashboard.robot

*** Variables ***
${bedroomlist_label}                   List
${bedroomlist_message_success}         Bedroom was successfully deleted.

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
       
Go to view bedroom form
    ${temp_str}=                          Catenate    SEPARATOR=    xpath=//td[text()='    ${room_name_suite}
    ${bedroomlist_button_view}=           Catenate    SEPARATOR=    ${temp_str}            ']/following-sibling::td/a[text()='View']     
    Click Element                         ${bedroomlist_button_view}
    Wait Until Page Contains              ${bedroomview_label_title}   
    Page Should Contain                   ${room_name_suite}
    Page Should Contain                   ${room_floor_suite}
    Page Should Contain                   ${room_number_suite}
    Page Should Contain                   ${bedroom_id_suite}
       
Perform delete room
    ${temp_str}=                     Catenate    SEPARATOR=    xpath=//td[text()='    ${room_name_suite}
    ${bedroomlist_button_delete}=    Catenate    SEPARATOR=    ${temp_str}            ']/following-sibling::td/a[text()='Delete']     
    Click Element                            ${bedroomlist_button_delete}
    Wait Until Page Contains                 ${bedroomlist_message_success}     
    Page Should Not Contain                  ${room_name_suite}
            
