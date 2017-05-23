*** Settings ***
Resource                                    page_list_user.robot
Library                                     String

*** Variables ***
${usernew_label_title}                      Create New User
${usernew_select_usertype}                  id=typeUser
${usernew_textfield_login}                  id=login
${usernew_textfield_password}               id=password
${usernew_textfield_retype_password}        id=retypingPassword
${usernew_select_client}                    id=clientId
${usernew_select_userstatus}                id=userStatusId

${usernew_usertype_common}                  2
${usernew_userstatus_active}                1

${usernew_button_save}                      xpath=//a[text()='Save']
${usernew_button_show_all_users}            xpath=//a[text()='Show All Users']
${usernew_message_success}                  User was successfully created.

*** Keywords ***
Create new active common user
    #Enter data
    Select From List By Value                ${usernew_select_usertype}                ${usernew_usertype_common}
    ${user_login}=                           Generate Random String        8           [LOWER]
    ${user_password} =                       Generate Random String        65          
    Set Suite Variable                       ${user_login_suite}                       ${user_login}       
    Set Suite Variable                       ${user_password_suite}                    ${user_password}       
    Input text                               ${usernew_textfield_login}                ${user_login}
    Input text                               ${usernew_textfield_password}             ${user_password}
    Input text                               ${usernew_textfield_retype_password}      ${user_password}
    Select From List By Value                ${usernew_select_client}                  ${client_id_suite}
    Select From List By Value                ${usernew_select_userstatus}              ${usernew_userstatus_active}
    #Save and go back to user list
    Click Element                            ${usernew_button_save} 
    Wait Until Page Contains                 ${usernew_message_success}     
    Click Element                            ${usernew_button_show_all_users}          
    Wait Until Page Contains                 ${userlist_label_user}
    Page should contain                      ${user_login}    
    






