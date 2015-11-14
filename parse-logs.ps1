#ToDo:  set up source and destination folders as parameters and get rid of hard coding.
<#
Steps: 
1) Read in list of domains
1a) create folders for each domain in a new directory
2) Crawl through a list of folders that contain logs.  
2a) for each folder containing logs I need to create a new folder in the domain folder Note:  these need to be unique names
2b) Crawl through list of compressed log files and decompress the log files
3) For each log file create a new log with only entries for each domain in the domain folder.
4) 
#>
$domainFile = "E:\_PS_Scripts\Data\cabFile\domains.txt"
$sourceFlolder = "E:\_PS_Scripts\Data\cabFile\cab\"
$destinationFolder = "E:\_PS_Scripts\Data\cabFile\txt\"

$domainList = Get-Content $domainFile
#extract all files in a directory and extract to another folder

$fileList = Get-ChildItem $sourceFlolder
foreach ($file in $fileList){
    $cabFile = $sourceFlolder + $file.Name
    $logFile = $destinationFolder + $file.BaseName + ".txt"
    expand $cabFile $logFile
    }
$logList = Get-ChildItem $destinationFolder
$loglist
