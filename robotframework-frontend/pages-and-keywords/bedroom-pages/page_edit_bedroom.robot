*** Settings ***
Resource                                    page_list_bedroom.robot
Library                                     String


*** Variables ***

${bedroom_label_title}                       Edit Bedroom
${bedroom_textfield_description}             id=description 
${bedroom_button_save}                       xpath=//a[@class='btn btn-primary']
${bedroom_button_show_all_bedrooms}           xpath=//a[text()='Show All Bedrooms']
${bedroom_message_success}                   Bedroom was successfully updated.



*** Keywords ***
Edit bedroom name
    ${temp_str}=                    Catenate    SEPARATOR=    xpath=//td[text()='    ${room_name_suite}
    ${bedroom_button_edit}=         Catenate    SEPARATOR=    ${temp_str}            ']/following-sibling::td/a[text()='Edit']
    Click Element                            ${bedroom_button_edit}
    Wait Until Page Contains                 ${bedroom_label_title}
    ${room_name_edit} =                      Generate Random String        15         [UPPER]
    Input text                               ${bedroom_textfield_description}           ${room_name_edit}                            
    Click Element                            ${bedroom_button_save}  
    Wait Until Page Contains                 ${bedroom_message_success} 
    Click Element                            ${bedroom_button_show_all_bedrooms}  
    Wait Until Page Contains                 ${bedroomlist_label}
    Page Should Contain                      ${room_name_edit}
    