Param (
       [Parameter(mandatory=$true)][boolean]$RunEnabled = $true,
       #region Parameter User context
       [Parameter(mandatory=$true)][string]$user_WebexID,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_firstname,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_lastname,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_title,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_categoryid,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_description,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_officeGreeting,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_company,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_email,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_password,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_passwordHint,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_passwordHintAnswer,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_language,
       [Parameter(mandatory=$false)][string][AllowEmptyString()]$user_locale,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_timeZoneId,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$user_active = "ACTIVATED",
       #endregion
       #region Parameter Address context
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$address_address1,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$address_address2,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$address_city,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$address_state,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$address_zipcode,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$address_country,
       #endregion
       #region Parameter Privilege context
       [Parameter(mandatory=$true)][boolean]$privilege_host,
       [Parameter(mandatory=$true)][boolean]$privilege_siteAdmin,
       [Parameter(mandatory=$true)][boolean]$privilege_roSiteAdmin,
       [Parameter(mandatory=$true)][boolean]$privilege_teleConfTollFreeCallIn,
       [Parameter(mandatory=$true)][boolean]$privilege_teleConfCallOutInternational,
       [Parameter(mandatory=$true)][boolean]$privilege_teleConfCallIn,
       [Parameter(mandatory=$true)][boolean]$privilege_voiceOverIp,
       [Parameter(mandatory=$true)][boolean]$privilege_labAdmin,
       [Parameter(mandatory=$true)][boolean]$privilege_otherTelephony,
       [Parameter(mandatory=$true)][boolean]$privilege_teleConfCallInInternational,
       [Parameter(mandatory=$true)][boolean]$privilege_attendeeOnly,
       [Parameter(mandatory=$true)][boolean]$privilege_recordingEditor,
       [Parameter(mandatory=$true)][boolean]$privilege_meetingAssist,
       [Parameter(mandatory=$true)][boolean]$privilege_HQvideo,
       #endregion
       #region Parameter Security context
       [Parameter(mandatory=$true)][boolean]$security_forceChangePassword,
       [Parameter(mandatory=$true)][boolean]$security_resetPassword,
       [Parameter(mandatory=$true)][boolean]$security_lockAccount,
       #endregion
       #region Parameter MyWebEx context
       [Parameter(mandatory=$true)][boolean]$myWebex_isMyWebExPro,
       [Parameter(mandatory=$true)][boolean]$myWebex_myContact,
       [Parameter(mandatory=$true)][boolean]$myWebex_myProfile,
       [Parameter(mandatory=$true)][boolean]$myWebex_myMeetings,
       [Parameter(mandatory=$true)][boolean]$myWebex_myFolders,
       [Parameter(mandatory=$true)][boolean]$myWebex_trainingRecordings,
       [Parameter(mandatory=$true)][boolean]$myWebex_recordedEvents,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$myWebex_totalStorageSize,
       [Parameter(mandatory=$true)][boolean]$myWebex_myReports,
       [Parameter(mandatory=$true)][string][AllowEmptyString()]$myWebex_myComputer,
       [Parameter(mandatory=$true)][boolean]$myWebex_personalMeetingRoom,
       [Parameter(mandatory=$true)][boolean]$myWebex_myPartnerLinks,
       [Parameter(mandatory=$true)][boolean]$myWebex_myWorkspaces
       #endregion
)


# Get the amount of array items that have a value and return it to $sectionCount
function Get-XMLElementCount([array]$array, [string]$section, [string]$element){
$XMLcount = 0
    foreach ($item in $array) {
        if ($item.section -eq $element) {
            if ($item.value.GetType().fullname -eq "system.boolean") {
                if ($item.value -ne $null) { $XMLcount += 1 }  
            } elseif ($item.value.GetType().fullname  -eq "system.string") {
                if ($item.value -ne "") { $XMLcount += 1 } 
            }
        }
    }

return $XMLcount
}

function Get-WebexGeneratedProperties([array]$array, [string]$section) {
# Get a uniq list of values in the array from the section/collumn specified.
$array.$section | Get-Unique | ForEach-Object {
     $sectionName = $_ 
     # Get the amount of array items that have a value and return it to $sectionCount - See function Get-XMLElementCount
     $sectionCount = Get-XMLElementCount -array $array -section $section -element $sectionName
        # If the section has values add them to the XML request
        if ($sectionCount -ne 0) {
            # If the section name is user then don't add a tag around the values
            if ($sectionName -eq "user") {
                # For each element in the section create a value in the result XML
                foreach ($object in $array) {
                    $oSection = $object.section
                    $oElement = $object.element
                    $oValue = $object.value
                    $oValueType = $oValue.GetType().fullname

                    if ($oSection -eq $sectionName) {
                        if ($oValue -eq "" -AND $oValueType -eq "System.Boolean") {
                            # If the incoming value is empty do not add the value to the XML
                            #$result += "<$oElement>False</$oElement>"
                        } elseif ($oValue -ne "" -AND $oValueType -eq "System.Boolean") {
                            $result += "<$oElement>$oValue</$oElement>"
                        } elseif ($oValue -ne "" -AND $oValueType -eq "System.String") {
                            $result += "<$oElement>$oValue</$oElement>"
                        }
                    }
                }
            } else {
                $result += "<$sectionName>"
                foreach ($object in $array) {
                    $oSection = $object.section
                    $oElement = $object.element
                    $oValue = $object.value
                    $oValueType = $oValue.GetType().fullname

                    if ($oSection -eq $sectionName) {
                        if ($oValue -eq "" -AND $oValueType -eq "System.Boolean") {
                            # If the incoming value is empty do not add the value to the XML
                            #$result += "<$oElement>False</$oElement>"
                        } elseif ($oValue -ne "" -AND $oValueType -eq "System.Boolean") {
                            $result += "<$oElement>$oValue</$oElement>"
                        } elseif ($oValue -ne "" -AND $oValueType -eq "System.String") {
                            $result += "<$oElement>$oValue</$oElement>"
                        }
                    }         
                }
                $result += "</$sectionName>"
            }
        }
    }
    return $result
}

#region Generate XML Array
$webexPropertieArray = ("user","webExId",$user_WebexID), 
                    ("user","firstName",$user_firstname),
                    ("user","lastName",$user_lastname),
                    ("user","title",$user_title),
                    ("user","categoryId",$user_categoryid),
                    ("user","description",$user_description),
                    ("user","officeGreeting",$user_officeGreeting),
                    ("user","company",$user_company),
                    ("user","email",$user_email),
                    ("user","password",$user_password),
                    ("user","passwordHint",$user_passwordHint),
                    ("user","passwordHintAnswer",$user_passwordHintAnswer),
                    ("user","language",$user_language),
                    ("user","locale",$user_locale),
                    ("user","timeZoneID",$user_timeZoneId),
                    ("user","active",$user_active),
                    ("address","address1",$address_address1),
                    ("address","address2",$address_address2),
                    ("address","city",$address_city),
                    ("address","state",$address_state),
                    ("address","zipCode",$address_zipcode),
                    ("address","country",$address_country),
                    ("privilege","host",$privilege_host),
                    ("privilege","siteAdmin",$privilege_siteAdmin),
                    ("privilege","roSiteAdmin",$privilege_roSiteAdmin),
                    ("privilege","teleConfTollFreeCallIn",$privilege_teleConfTollFreeCallIn),
                    ("privilege","teleConfCallOutInternational",$privilege_teleConfCallOutInternational),
                    ("privilege","teleConfCallIn",$privilege_teleConfCallIn),
                    ("privilege","voiceOverIp",$privilege_voiceOverIp),
                    ("privilege","labAdmin",$privilege_labAdmin),
                    ("privilege","otherTelephony",$privilege_otherTelephony),
                    ("privilege","teleConfCallInInternational",$privilege_teleConfCallInInternational),
                    ("privilege","attendeeOnly",$privilege_attendeeOnly),
                    ("privilege","recordingEditor",$privilege_recordingEditor),
                    ("privilege","meetingAssist",$privilege_meetingAssist),
                    ("privilege","HQvideo",$privilege_HQvideo),
                    ("security","forceChangePassword",$security_forceChangePassword),
                    ("security","resetPassword",$security_resetPassword),
                    ("security","lockAccount",$security_lockAccount),
                    ("myWebEx","isMyWebExPro",$myWebex_isMyWebExPro),
                    ("myWebEx","myContact",$myWebex_myContact),
                    ("myWebEx","myProfile",$myWebex_myProfile),
                    ("myWebEx","myMeetings",$myWebex_myMeetings),
                    ("myWebEx","myFolders",$myWebex_myFolders),
                    ("myWebEx","trainingRecordings",$myWebex_trainingRecordings),
                    ("myWebEx","recordedEvents",$myWebex_recordedEvents),
                    ("myWebEx","totalStorageSize",$myWebex_totalStorageSize),
                    ("myWebEx","myReports",$myWebex_myReports),
                    ("myWebEx","myComputer",$myWebex_myComputer),
                    ("myWebEx","personalMeetingRoom",$myWebex_personalMeetingRoom),
                    ("myWebEx","myWorkspaces",$myWebex_myWorkspaces) |
                    ForEach-Object {[pscustomobject]@{Section = $_[0]; Element = $_[1]; Value = $_[2]}}
#endregion

#region Webex Login
$WebExSiteName = "WebexSiteName"
$WebExSiteID = "WebexSiteID"
$WebExPartnerID = "WebexPartnerID"
$WebExServiceAccountName = "WebexAdminID"
$WebExServiceAccountPassword = "WebexAdminPassword"
#endregion

if ($RunEnabled -eq $true) {
#region Create XML
$XMLString += "<?xml version=""1.0"" encoding=""UTF-8"" ?>"
$XMLString += "<serv:message xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:serv=""http://www.webex.com/schemas/2002/06/service"">"
$XMLString += "<header>"
$XMLString += "<securityContext>"
$XMLString += "<webExID>$WebExServiceAccountName</webExID>"
$XMLString += "<password>$WebExServiceAccountPassword</password>"
$XMLString += "<siteID>$WebExSiteID</siteID>"
$XMLString += "<partnerID>$WebExPartnerID</partnerID>"
$XMLString += "</securityContext>"
$XMLString += "</header>"
$XMLString += "<body>"
$XMLString += "<bodyContent xsi:type=""java:com.webex.service.binding.user.CreateUser"">"
#XML generate values - See function Get-WebexGeneratedProperties
$XMLString += Get-WebexGeneratedProperties -array $webexPropertieArray -section Section

$XMLString += "</bodyContent>"
$XMLString += "</body>"
$XMLString += "</serv:message>"

#Converts XMLString to a XML object
$XML = [xml]$XMLString
#endregion

    #region WebEx XML API URL Request 
    $URL = "https://$WebExSiteName/WBXService/XMLService"

    # Send WebRequest and save to URLResponse
    try {
        $URLResponse = Invoke-WebRequest -Uri $URL -Method Post -ContentType 'text/xml' -TimeoutSec 120 -Body $XML
    } catch {
        Write-Host "Webex: Unable to send XML request"
    }
    #endregion

    #region XML Response
    $XMLResponse = [xml]$URLResponse

    #Read through the XML file and create a PS Customeobject
    $XMLNodes = $XMLResponse.SelectNodes("//*")
    $XMLResult = $XMLNodes | ForEach-Object {
        $nodeDisplayName = $_.LocalName 
        $nodeValue = $_.'#text'
        
        [pscustomobject]@{DisplayName = $nodeDisplayName; Value = $nodeValue}
    }

    # Response Result and Reason from XML
    foreach ($node in $XMLResult) {
       $nodeKey = $node.DisplayName
       $nodeValue = $node.Value
        if ($nodeKey -eq "result") {
            Write-Host "Webex result: $nodeValue"
            
            if ($nodeValue -eq "SUCCESS") {
                Write-Host "Webex: Created user [$user_WebexID]" 
            }
        }
        if ($nodeKey -eq "reason") {
            Write-Host "Webex reason: $nodeValue"
        }
    }
    #endregion

}