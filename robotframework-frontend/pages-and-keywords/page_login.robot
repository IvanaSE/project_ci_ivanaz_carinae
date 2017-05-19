*** Settings ***
Resource                        ../credentials/login_variables.robot
Resource                        page_dashboard.robot


*** Variables ***
${login_pg_label_login}            Login
${login_pg_titel_login}            Hotel Accomodation - login page

#Login form
${login_pg_textfield_user}        login
${login_pg_textfield_password}    senha
${login_pg_button_login}          loginBtn



*** Keywords ***
Login into the system    
    Input Text                               id=${login_pg_textfield_user}                     ${username_admin}
    Input Text                               id=${login_pg_textfield_password}                 ${password_admin}
    Click Element                            id=${login_pg_button_login}
    Wait Until Page Contains                 ${dashboard_pg_label_dashboard}   
