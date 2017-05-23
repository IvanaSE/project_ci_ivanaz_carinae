*** Settings ***
Resource                            page_list_client.robot

*** Variables ***
${clientview_label_title}                        View
${clientview_button_show_all_cliente}            xpath=//*[@id="j_idt51"]/a[4]


*** Keywords ***
Back to client list    
    Click Element                            ${clientview_button_show_all_cliente}   
    Wait Until Page Contains                 ${clientlist_label_clients}
    Page should contain                      ${client_name_suite}     
    
    