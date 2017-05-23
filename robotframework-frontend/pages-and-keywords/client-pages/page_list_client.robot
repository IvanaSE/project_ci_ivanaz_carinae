*** Settings ***
Resource                            page_new_client.robot
Resource                            ../page_dashboard.robot

*** Variables ***
${clientlist_label_clients}           List

${clientlist_button_createnew}        xpath=//a[@class='btn btn-primary']
${clientlist_button_index}            xpath=//a[@class='btn btn-default']
${clientlist_message_success}         Client was successfully deleted.



*** Keywords ***
Go to create new client form   
    Page should contain element              ${clientlist_button_createnew}
    Click Element                            ${clientlist_button_createnew}
    Wait Until Page Contains                 ${clientnew_label_title}
    
Go to view client form
    ${temp_str}=                          Catenate    SEPARATOR=    xpath=//td[text()='    ${client_name_suite}
    ${clientlist_button_view}=            Catenate    SEPARATOR=    ${temp_str}            ']/following-sibling::td/a[text()='View']     
    Click Element                         ${clientlist_button_view}
    Wait Until Page Contains              ${clientview_label_title}   
    Page Should Contain                   ${client_name_suite}
    Page Should Contain                   ${client_email_suite}
    Page Should Contain                   ${client_security_number_suite}
    Page Should Contain                   ${client_id_suite}
        
Perform delete client
    ${temp_str}=                    Catenate    SEPARATOR=    xpath=//td[text()='    ${client_name_suite}
    ${clientlist_button_delete}=    Catenate    SEPARATOR=    ${temp_str}            ']/following-sibling::td/a[text()='Delete']     
    Click Element                            ${clientlist_button_delete}
    Wait Until Page Contains                 ${clientlist_message_success}     
    Page should not contain                  ${client_name_suite}

Back to dashboard from client list
    Click Element                            ${clientlist_button_index}
    Wait Until Page Contains                 ${dashboard_pg_label_dashboard}   
    
    
            
