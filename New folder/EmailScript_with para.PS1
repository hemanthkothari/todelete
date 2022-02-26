<# This File has been created by Hemanth Kumar Kothari
used to send emails

EX:
Powershell.exe -executionpolicy remotesigned -File "\\us-aus-rtweb2\Script Templates\SubScripts\EmailScript_with para.PS1" -from "CEIP2019SP1@ni.com" -to "Hemanth.kumar.kothari@ni.com,krupa.jois@ni.com,manasa.h.r@ni.com" -sub "%Hello!" -bodym "How are you"
#>
 param (
    [Parameter(Mandatory=$true)][string]$to,
	[Parameter(Mandatory=$true)][string]$from,
    [Parameter(Mandatory=$true)][string]$sub,
	[Parameter(Mandatory=$false)][string]$file, <#What file need to be attach in the email#>
	[Parameter(Mandatory=$true)][string]$BodyMessage <#BodyMessage is used to write some content into the body of the email#>	
    )
$SmtpClient = new-object system.net.mail.smtpClient
$MailMessage = New-Object system.net.mail.mailmessage
$SmtpClient.Host = "mailout.natinst.com"
$mailmessage.from = ("$from")
$MailMessage.Sender = ("hemanth.kumar.kothari@ni.com") <# this will show onbehalf in the to list#>
$MailMessage.ReplyTo=("hemanth.kumar.kothari@ni.com") <# if they click on reply they will reply on this email #>
$mailmessage.To.add("$to")
$mailmessage.Subject = ("$sub")
$mailmessage.IsBodyHtml = $true
#$file="$env:USERPROFILE\Desktop\LatestinstallLog.txt"
$Attachments= New-Object System.Net.Mail.Attachment $file
$MailMessage.Attachments.Add($Attachments)
$body = (Get-Content "$file")
$mailmessage.Body = ("<h1>$BodyMessage</h1><body><p>$body</p><br><br><h4>To stop receiving these notifications, reply back to this E-mail.</h4></body>")

$smtpclient.Send($mailmessage)
