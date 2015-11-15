<# Steps
Identify folders to crawl.  
#Get base folders
Readin Domains you want to crawl and create folders to put logs by domain
Unpack cab flie into a new directory



ToDo:
1) make base log location a paremeter
2) make domain list file a paremeter
#>

#Variables list:
$baseDirectory = "E:\_PS_Scripts\Data\cabfile\"
$logLocation = $baseDirectory + "cab\" #base log location
$domainFile = "E:\_PS_Scripts\Data\cabFile\domains.txt"  #List of Domains



$logFolderList = Get-ChildItem $logLocation -Directory
$logFolderList.name

$oldLogFolder = $baseDirectory + "oldLogs\"
$newLogFolder = $baseDirectory + "newLogs\"
New-Item $oldLogFolder -ItemType directory
New-Item $newLogFolder -ItemType directory
$domainList = Get-Content $domainFile # get Domain list

#Start to process
foreach ($cabFolder in $logfolderList) {
    #crawl Cab folder
    $cabFolderPath = $loglocation + $cabFolder
    $cabFile = Get-ChildItem $cabFolderPath
    #create old log folders
    $oldLogSubFolder = $oldLogFolder + $cabFolder.name + "\"
    New-Item $oldLogSubFolder -ItemType directory
    foreach ($file in $cabFile) {
        $cabFilePath = $cabFolderPath + "\" + $file.Name
        $logFilePath = $oldLogSubFolder + $file.BaseName + ".txt"
        expand $cabFilePath $logFilePath
    }
}

#Parse log files

   
foreach ($domain in $domainList) {
    $newDirectory = $newLogFolder + $domain
    New-Item $newDirectory -ItemType directory
     # need to crawl the oldLogFolders
     $OldLogFolderList = Get-ChildItem $oldLogFolder -Directory
     foreach ($folderName in $OldLogFolderList) {
        $newSubDirectory = $newDirectory + "\" + $folderName
        New-Item $newSubDirectory -ItemType directory

     }
    #for Each log folder
        #create a ...domain\folder
        #for Each log file
            #parse file
            #Create a new logfile

}


