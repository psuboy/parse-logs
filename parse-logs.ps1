<#
.NOTES
    Author: Peter Weyandt
    Email: pweyandt@weyandt.com
    Publish Date: 11/215/2015
    Version: 1
.SYNOPSIS
    1) Expand IIS .cab log files into their original .txt format
    2) Read in a list of domains and create a subset of log files
       for each domain by parsing out all rows that do not match the domain 
.DESCRIPTION
    This script will create a set of log files for a customer that removes all lines not belonging to that customer
    Note 1:  verify you have enough disk space for 2 times the amount of log files.  This script will expand the full cabbed 
           files into logs.  The logs can be as much as 20 times larger than the cab files.  It will then create a sperate
           set of logs for each domain.  These can be amount up to another full set of logs.  So you need the size of the 
           cabs * 41 plus a little extra space to be safe. 
    Note 2: This is version 1 of this script.  While it has been tested and works in my test environment, it does not
            contain any error checking. You need to watch the console for errors.
.PARAMETER baseDirectory
    Required
    This is the base directory where:
    1) folders for log files will be placed
    2) folders for new parsed logs will be created
    note: include \ on the end of the directory 
    example: E:\_PS_Scripts\Data\cabfile\
.PARAMETER cabSubFolder
    Required
    this is the sub folder structure past the base folder up to the folder containing the cabs
    note1: this can contain multiple directorys but should not include the folder containing cabs.  
    note2: include the \ on the end of the structure
    example cab\
.PARAMETER domainFile
    Required
    This is the .txt file that contains the list of domains.  Each domain should be listed with out protocals or spaces
    and on a seperate line.

.EXAMPLE 1 (with parameter tags)
    .\parse-logs.ps1 -baseDirectory E:\_PS_Scripts\Data\cabfile\ -cabSubFolder W3SVC1\ -domainFile E:\_PS_Scripts\Data\domains.txt

.EXAMPLE 2 (without parameter tags)
    .\parse-logs.ps1 E:\_PS_Scripts\Data\cabfile\  W3SVC1\ E:\_PS_Scripts\Data\domains.txt
#>
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=0)]
    [string] $baseDirectory,
    [Parameter(Mandatory=$True,Position=1)]
    [string] $cabSubFolder,
    [Parameter(Mandatory=$True,Position=2)]
    [string] $domainFile
)

$logLocation = $baseDirectory + $cabSubFolder #base log location ex: W3SVC1\
$logFolderList = Get-ChildItem $baseDirectory -Directory
#$logFolderList.name

$oldLogFolder = $baseDirectory + "oldLogs\"
$newLogFolder = $baseDirectory + "newLogs\"
New-Item $oldLogFolder -ItemType directory
New-Item $newLogFolder -ItemType directory
$domainList = Get-Content $domainFile # get Domain list  .\domains.txt

#Expand cab files to log files
foreach ($cabFolder in $logfolderList) {
    #crawl Cab folder
    $cabFolderPath = $baseDirectory + $cabFolder.name + "\" + $cabSubFolder
    $cabFile = Get-ChildItem $cabFolderPath
    #create old log folders
    $oldLogSubFolder = $oldLogFolder + $cabFolder.name + "\"
    New-Item $oldLogSubFolder -ItemType directory
    foreach ($file in $cabFile) {
        $cabFilePath = $cabFolderPath + $file.Name
        $logFilePath = $oldLogSubFolder + $file.BaseName + ".txt"
        expand $cabFilePath $logFilePath
    }
}

#Parse log files
foreach ($domain in $domainList) {
    $newDirectory = $newLogFolder + $domain
    New-Item $newDirectory -ItemType directory #Create directories for domains
     # need to crawl the oldLogFolders
     $OldLogFolderList = Get-ChildItem $oldLogFolder -Directory
     foreach ($folderName in $OldLogFolderList) {
        $newLogSubDirectory = $newDirectory + "\" + $folderName
        New-Item $newLogSubDirectory -ItemType directory
        $oldLogSubFolder = $oldLogFolder + "\" + $folderName
        $OldLogFileList = Get-ChildItem $oldLogSubFolder
        foreach ($oldLogFile in $OldLogFileList) {
            $oldLogFilePath = $oldLogSubFolder + "\" + $oldLogFile
            $newLogFilePath = $newLogSubDirectory + "\" + $oldLogFile
            $myLogHeader = Get-Content $oldLogFilePath | where {$_ -Like "#[D-V]*" }
            $mydomain = "*" + $domain + "*"
            $myLog = Get-Content $oldLogFilePath | where {$_ -Like $mydomain }
            $myLogHeader | Out-File $newLogFilePath
            $myLog | Out-File $newLogFilePath -Append
        }
     }
}


