' File: $id$
' Author: James "Ox" Gibson <james.gibson@ni.com>, Brandon Vasquez <brandon.vasquez@ni.com>
' Owner: James "Ox" Gibson <james.gibson@ni.com>, Brandon Vasquez <brandon.vasquez@ni.com>
' Modified: 27 March 2008
Option Explicit

' Declaring Variables
Dim UpdateSession, UpdateSearcher, searchResult, File, LogFile, I, Update, updatesToDownload, downloader, updatesToInstall, installer, installationresult

' Creating needed objects for the code
Set updateSession = CreateObject("Microsoft.Update.Session")
Set updateSearcher = updateSession.CreateupdateSearcher()
Set searchResult = _
updateSearcher.Search("IsInstalled=0 and Type='Software'")
Set File = CreateObject("Scripting.FileSystemObject")

' Opens the log file for appending or creates the file if it doesn't exsist
Set LogFile = File.OpenTextFile("C:\forceupdate.log", 8, True)

' Output the following to the log file
LogFile.WriteLine("")
LogFile.WriteLine("***************************************************************")
LogFile.WriteLine( "START TIME : " & now)
LogFile.WriteLine( "Searching for updates..." & vbCRLF)
LogFile.WriteLine( "List of applicable items on the machine:")



' As long as there are still updates, repeat the following 
While searchResult.Updates.Count > 0

   ' Output the name of the update to the log file
   For I = 0 To searchResult.Updates.Count-1
      Set update = searchResult.Updates.Item(I)
      LogFile.WriteLine( I + 1 & "> " & update.Title)
   Next

   LogFile.WriteLine( vbCRLF & "Creating collection of updates to download:")

   Set updatesToDownload = CreateObject("Microsoft.Update.UpdateColl")

   For I = 0 to searchResult.Updates.Count-1
      Set update = searchResult.Updates.Item(I)
      LogFile.WriteLine( I + 1 & "> adding: " & update.Title )
      updatesToDownload.Add(update)
   Next

   LogFile.WriteLine( vbCRLF & "Downloading updates...")

   Set downloader = updateSession.CreateUpdateDownloader() 
   downloader.Updates = updatesToDownload
   downloader.Download()

   LogFile.WriteLine( vbCRLF & "List of downloaded updates:")

   For I = 0 To searchResult.Updates.Count-1
      Set update = searchResult.Updates.Item(I)
      If update.IsDownloaded Then
         LogFile.WriteLine( I + 1 & "> " & update.Title )
      End If
   Next

   Set updatesToInstall = CreateObject("Microsoft.Update.UpdateColl")

   LogFile.WriteLine( vbCRLF & _
   "Creating collection of downloaded updates to install:" )

   For I = 0 To searchResult.Updates.Count-1
      set update = searchResult.Updates.Item(I)
      If update.IsDownloaded = true Then
         LogFile.WriteLine( I + 1 & "> adding: " & update.Title )
         updatesToInstall.Add(update) 
      End If
   Next

   logFile.WriteLine( "Installing updates...")
   Set installer = updateSession.CreateUpdateInstaller()
   installer.Updates = updatesToInstall
   Set installationResult = installer.Install()

   ' Output results of install
   LogFile.WriteLine( "Installation Result: " & installationResult.ResultCode )
   LogFile.WriteLine( "Reboot Required: " & installationResult.RebootRequired & vbCRLF )

   LogFile.WriteLine( "Listing of updates installed " & "and individual installation results:" )

   For I = 0 to updatesToInstall.Count - 1
      LogFile.WriteLine( I + 1 & "> " & updatesToInstall.Item(i).Title & ": " & installationResult.GetUpdateResult(i).ResultCode ) 
   Next
   
   Select Case installationResult.ResultCode
      ' Case Succeeded with Errors
	  Case 4
	     WScript.Quit(4)
	  ' Case Aborted Update
	  Case 5
	     WScript.Quit(5)
   End Select

   if installationResult.RebootRequired = -1 then

      WScript.Quit(2)

   end if

   ' Search again to see if we have any more updates
   Set searchResult = _
updateSearcher.Search("IsInstalled=0 and Type='Software'")
Wend

' If searchResult.Updates.Count = 0 Then
LogFile.WriteLine( "There are no applicable updates.")
LogFile.WriteLine("")
LogFile.WriteLine( "STOP TIME : " & now)
LogFile.WriteLine( "reboot the server")
LogFile.WriteLine("***************************************************************")


WScript.Quit(1)
