*** Settings ***
Library                              HttpLibrary.HTTP
Library                              String
Library                              Collections

*** Variables ***
${http_context}=                     localhost:8080
${http_variable}=                    http
${header_content_json}               application/json
${header_accept_all}                 */*         

${status_code_OK}                    200
${status_code_No_Content}            204

#GET endpoints
${get_all_bedrooms_endpoint}=         /hotel-rest/webresources/bedroom
${get_bedroom_endpoint}=              /hotel-rest/webresources/bedroom/            #the id should be included
${get_bedrooms_counter_endpoint}=     /hotel-rest/webresources/bedroom/count

#POST endpoint
${post_create_new_bedroom_endpoint}=    /hotel-rest/webresources/bedroom

#PUT endpoint
${put_update_bedroom_endpoint}=         /hotel-rest/webresources/bedroom/          #the id should be included   

#DELETE endpoint
${delete_bedroom_endpoint}=            /hotel-rest/webresources/bedroom/          #the id should be included

*** Keywords ***

    
Create Bedroom Data 
    ${id}=                        Set Variable                  100
    ${description}=               Generate Random String        15        [UPPER]
    Set Suite Variable            ${room_description_suite}               ${description}       
    ${floor}=                     Generate Random String        1          [NUMBERS]
    ${number}=                    Generate Random String        4          [NUMBERS]
    ${priceDaily}=                Generate Random String        3          [NUMBERS]
    # Status = Busy
    ${statusId}=                  Set Variable                  2
    ${statusCode}=                Set Variable                  1  
    ${statusName}=                Set Variable                  "BUSY"
    # Bedroom type = Top bed twin
    ${typeId}=                    Set Variable                  4
    ${typeName}=                  Set Variable                  "TOP BED TWIN"
    ${dictionary_status}=         Create Dictionary     id=${statusId}    code=${statusCode}    name=${statusName}
    ${dictionary_id}=             Create Dictionary     id=${typeId}    name=${typeName}
    ${dictionary}=                Create Dictionary     id=${id}    description=${description}    floor=${floor}    number=${number}    priceDaily=${priceDaily}    bedroomStatusId=${dictionary_status}   typeBedroomId=${dictionary_id}
    ${client_json}=               Stringify Json        ${dictionary}
    Log to Console                 ${client_json}
    [Return]                       ${client_json}             

Create New Bedroom
    ${request_body}=           Create Bedroom Data
    Create Http Context        ${http_context}                  ${http_variable}
    Set Request Header         Content-Type                     ${header_content_json}
    Set Request Header         Accept                           ${header_accept_all}        
    Set Request Body           ${request_body}        
    POST                       ${post_create_new_bedroom_endpoint}
    ${status_code}=            Get Response Status
    Log to Console             ${status_code}
    Should contain             ${status_code}	                 ${status_code_No_Content} 
    # Check that last created bedroom contains the correct description
    ${newBedroom}=             Get Last Created Bedroom
    Should contain             ${newBedroom}                     ${room_description_suite}           

Get ID of The Last Bedroom
    Create Http Context                        ${http_context}      ${http_variable}
    #Get all bedrooms
    GET                                        ${get_all_bedrooms_endpoint}    
    ${response_status_first_request}=          Get Response Status
    Should Contain                             ${response_status_first_request}     200
    ${body_first_request}=                     Get Response Body
    # Get number of bedrooms
    ${number_of_bedrooms}=                     Get Total Number of Bedrooms
    ${last_index}=                             Evaluate              ${number_of_bedrooms}-1
    ${json_id}=                                Get Json Value        ${body_first_request}         /${last_index}/id        
    Log to Console                             ${json_id}         
    [Return]                                   ${json_id}
 
Get Last Created Bedroom        
    ${bedroomId}=                    Get ID of The Last Bedroom
    ${get_bedroom_endpoint}=         Catenate       SEPARATOR=       ${get_bedroom_endpoint}        ${bedroomId}
    GET                              ${get_bedroom_endpoint}
    ${status_code}=                  Get Response Status
    ${bedroom_body}=                 Get Response Body
    Log to Console                   ${status_code}
    Log to Console                   ${bedroom_body}
    Should contain                   ${status_code}	                      ${status_code_OK} 
    [Return]                         ${bedroom_body}

Get Total Number of Bedrooms
    Create Http Context                ${http_context}                      ${http_variable}
    GET                                ${get_bedrooms_counter_endpoint}
    ${status_code}=                    Get Response Status
    ${response_body}=                  Get Response Body
    Log to Console                     ${status_code}
    Log to Console                     ${response_body}
    Should contain                     ${status_code}	                      ${status_code_OK} 
    [Return]                           ${response_body}

Get All Bedrooms
    Create Http Context            ${http_context}                      ${http_variable}
    GET                            ${get_all_bedrooms_endpoint}
    ${status_code}=                Get Response Status
    ${response_body}=              Get Response Body
    Log to Console                 ${status_code}
    Log to Console                 ${response_body}
    Should contain                 ${status_code}	                      ${status_code_OK} 
