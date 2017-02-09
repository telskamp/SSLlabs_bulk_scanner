# SSLlabs_bulk_scanner
Powershell script to scan multiple websites ssl configuration using ssllabs.com api.

# Usage
1. Download the script
2. Place a text file containing a list of domains/websites called urllist.txt in the same folder as the script
3. Run the script
5. Wait for it
4. Reports are found in the \reports folder

# Email report
Uncomment the last line and change the email details to have te reports sent by mail


# Compatibillity
The Script is known to work with powershell version 4 and 5, it will NOT work using powershell 2 or lower!
update yo sh#t:https://www.microsoft.com/en-us/download/details.aspx?id=50395

known issue
script sucks at scanning less than 5 urls

# Changelog
- v1.0
Basic functionality  implemented and tested
- v1.1
-Added timestamp to filenames to prevent overwriting reports
-Added trim to url input to prevent failure on spaces
-Added creation orf reports folder if does not exist
- v1.2
-Added report mail line 

# Api documentation
https://www.ssllabs.com/projects/ssllabs-apis/
