*** Settings ***

*** Variables ***
${bedroomview_label_title}                         View
#${bedroomview_button_show_all_bedrooms}            xpath=//*[@id="j_idt51"]/a[4]
${bedroomview_button_show_all_bedrooms}            xpath=//*[text()='Show All Bedrooms']


*** Keywords ***
Back to bedroom list    
    Click Element                            ${bedroomview_button_show_all_bedrooms}   
    Wait Until Page Contains                 ${bedroomlist_label}
    Page should contain                      ${room_name_suite}     
    
    