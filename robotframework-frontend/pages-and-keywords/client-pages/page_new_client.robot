*** Settings ***
Resource                                    page_list_client.robot
Library                                     String

*** Variables ***
${clientnew_label_title}                    Create New Client
${clientnew_textfield_name}                 id=name
${clientnew_textfield_email}                id=email
${clientnew_textfield_social_number}        name=socialSecurityNumber
${clientnew_radiobtn_male}                  id=gender:0
${clientnew_radiobtn_female}                id=gender:1
${clientnew_button_save}                    xpath=//a[text()='Save']
${clientnew_button_show_all_clients}        xpath=//a[text()='Show All Clients']
${clientnew_message_success}                Client was successfully created.

*** Keywords ***
Create new female client
    #Enter data
    ${client_name}=                          Generate Random String        10        [LOWER]
    ${client_email} =                        Catenate      SEPARATOR=      ${client_name}        @test.com    
    ${client_security_number} =              Generate Random String        7          [NUMBERS]
    Set Suite Variable                       ${client_name_suite}                      ${client_name}       
    Set Suite Variable                       ${client_email_suite}                     ${client_email}       
    Set Suite Variable                       ${client_security_number_suite}           ${client_security_number}       
    Input text                               ${clientnew_textfield_name}               ${client_name}
    Input text                               ${clientnew_textfield_email}              ${client_email}
    Select checkbox                          ${clientnew_radiobtn_female}
    Input text                               ${clientnew_textfield_social_number}      ${client_security_number}
    #Save and go back to client list
    Click Element                            ${clientnew_button_save} 
    Wait Until Page Contains                 ${clientnew_message_success}     
    Click Element                            ${clientnew_button_show_all_clients}          
    Wait Until Page Contains                 ${clientlist_label_clients}
    Page should contain                      ${client_name}    
    #Save ID for the new client
    ${client_temp_str}=                      Catenate      SEPARATOR=      xpath=//td[text()='    ${client_name_suite}
    ${client_temp_str2}=                     Catenate      SEPARATOR=      ${client_temp_str}     ']/preceding-sibling::td[1]
    ${client_id}=                            Get text      ${client_temp_str2}        
    Set Suite Variable                       ${client_id_suite}                      ${client_id}       
    






