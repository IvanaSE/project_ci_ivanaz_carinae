*** Settings ***
Library                              HttpLibrary.HTTP
Library                              String
Library                              Collections
Resource                             api_variables.robot

*** Variables ***

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
    ${number}=                    Generate Random String        4          123456789
    # Make sure first digit is not 0 
    ${priceDaily_number_first}=         Generate Random String        1          123456789
    ${priceDaily_number_last}=          Generate Random String        2          [NUMBERS]
    ${priceDaily} =              Catenate      SEPARATOR=      ${priceDaily_number_first}        ${priceDaily_number_last}    
    # Status = Busy
    ${statusId}=                  Set Variable                  2
    ${statusCode}=                Set Variable                  1  
    ${statusName}=                Set Variable                  BUSY
    # Bedroom type = Top bed twin
    ${typeId}=                    Set Variable                  4
    ${typeName}=                  Set Variable                  TOP BED TWIN
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
    
Update Bedroom Data Price    [Arguments]    ${bedroom}       ${update_value} 
    ${id}=                        Get Json Value             ${bedroom}         /id
    ${description}=               Get Json Value             ${bedroom}         /description
    ${floor}=                     Get Json Value             ${bedroom}         /floor
    ${number}=                    Get Json Value             ${bedroom}         /number
    ${priceDaily}=                Set Variable               ${update_value}
    Set Suite Variable            ${updated_price_suite}     ${priceDaily}       
    ${statusId}=                  Get Json Value             ${bedroom}         /bedroomStatusId/id
    ${statusCode}=                Get Json Value             ${bedroom}         /bedroomStatusId/code
    ${statusName}=                Get Json Value             ${bedroom}         /bedroomStatusId/name
    ${typeId}=                    Get Json Value             ${bedroom}         /typeBedroomId/id
    ${typeName}=                  Get Json Value             ${bedroom}         /typeBedroomId/name
    ${description}=               Remove String             ${description}        \"
    ${statusName}=                Remove String             ${statusName}         \"
    ${typeName}=                  Remove String             ${typeName}           \"
    ${statusName}=                Remove String             ${statusName}         \\
    ${typeName}=                  Remove String             ${typeName}           \\
    ${dictionary_status}=         Create Dictionary         id=${statusId}    code=${statusCode}    name=${statusName}
    ${dictionary_id}=             Create Dictionary         id=${typeId}    name=${typeName}
    ${dictionary}=                Create Dictionary         id=${id}    description=${description}    floor=${floor}    number=${number}    priceDaily=${priceDaily}    bedroomStatusId=${dictionary_status}   typeBedroomId=${dictionary_id}
    ${client_json}=               Stringify Json            ${dictionary}
    Log to Console                \n"Updated json data:"
    Log to Console                ${client_json}
    [Return]                      ${client_json}       
    
Update Bedroom Price
    # Get last created bedroom
    ${bedroomBody}=                Get Last Created Bedroom
    ${bedroomId}=                  Get Json Value                 ${bedroomBody}         /id            
    # Generate new price and update bedroom data
    ${priceDaily_number_first}=         Generate Random String        1          123456789
    ${priceDaily_number_last}=          Generate Random String        2          [NUMBERS]
    ${priceDaily} =              Catenate      SEPARATOR=      ${priceDaily_number_first}        ${priceDaily_number_last}    
    ${request_body}=               Update Bedroom Data Price        ${bedroomBody}        ${priceDaily}   
    # Set request body to updated bedroom and PUT          
    Create Http Context            ${http_context}                ${http_variable}
    Set Request Header             Content-Type                   ${header_content_json}
    Set Request Header             Accept                         ${header_accept_all}        
    Set Request Body               ${request_body}        
    ${put_update_bedroom_endpoint}=     Catenate       SEPARATOR=      ${put_update_bedroom_endpoint}        ${bedroomId}
    PUT                            ${put_update_bedroom_endpoint}
    ${status_code}=                Get Response Status
    Log to Console                 ${status_code}
    Should contain                 ${status_code}	                  ${status_code_No_Content} 
    # Assert that last created client contains the updated name
    ${updatedBedroom}=              Get Last Created Bedroom
    Log to Console                 ${updatedBedroom}
    Log to Console                 ${updated_price_suite}
    Should contain                 ${updatedBedroom}                 ${updated_price_suite}        
    
Delete Bedroom
    Create Http Context            ${http_context}                  ${http_variable}
    ${bedroomId}=                   Get ID of The Last Bedroom
    Log to Console                 ${bedroomId}
    ${delete_bedroom_endpoint}=     Catenate       SEPARATOR=        ${delete_bedroom_endpoint}        ${bedroomId}
    DELETE                         ${delete_bedroom_endpoint}
    ${status_code}=                Get Response Status
    Log to Console                 ${status_code}
    Should contain                 ${status_code}	                ${status_code_No_Content} 
    # Assert that current last client doesn't contain the name of the recently created client
    ${lastBedroom}=                 Get Last Created Bedroom
    Should not contain             ${lastBedroom}                 ${room_description_suite}          