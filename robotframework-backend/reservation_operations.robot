*** Settings ***
Library                              HttpLibrary.HTTP
Library                              String
Library                              Collections
Library                              DateTime
Resource                             api_variables.robot

*** Variables ***

#GET endpoints
${get_all_reservations_endpoint}=         /hotel-rest/webresources/hotelreservation
${get_reservation_endpoint}=              /hotel-rest/webresources/hotelreservation/            #the id should be included
${get_reservations_counter_endpoint}=     /hotel-rest/webresources/hotelreservation/count

#POST endpoint
${post_create_new_reservation_endpoint}=    /hotel-rest/webresources/hotelreservation

#PUT endpoint
${put_update_reservation_endpoint}=         /hotel-rest//webresources/hotelreservation/          #the id should be included   

#DELETE endpoint
${delete_reservation_endpoint}=             /hotel-rest/webresources/hotelreservation/          #the id should be included

*** Keywords ***

Create Reservation Data 
    #reservation
    ${id}=                        Set Variable                  100
    ${entryDate}=                 Set Variable        1452602800000
    ${exitDate}=                  Set Variable         1452602800000 
    ${priceDaily_number_first}=         Generate Random String        1          123456789
    ${priceDaily_number_last}=          Generate Random String        5          [NUMBERS]
    ${priceDaily}=                  Catenate      SEPARATOR=      ${priceDaily_number_first}        ${priceDaily_number_last}  
    Set Suite Variable            ${reservation_priceDaily_suite}      ${priceDaily}           
    
    #client
    ${clientId}=                  Get Json Value        ${client_body_suite}         /id     
    ${name}=                      Get Json Value        ${client_body_suite}         /name     
    ${createDate}=                Get Json Value        ${client_body_suite}         /createDate     
    ${email}=                     Get Json Value        ${client_body_suite}         /email     
    ${gender}=                    Get Json Value        ${client_body_suite}         /gender     
    ${socialSecurityNumber}=      Get Json Value        ${client_body_suite}         /socialSecurityNumber     
    #Remove " in strings so that they will not get an extra " when doing Stringify Json
    ${name}=                      Remove String         ${name}                  \"
    ${createDate}=                Remove String         ${createDate}            \"
    ${email}=                     Remove String         ${email}                 \"
    ${gender}=                    Remove String         ${gender}                \"
    ${socialSecurityNumber}=      Remove String         ${socialSecurityNumber}  \"
    ${clientId}=                  Convert to Integer         ${clientId}
    ${createDate}=                Convert to Integer         ${createDate}
    ${dictionary_client}=         Create Dictionary     id=${clientId}    name=${name}    createDate=${createDate}    email=${email}    gender=${gender}    socialSecurityNumber=${socialSecurityNumber}                        
    Log to Console                \n"Dictionary client:"
    Log to Console                ${dictionary_client}
    
    #bedroom
    ${bedroomId}=               Get Json Value        ${bedroom_body_suite}         /id     
    ${description}=             Get Json Value        ${bedroom_body_suite}         /description     
    ${floor}=                   Get Json Value        ${bedroom_body_suite}         /floor    
    ${number}=                  Get Json Value        ${bedroom_body_suite}         /number
    ${b_priceDaily}=            Get Json Value        ${bedroom_body_suite}         /priceDaily
       
    ${statusId}=                Get Json Value        ${bedroom_body_suite}         /bedroomStatusId/id
    ${statusCode}=              Get Json Value        ${bedroom_body_suite}         /bedroomStatusId/code
    ${statusName}=              Get Json Value        ${bedroom_body_suite}         /bedroomStatusId/name
    ${typeId}=                  Get Json Value        ${bedroom_body_suite}         /typeBedroomId/id
    ${typeName}=                Get Json Value        ${bedroom_body_suite}         /typeBedroomId/name
    
    ${description}=             Remove String         ${description}                \"
    ${statusName}=              Remove String         ${statusName}                 \"
    ${typeName}=                Remove String         ${typeName}                   \"
    ${statusName}=              Remove String         ${statusName}                 \\
    ${typeName}=                Remove String         ${typeName}                   \\
    
    ${dictionary_status}=       Create Dictionary         id=${statusId}    code=${statusCode}    name=${statusName}
    ${dictionary_id}=           Create Dictionary         id=${typeId}      name=${typeName}
    ${dictionary_bedroom}=      Create Dictionary         id=${bedroomId}   description=${description}    floor=${floor}    number=${number}    priceDaily=${b_priceDaily}    bedroomStatusId=${dictionary_status}   typeBedroomId=${dictionary_id}
    
    Log to Console                \n"Dictionary bedroom:"
    Log to Console                ${dictionary_bedroom}

    #reserveration status
    ${statusId}=                  Set Variable                  1
    ${statusCode}=                Set Variable                  1  
    ${statusName}=                Set Variable                  CONFIRMED    
    ${r_dictionary}=              Create Dictionary     id=${statusId}    code=${statusCode}   name=${statusName}
    Log to Console                \n"Reservation status dictionary:"
    Log to console                ${r_dictionary}

    #get last created client and bedroom and put it all together
    ${dictionary}=                Create Dictionary     id=${id}    entryDate=${entryDate}    exitDate=${exitDate}    priceDaily=${priceDaily}    bedroomId=${dictionary_bedroom}    clientId=${dictionary_client}  reservationStatusId=${r_dictionary}
    ${reservation_json}=          Stringify Json        ${dictionary}
    Log to Console                \n"Reservation dictionary:"
    Log to Console                 ${reservation_json}
    [Return]                       ${reservation_json}             

Create New Reservation
    ${request_body}=           Create Reservation Data
    Create Http Context        ${http_context}                  ${http_variable}
    Set Request Header         Content-Type                     ${header_content_json}
    Set Request Header         Accept                           ${header_accept_all}        
    Set Request Body           ${request_body}        
    POST                       ${post_create_new_reservation_endpoint}
    ${status_code}=            Get Response Status
    Log to Console             ${status_code}
    Should contain             ${status_code}	                 ${status_code_No_Content} 
    # Check that last created reservate contains the correct description
    ${newReservation}=         Get Last Created Reservation
    Log to Console             ${reservation_priceDaily_suite}
    Should contain             ${newReservation}                     ${reservation_priceDaily_suite}  
    
Get ID of The Last Reservation
    Create Http Context                        ${http_context}      ${http_variable}
    #Get all reservations
    GET                                        ${get_all_reservations_endpoint}    
    ${response_status_first_request}=          Get Response Status
    Should Contain                             ${response_status_first_request}     200
    ${body_first_request}=                     Get Response Body
    # Get number of reservations
    ${number_of_reservations}=                 Get Total Number of Reservations
    ${last_index}=                             Evaluate              ${number_of_reservations}-1
    ${json_id}=                                Get Json Value        ${body_first_request}         /${last_index}/id        
    Log to Console                             ${json_id}         
    [Return]                                   ${json_id}
 
Get Last Created Reservation        
    ${reservationId}=                    Get ID of The Last Reservation
    ${get_reservation_endpoint}=         Catenate       SEPARATOR=       ${get_reservation_endpoint}        ${reservationId}
    GET                                  ${get_reservation_endpoint}
    ${status_code}=                      Get Response Status
    ${reservation_body}=                 Get Response Body
    Log to Console                       ${status_code}
    Log to Console                       ${reservation_body}
    Should contain                       ${status_code}	                      ${status_code_OK} 
    [Return]                             ${reservation_body}                 
    
Get Total Number of Reservations
    Create Http Context                ${http_context}                      ${http_variable}
    GET                                ${get_reservations_counter_endpoint}
    ${status_code}=                    Get Response Status
    ${response_body}=                  Get Response Body
    Log to Console                     ${status_code}
    Log to Console                     ${response_body}
    Should contain                     ${status_code}	                      ${status_code_OK} 
    [Return]                           ${response_body}

Get All Reservations
    Create Http Context            ${http_context}                      ${http_variable}
    GET                            ${get_all_reservations_endpoint}
    ${status_code}=                Get Response Status
    ${response_body}=              Get Response Body
    Log to Console                 ${status_code}
    Log to Console                 ${response_body}
    Should contain                 ${status_code}	                      ${status_code_OK}     
    
Delete Reservation
    Create Http Context            ${http_context}                  ${http_variable}
    ${reservationId}=              Get ID of The Last Reservation
    Log to Console                 ${reservationId}
    ${delete_reservation_endpoint}=     Catenate       SEPARATOR=        ${delete_reservation_endpoint}        ${reservationId}
    DELETE                         ${delete_reservation_endpoint}
    ${status_code}=                Get Response Status
    Log to Console                 ${status_code}
    Should contain                 ${status_code}	                ${status_code_No_Content} 
    # Assert that current last reservation doesn't contain the daily price of the recently created reservation
    ${lastReservation}=            Get Last Created Reservation
    Log to Console                 ${reservation_priceDaily_suite}
    Should not contain             ${lastReservation}                 ${reservation_priceDaily_suite}       