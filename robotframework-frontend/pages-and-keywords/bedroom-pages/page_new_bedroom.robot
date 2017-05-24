*** Settings ***
Resource                                    page_list_bedroom.robot
Library                                     String

*** Variables ***
${bedroomnew_label_title}                    Create New Bedroom
${bedroomnew_button_save}                    xpath=//a[@class='btn btn-primary']
${bedroomnew_button_show_all_bedrooms}        xpath=//a[text()='Show All Bedrooms']
${bedroomnew_message_success}                Bedroom was successfully created.

${bedroomnew_textfield_description}          id=description
${bedroomnew_textfield_floor}                id=floor
${bedroomnew_textfield_number}               id=number
${bedroomnew_textfield_pricedaily}           id=priceDaily
${bedroomnew_select_status}                  id=bedroomStatusId  
${bedroomnew_select_bedroomtype}             id=typeBedroomId

${bedroomnew_option_status_vacant}               1
${bedroomnew_option_bedroomtype_top_bed_king}    5


*** Keywords ***
Create new bedroom Top Bed King Vacant
    #Enter data
    ${room_name} =                           Generate Random String        15         [UPPER]
    ${room_floor} =                          Generate Random String        1          123456789
    # Make sure first digit is not 0 since initial 0 are removed
    ${room_number_first}=                    Generate Random String        1          123456789
    ${room_number_last}=                     Generate Random String        3          [NUMBERS]
    ${room_number} =                         Catenate      SEPARATOR=      ${room_number_first}        ${room_number_last}    
    ${room_price_first}=                     Generate Random String        1          123456789
    ${room_price_last}=                      Generate Random String        4          [NUMBERS]
    ${room_price} =                          Catenate      SEPARATOR=      ${room_price_first}          ${room_price_last}    
    Set Suite Variable                       ${room_name_suite}                       ${room_name}       
    Set Suite Variable                       ${room_floor_suite}                      ${room_floor}       
    Set Suite Variable                       ${room_number_suite}                     ${room_number}       
    Input text                               ${bedroomnew_textfield_description}      ${room_name}
    Input text                               ${bedroomnew_textfield_floor}            ${room_floor}
    Input text                               ${bedroomnew_textfield_number}           ${room_number}
    Input text                               ${bedroomnew_textfield_pricedaily}       ${room_price}
    Select From List By Value                ${bedroomnew_select_status}              ${bedroomnew_option_status_vacant}
    Select From List By Value                ${bedroomnew_select_bedroomtype}         ${bedroomnew_option_bedroomtype_top_bed_king}
    #Save and go back to bedroom list
    Click Element                            ${bedroomnew_button_save}
    Wait Until Page Contains                 ${bedroomnew_message_success}
    Click Element                            ${bedroomnew_button_show_all_bedrooms}   
    Wait Until Page Contains                 ${bedroomlist_label}
    Page should contain                      ${room_name}     
    #Save ID for the new bedroom
    ${bedroom_temp_str}=                     Catenate      SEPARATOR=      xpath=//td[text()='        ${room_name_suite}
    ${bedroom_temp_str2}=                    Catenate      SEPARATOR=      ${bedroom_temp_str}        ']/preceding-sibling::td[1]
    ${bedroom_id}=                           Get text      ${bedroom_temp_str2}        
    Set Suite Variable                       ${bedroom_id_suite}                      ${bedroom_id}       
