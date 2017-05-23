*** Settings ***
Resource                            page_new_user.robot
Resource                            ../page_dashboard.robot

*** Variables ***
${userlist_label_user}              List

${userlist_button_createnew}        xpath=//a[@class='btn btn-primary']
${userlist_button_index}            xpath=//a[@class='btn btn-default']
${userlist_message_success}         User was successfully deleted.


*** Keywords ***
Go to create new user form   
    Page should contain element              ${userlist_button_createnew}
    Click Element                            ${userlist_button_createnew}
    Wait Until Page Contains                 ${usernew_label_title}
            
Perform delete user
    ${temp_str}=                    Catenate    SEPARATOR=    xpath=//td[text()='    ${user_login_suite}
    ${userlist_button_delete}=      Catenate    SEPARATOR=    ${temp_str}            ']/following-sibling::td/a[text()='Delete']     
    Click Element                            ${userlist_button_delete}
    Wait Until Page Contains                 ${userlist_message_success}     
    Page should not contain                  ${user_login_suite}

Back to dashboard from user list
    Click Element                            ${userlist_button_index}
    Wait Until Page Contains                 ${dashboard_pg_label_dashboard}   
    
    
            
