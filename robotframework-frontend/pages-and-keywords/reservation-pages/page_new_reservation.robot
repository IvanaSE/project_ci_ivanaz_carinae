*** Settings ***
Resource                                    page_list_reservation.robot
Library                                     String
Library                                     DateTime 

*** Variables ***
${reservationnew_label_title}                    Create New Hotel Reservation
${reservationnew_button_save}                    xpath=//a[@class='btn btn-primary']
${reservationnew_button_show_all_reservations}   xpath=//a[text()='Show All Reservations']
${reservationnew_message_success}                Reservation was successfully created.
${reservationnew_textfield_entrydate}            id=entryDate
${reservationnew_textfield_exitdate}             id=exitDate
${reservationnew_select_bedroom}                 id=bedroomId
${reservationnew_select_client}                  id=clientId
${reservationnew_select_status}                  id=reservationStatusId  

${reservationnew_option_status_confirmed}         1


*** Keywords ***

Create new confirmed reservation
    # Entry date is today + 0-9 (random) days
    # Exit date is Entry date + 10-99 (random) days
    ${today}=                                   Get Current Date
    ${today}=                                   Convert Date                ${today}        result_format=%Y-%m-%d
    ${rand1} =                                  Generate Random String      1               [NUMBERS]
    ${rand2} =                                  Generate Random String      2               [NUMBERS]
    ${reservationnew_datepicker_entrydate}=     Add time to date            ${today}                                   ${rand1} days    result_format=%Y-%m-%d
    ${reservationnew_datepicker_exitdate}=      Add time to date            ${reservationnew_datepicker_entrydate}     ${rand2} days    result_format=%Y-%m-%d 
    
    #Enter data
    Clear Element Text                       ${reservationnew_textfield_entrydate}
    Input Text                               ${reservationnew_textfield_entrydate}        ${reservationnew_datepicker_entrydate}
    Clear Element Text                       ${reservationnew_textfield_exitdate}
    Input Text                               ${reservationnew_textfield_exitdate}         ${reservationnew_datepicker_exitdate}
    Select From List By Value                ${reservationnew_select_bedroom}             ${bedroom_id_suite}
    Select From List By Value                ${reservationnew_select_client}              ${client_id_suite}
    Select From List By Value                ${reservationnew_select_status}              ${reservationnew_option_status_confirmed}
    
    #Save and go back to reservation list  --- FAIL!!
    Click Element                            ${reservationnew_button_save} 
    Wait Until Page Contains                 ${reservationnew_message_success}     
    Click Element                            ${reservationnew_button_show_all_reservations}   
    Wait Until Page Contains                 ${reservationlist_label}
    Page should contain                      ${room_name_suite}
    Page should contain                      ${room_floor_suite}
    Page should contain                      ${room_number_suite}
    #Format date YYYY-MM-DD to YYYY/MM/DD
    ${reservationnew_datepicker_entrydate_formatted}=    Convert Date    ${reservationnew_datepicker_entrydate}    result_format=%Y/%m/%d
    ${reservationnew_datepicker_exitdate_formatted}=     Convert Date    ${reservationnew_datepicker_exitdate}     result_format=%Y/%m/%d
    Page should contain                      ${reservationnew_datepicker_entrydate_formatted}
    Page should contain                      ${reservationnew_datepicker_exitdate_formatted}
