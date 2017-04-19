# Powershell-Webex
Powershell centered WebEx scripts. Because the lack of Powershell functionality for WebEx I've created the following scripts which uses WebEx XML API. The reason XML API has been used instead of URL API which is the second API for WebEx integration is basically because in contact with WebEx api/technical support they recommended the XML API because it has more functionality than the URL API and has been developed farther than the URL API.

## Summary
The following repository of scripts are created using Powershell and has been based on the Powershell 3.0 version. The scripts has been built for a third-party automation tool and might therefore be built different from what regular powershell scripts look like. All scripts work for themself without the third-party tool. 

You can either capsule the scripts into a function or add mandatory=$true in front of the parameters which is required for your script and run the script. If the script requires a specific parameter the parameter will be set to mandatory. 

__The following versions is confirmed working__
WebEx Site type: Enterprise
WebEx Service version: WBS32
WebEx Page version: 32.0.6.4
WebEx Client version: 32.0.0.129
Powershell version: 3.0

### Prerequisits
* WebEx company site
* Access to WebEx enterprise settings information
* Site Admin account

### To-do
* Add synposis to all scripts
* Update readme file
* Add more scripts which has to be converted to readable scripts before added

### References

[Cisco WebEx XML API - Developer site](https://developer.cisco.com/media/webex-xml-api/Preface.html "XML API")

[Cisco WebEx XML API - PDF](https://developer.cisco.com/fileMedia/download/1d70807a-6431-4a80-b13a-aa8faa4575b7 "XML API PDF")
