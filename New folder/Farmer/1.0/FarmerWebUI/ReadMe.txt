Deploying a Built Application to the Application Host
LabVIEW Web UI Builder

You have built a thin-client application with the LabVIEW Web UI Builder. This file contains information about the next phase, which is to deploy this application to a Web server running on the application host. After you complete this phase, client PCs can use this application by entering the URL of the application on the Web server.

The first step is enabling the Web server on the application host. The application host is the PC or RT target that will host the thin-client application and to which clients will connect.

Complete the following steps to enable the Web server on the application host.

For LabVIEW 2009:
1. On the PC or real-time (RT) target that will host the application, launch LabVIEW 2009. 
2. Select Tools»Options. 
3. Select Web Server from the Category list. LabVIEW displays Web server options on the right side of the dialog box. 
4. Place a checkmark in the Enable Web Server checkbox. 
5. Click OK. Leave LabVIEW running. 

For LabVIEW 2010:
Refer to the Enabling the Application Web Server for Web Services topic of the LabVIEW 2010 help for instructions on how to enable the Application Web Server.

==Desktop PC==
Complete the following steps to copy the built application to the proper location on the desktop PC.

1. Browse to one of the following directories:
	-For LabVIEW 2009, browse to labview\www directory, where labview is the 
	directory in which LabVIEW is installed. 
	-For LabVIEW 2010, browse to the National Instruments\Shared\NI WebServer\www directory.
2. Create a subfolder "appName" in this directory, where "appName" is the name of the thin-client application. This name becomes part of the URL clients enter to access the thin-client application. 
3. Unzip the files to this new directory. 

Clients now can access the thin-client application by entering the URL http://hostName/appName/index.html in a Web browser, where:

-"hostName" is the IP address or DNS name of the application host. 
-"appName" is the name of the directory you created in step 2 above. 

==Real-Time Target==
To transfer the built application to an RT target, you first need an FTP client such as Filezilla. Complete the following steps to transfer the built application to an RT target.

1. Unzip the files in this archive. 
2. Launch the FTP client. 
3. Enter the IP address of the RT target and the appropriate username and password. By default, the username is Guest and the password is blank. 
4. In the FTP client, browse to the ni-rt/system/www directory. 
5. Create a subfolder "appName" in this directory, where "appName" is the name of the thin-client application. This name becomes part of the URL clients enter to access the thin-client application. 
6. Use the FTP client to transfer the unzipped files to this new directory. 

Clients now can access the thin-client application by entering the URL http://hostName:port/appName/index.html in a Web browser, where:

-"hostName" is the IP address or DNS name of the application host. 
-"port" is the port number of the server. For LabVIEW 2009, the default port is 80. For LabVIEW 2010, the default port is 8080.
-"appName" is the name of the directory you created in step 5 above.