<# Steps
Identify folders to crawl.  
#Get base folders
Readin Domains you want to crawl and create folders to put logs by domain




ToDo:
1) make base log location a paremeter
2) make domain list file a paremeter
#>

#Variables list:
$logLocation = "E:\_PS_Scripts\Data\cabFile\cab\" #base log location
$domainFile = "E:\_PS_Scripts\Data\cabFile\domains.txt"  #List of Domains
$logFolderList = Get-ChildItem $logLocation -Directory
$logFolderList.name

$domainList = Get-Content $domainFile # get Domain list
foreach ($domain in $domainList) {
    $newDirectory = $logLocation + $domain
    New-Item $newDirectory -ItemType directory
}

