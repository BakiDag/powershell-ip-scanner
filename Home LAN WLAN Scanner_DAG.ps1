[void] [system.Reflection.Assembly]::LoadwithPartialName("System.Windows.Forms")
[void] [system.Reflection.Assembly]::LoadwithPartialName("System.Windows.Forms.Control")
[void] [system.Reflection.Assembly]::LoadwithPartialName("System.Windows.Forms.ProgressBar")

[void] [system.Reflection.Assembly]::LoadwithPartialName("System.Drawing")
[System.Windows.Forms.Application]::EnableVisualStyles() #fuer korrekte darsellung 
#[System.Windows.Forms.MessageBox]::Show($MyInvocation.MyCommand.Name)
if ($PSScriptRoot -ne "C:\Projekt")
{
#[System.Windows.Forms.MessageBox]::Show("C:\Projekt\"+$MyInvocation.MyCommand.Name)
    [System.Windows.Forms.MessageBox]::Show("Sie befinden sich nicht im C:\Projekt Ordner " + $PWD)
    if (!(Test-Path -Path "C:\Projekt"))#Ordner existiert nicht
    {
        New-Item -ItemType directory -Path "C:\Projekt"
        [System.Windows.Forms.MessageBox]::Show(" Ordner C:\Projekt"+" erstellt")
        Copy-Item $PSCommandPath -Destination "C:\Projekt"
        [System.Windows.Forms.MessageBox]::Show($PSCommandPath +" Datei kopiert nach C:\Projekt")
        #[System.Windows.Forms.MessageBox]::Show($MyInvocation.MyCommand.Name)
        
        Set-Location -Path "C:\Projekt"
        [System.Windows.Forms.MessageBox]::Show("f�hren Sie die Datei C:\Projekt\"+$MyInvocation.MyCommand.Name+ " aus")
        exit
    }
    else
    {
        [System.Windows.Forms.MessageBox]::Show("Ordner existiert.")
    }
    
    $CopyFileName = "C:\Projekt\"+$MyInvocation.MyCommand.Name
    if((Test-Path $CopyFileName -PathType leaf))#File existiert nicht in C:\Projekt    
    {
        [System.Windows.Forms.MessageBox]::Show("File existiert")
        
        exit
    }
    else
    {
        [System.Windows.Forms.MessageBox]::Show("File existiert nicht")
        Copy-Item $PSCommandPath -Destination "C:\Projekt"
        [System.Windows.Forms.MessageBox]::Show($PSCommandPath +" Datei kopiert nach C:\Projekt")
        Set-Location -Path "C:\Projekt"
        [System.Windows.Forms.MessageBox]::Show("f�hren Sie die Datei C:\Projekt\"+$MyInvocation.MyCommand.Name+ " aus ")
        exit
    }    
    
       
       exit

}




$RemoteScript = $OrdnerPfad+ "\"+"EnablePowershellRemote.ps1"
$HostScript = $OrdnerPfad+ "\"+"HostEnablePSRemote.ps1"
$OrdnerPfad ="C:\Projekt"
$SaveJobBox = $OrdnerPfad+ "\"+"JobTextLog.txt"
$CSVAdressbuch = "Adressbuch.csv"
$TextBoxSavedFile = $OrdnerPfad+ "\"+"Textbox.txt"
$File = $OrdnerPfad+ '\' + $CSVAdressbuch
$IpRangeFile = "IpOneCOuntTestconnection.csv"
$IPRangeAdressbook = $OrdnerPfad+ '\'+ $IpRangeFile
$Arpfile= "ArpTabelle.CSV"
$ArpAdressbook = $OrdnerPfad+ '\' + $Arpfile
#$x=1; #fuer schleife counter
$AdressVorgabe1 = "192.168.0."
$Adressbuch= @() # alle ip adressen aus 192.168.0.1-254
$Adressbuch2= @()
$online = 0 #anzahl auf 1 ping count geantwortet
$OnlineAdressen = @() #ip adressen
###########
$Reachable =@()
$4CountOnline = 0
##########
$DnsNamen = @()

function CreateFileFolder
{
    if (!(Test-Path -Path $OrdnerPfad))#Ordner existiert nicht
    {
       New-Item -ItemType directory -Path $OrdnerPfad
       $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner erstellt"+"`r`n")
       if(!(Test-Path $File ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $File 
             $ObjTextBox4Job.AppendText($File+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($File+" Datei existiert bereits"+"`r`n")
            #Rename-Item -Path $File -NewName Adressbuch.bak  #Backup Option einbauen wenn gewuenscht
            }            
     }
    else
    {
        $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner existiert bereits"+"`r`n")
        if(!(Test-Path $File ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $File 
             $ObjTextBox4Job.AppendText($File+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($File+" Datei existiert bereits"+"`r`n")
            #Rename-Item -Path $File -NewName Adressbuch.bak  #Backup Option einbauen wenn Zeit bleibt
            }             
    }
}
function AdressbuchErstellen 
{    
    for($x=1; $x -le 254; $x++)
    {
        $Adressbuch += $AdressVorgabe1 +$x + ";"+[Environment]::NewLine
        $global:Adressbuch2 += $AdressVorgabe1 +$x
    }
    CreateFileFolder
    "$($Adressbuch)" | set-content $file 
    # - join raus genommen    
    #[System.Windows.Forms.MessageBox]::Show("Eintrag gemacht $File")
    $x=1; # wegen session auf 0 setzen und nochmal benutzen
    $ObjTextBoxoutputBox.AppendText($Adressbuch.Replace(";",""))
    $ObjTextBox4Job.AppendText("Addressbuch gefuellt mit Adressen"+[Environment]::NewLine)
    
 }

function OpenFolder
{
    Invoke-Item $global:OrdnerPfad
}

function InvokeFile
{
    Start-Process notepad.exe $Global:file
}

function CreateFileFolderIPRange
{
    if (!(Test-Path -Path $OrdnerPfad))#Ordner existiert nicht
    {
       New-Item -ItemType directory -Path $OrdnerPfad
       $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner erstellt"+"`r`n")
       if(!(Test-Path $IPRangeAdressbook ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $IPRangeAdressbook 
             $ObjTextBox4Job.AppendText($IPRangeAdressbook+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($IPRangeAdressbook+" Datei existiert bereits"+"`r`n")
            #Rename-Item -Path $File -NewName Adressbuch.bak  #option fuer backup
            }            
     }
    else
    {
        $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner existiert bereits"+"`r`n")  
        if(!(Test-Path $IPRangeAdressbook))#File existiert nicht
            { 
             New-Item -ItemType File -Path $IPRangeAdressbook 
             $ObjTextBox4Job.AppendText($IPRangeAdressbook+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($IPRangeAdressbook+" Datei existiert bereits"+"`r`n")
            #Rename-Item -Path $File -NewName Adressbuch.bak  #option fuer backup
            }       
    }
}

function FillIpRangeOneCount
{        
    CreateFileFolderIPRange 
     #$ObjTextBoxoutputBox.AppendText($Adressbuch.Replace(";",""))
    set-content $IPRangeAdressbook -Value $OnlineAdressen
    #"$($OnlineAdressen)" | set-content $IPRangeAdressbook    
    $ObjTextBoxoutputBox.AppendText($global:OnlineAdressen)
    $ObjTextBox4Job.AppendText($IPRangeAdressbook+" erstellt,exportiert und mit Adressen gefuellt"+ [Environment]::NewLine)
    write-host $OnlineAdressen + " erstellt exportiert mit adressen gefuellt"
}
 function loadLastOneCountBook
{
  write-host $OnlineAdressen + " 1 Count IpAdressbuch geladen" 
  $global:OnlineAdressen= get-content $global:IPRangeAdressbook
  If ((Get-Content "$global:IPRangeAdressbook") -eq $Null)
  {
    
    $ObjTextBox4Job.AppendText("Keine Eintraege vorhanden. Bitte Alle Adressen pingen"+ [Environment]::NewLine)
    }
    else
    {
  $ObjTextBox4Job.AppendText("1 Count IpAdressbuch geladen" + [Environment]::NewLine)
}
}

function AllIPOneCount
{
    
    [System.Windows.Forms.MessageBox]::Show("Der Scan dauert ca 7 Minuten. Biite Warten","Ip Scan Wird gestartet",0)
    $a = Get-Date

    #Measure-Command {Test-Connection -Count) {write-host "Text."}}
    #Alternative berechnung zu get date subtraktion
    AdressbuchErstellen
  
  $ObjTextBox4Job.AppendText("1 Count IpAdressbuch geladen" + [Environment]::NewLine)
    $ObjTextBox4Job.AppendText("Ip Range mit 1 count Test gestartet. bitte warten..."+ [Environment]::NewLine) 
    for($x=0; $x -lt $global:Adressbuch2.Length; $x++)
    {
        $q=Write-Progress -Activity "Activity" -PercentComplete ($q=(100/254)) -Status "Processing $($q)";
        $q++
        if((Test-Connection -Count 1 -Quiet $Adressbuch2[$x]) -eq $true)               
            {
              Write-Host $Adressbuch2[$x] + " online"
              $ObjTextBoxoutputBox.AppendText($Adressbuch2[$x]+" online"+ [Environment]::NewLine)              
              $global:online += 1
              $global:OnlineAdressen += $Adressbuch2[$x]#reachable Adresse              
              # es gibt eine option mit out grid view
            }
        else
            {
            $ObjTextBoxoutputBox.AppendText($Adressbuch2[$x]+" offline"+ [Environment]::NewLine)              
             Write-Host $Adressbuch2[$x] + " offline"
            }
     }
     $ObjTextBox4Job.AppendText("Ip Range mit 1 count Test Connection Fertig"+ [Environment]::NewLine) 
     CreateFileFolderIPRange
     FillIpRangeOneCount
     $ObjTextBoxoutputBox.AppendText($OnlineAdressen+ [Environment]::NewLine)
     loadLastOneCountBook
     $b = Get-Date
    #$ObjTextBox4Job.AppendText("Dauer des Scans: "+(($b - $a)/60).TotalSeconds+ " Minuten")   #Status bearbeiten
 }   
 
function Show1Countreply
{
    for($x = 0; $x -le $global:OnlineAdressen.Length; $x++)
    {
    $ObjTextBoxoutputBox.AppendText($global:OnlineAdressen+ [Environment]::NewLine)

    }
    $ObjTextBoxoutputBox.AppendText($online+"`r`n")
}

####### $OnlineAdressen mit 4 count ping checken
function 4CountPing
{
for($x=0; $x -lt $global:OnlineAdressen.Length; $x++) 
    {        
        $ObjTextBox4Job.AppendText("`r`n"+"Erreichbare werden angepingt. Bitte warten..."+"`r`n")
        if ((Test-Connection $OnlineAdressen[$x] -Quiet -Count 4) -eq $true) 
            { 
                
              $global:4CountOnline += 1
              $global:Reachable += $OnlineAdressen[$x] #reachable Adressen
              Write-Host "Anzahl Geraete " $4CountOnline
              Write-Host $OnlineAdressen[$x] "online"
              $ObjTextBoxoutputBox.AppendText($OnlineAdressen[$x] +" online"+"`r`n")
              $ObjTextBoxoutputBox.AppendText("Anzahl Geraete: "+ $4CountOnline + "`r`n")
            }
        else
            {
                $ObjTextBoxoutputBox.AppendText($OnlineAdressen[$x]+" nicht erreichbar"+ "`r`n")
                Write-Host $OnlineAdressen " offline"
            }
    }
    $OnlineAdressen | set-content $global:IPRangeAdressbook    
    $ObjTextBox4Job.AppendText("Online Adressen 4 count Test Connection Fertig"+"`r`n")
}

#####DNS Aufloesen fuer reachable

function ReachableHosts
{
foreach ($value in $global:reachable)
{
    $ObjTextBox4Job.AppendText("DNS Namen werden aufgeloest. Bitte warten...`r`n")
    Write-host $value "wird aufgeloest"
    $global:DnsNamen += (Resolve-DnsName  $value).NameHost
    if($DnsNamen -eq $null)
    {
        $ObjTextBoxoutputBox.AppendText("$value "+"liefert keinen Namen zurueck`r`n")
    }
    if($value -eq "192.168.0.1")
    {
        $ObjTextBoxoutputBox.AppendText("$value "+"Ist das evtl dein Router"+"`r`n")
    }
   else
    {
    $ObjTextBoxoutputBox.AppendText("$value $DnsNamen"+"`r`n")
     }     
}
$ObjTextBox4Job.AppendText("DNS Aufloesung fertig`r`n")
}

function ShowArpTable
{
    #$arp = arp -a 
    $arp = get-netneighbor -addressfamily ipv4 -state reachable #mac adressen
    #$ObjTextBoxoutputBox.AppendText($arp -join ""+"`r`n")
    $ObjTextBoxoutputBox.AppendText($arp +"`r`n")
    Write-Host($arp +"`r`n")
    $ObjTextBox4Job.AppendText("Arp Tabelle wird angezeigt"+"`r`n")
}
function SaveArpTable
{
    
    if (!(Test-Path -Path $OrdnerPfad))#Ordner existiert nicht
    {
       New-Item -ItemType directory -Path $OrdnerPfad
       $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner erstellt"+"`r`n")
       if(!(Test-Path C:\Projekt\ArpTabelle.CSV ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $ArpAdressbook 
             $ObjTextBox4Job.AppendText($ArpAdressbook+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($ArpAdressbook+" Datei existiert bereits"+"`r`n")
            #Rename-Item -Path $File -NewName Adressbuch.bak  #option fuer backup
            }            
     }
    else
    {
        $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner existiert bereits"+"`r`n") 
        if(!(Test-Path $ArpAdressbook ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $ArpAdressbook 
             $ObjTextBox4Job.AppendText($ArpAdressbook+" Datei erstellt"+"`r`n")
             }  
        else
            {
            $ObjTextBox4Job.AppendText($ArpAdressbook+" Datei existiert bereits"+"`r`n")
            #Rename-Item -Path $File -NewName Adressbuch.bak  #option fuer backup
            }       
    }
    #arp -a | set-content $ArpAdressbook 
    get-netneighbor -addressfamily ipv4 -state reachable | set-content $ArpAdressbook  #alternative
    $ObjTextBox4Job.AppendText("Arp Tabelle Exportiert nach $ArpAdressbook")
}

function GetLocalInfoOsName
{
    $temp = Get-ComputerInfo -Property Osname*, OsArchitecture*, OSLocale* | foreach {$_.Osname, $_.OsArchitecture, $_.OSLocale }
    $temp +=Get-HotFix |select HotFixID | foreach{"Installierte Hotfixe: "+$_.HotFixID+"`r`n"}
    $ObjTextBoxoutputBox.AppendText("$temp" + "`r`n")
    $ObjTextBox4Job.AppendText("Os Informationen werden geladen"+"`r`n")
}

function localDNS
{
$ObjTextBox4Job.AppendText("Systeminformationen werden eingelsen. Bitte Warten...`r`n")
    $temp = Get-ComputerInfo -Property CSDnsHost** , CSDomain*, CSDomainRole* |foreach { "DNSName: `r`n" +$_.CsDNSHostName,"`r`nArbeitsgruppe: "+ $_.CsDomain , "`r`nClient oder Server:`r`n"+$_.CSDomainRole} 
    
    $ObjTextBoxoutputBox.AppendText("$temp" + "`r`n")
    $ObjTextBox4Job.AppendText("DNS Name wird angezeigt"+"`r`n")
   
}
function GetMotherboardInfo
{
    $temp = Get-WmiObject win32_baseboard -Property Manufacturer,Model,Name,SerialNumber |`
    foreach{"Hersteller: "+$_.Manufacturer+"`r`n", "Model: "+$_.Model+"`r`n","Name: "+ $_.Name+"`r`n","Seriennummer: "+ $_.SerialNumber+"`r`n"}
    $ObjTextBoxoutputBox.AppendText("$temp" + "`r`n")
    $ObjTextBox4Job.AppendText("Mainboard Infos werden angezeigt"+"`r`n")
   
}

function LocalSystemInfo
{
   localDNS
   GetLocalIpv4Adress
   GetLocalInfoOsName
   logicalDisk
   CpuInfo
   RAMInfo
   BiosInfo
   GetMotherboardInfo

}

function CpuInfo
{
    $temp =Get-WmiObject Win32_Processor  -Property  Caption, Name, NumberOfCores, MaxClockSpeed, NumberOfLogicalProcessors, L2CacheSize, L3CacheSize, SocketDesignation, DeviceID |`
    foreach {"Serie: "+$_.Caption+ "`r`n", $_.Name + "`r`n", " Anzahle Kerne: "+$_.NumberOfCores+ "`r`n", "Max Speed: "+ ($_.MaxClockSpeed/1000)+ " GHz`r`n", "Anzahl logischer Prozessoren: "+$_.NumberOfLogicalProcessors+"`r`n", "L2 Cache Groesse: "+$_.L2CacheSize+" Kb`r`n"+"L3 Cache Groesse: "+($_.L3CacheSize/1000)+" MB`r`n"+"Socket Design: "+$_.SocketDesignation+"`r`n"+"Device ID: "+$_.DeviceID+"`r`n" }
    $ObjTextBoxoutputBox.AppendText("$temp" + " `r`n" )
    $ObjTextBox4Job.AppendText("Cpu Info wird angezeigt"+"`r`n")   

}
function BiosInfo
{
   $temp=  Get-WmiObject win32_bios -Property SMBIOSBIOSVersion, Manufacturer, Name, SerialNumber, Version |`
    foreach{"System Management BIOS version: " + $_.SMBIOSBIOSVersion+ "`r`n", "Hersteller: "+$_.Manufacturer + "`r`n", "Name: " +$_.Name+"`r`n","Seriennummer: "+ $_.SerialNumber+"`r`n", "Version: "+ $_.Version+"`r`n"}
     $ObjTextBoxoutputBox.AppendText("$temp" + " `r`n" )
    $ObjTextBox4Job.AppendText("Cpu Info wird angezeigt"+"`r`n")   

}

function RAMInfo
{
    $temp = Get-WmiObject win32_physicalmemory -Property Manufacturer,Configuredclockspeed,Capacity,Serialnumber |`
    foreach {"RAM Hersteller: `r`n"+$_.Manufacturer+"`r`n", "Eingestellte Taktfrequenz: "+$_.Configuredclockspeed+" MHZ`r`n", "Kapazität: "+("{0:N2}" -f ($cap = ($_.Capacity/1073741274)))+" GB`r`n", "Seriennummer: "+$_.Serialnumber+"`r`n"}
    $ObjTextBoxoutputBox.AppendText("$temp" + "`r`n")
    $ObjTextBox4Job.AppendText("Ram Info Wird eingelesen"+"`r`n")
    
}
function logicalDisk
{
    $temp = get-WmiObject win32_logicaldisk -Property DeviceID, FreeSpace,DeviceID, Size, VolumeName | foreach {"Partition " + $_.DeviceID+ "`r`n","Belegter Speicher: " +[math]::Round(($_.Size-$_.FreeSpace)/1GB,2)+ " GB`r`n", "Freier Speicher: " +[math]::Round($_.FreeSpace/1GB,2)+ " GB`r`n"+"Groesse: " +[math]::Round($_.Size/1GB,2)+ " GB`r`n", "Partions Name: "+$_.VolumeName}

    #Format-Table DeviceId, MediaType, @{n="Size";e={[math]::Round($_.Size/1GB,2)}},@{n="FreeSpace";e={[math]::Round($_.FreeSpace/1GB,2)}}
    $ObjTextBoxoutputBox.AppendText("$temp" + "`r`n")
    $ObjTextBox4Job.AppendText("HDD Info wird angezeigt"+"`r`n")
    
}
function GetLocalIpv4Adress
{
    $temp = gwmi Win32_NetworkAdapterConfiguration |Where {$_.IPAddress } | Select -Expand IPAddress | Where { $_ -like '192.168.0.*' } 
    $ObjTextBoxoutputBox.AppendText("$temp" + "`r`n")
    $ObjTextBox4Job.AppendText("IPv4"+"`r`n")
}

function ClearTextBox
{
  $ObjTextBoxoutputBox.Clear()
}

function ManuellesPing
{
    $ipValidation = "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"
    if($ObjPingBox.Text -notmatch $ipValidation)
    {
    $ObjTextBoxoutputBox.AppendText("Ungueltige Eingabe"+ "`r`n")
    $ObjPingBox.Clear()
    }
    else
    {
    $ObjTextBoxoutputBox.AppendText(($ObjPingBox.Text) +" ping..." + "`r`n")
    $ObjTextBox4Job.AppendText("Manuell Ping läuft. Bitte warten..."+"`r`n")
     if((Test-Connection -Count 1 -Quiet ($ObjPingBox.Text)) -eq $true)               
     
            { 
              Write-Host $ObjPingBox.Text + " online"
              $ObjTextBoxoutputBox.AppendText($ObjPingBox.Text+" online"+"`r`n")              
              $global:online += 1
              $global:OnlineAdressen += $ObjPingBox.Text+"`r`n" #reachable Adresse              
              $ObjTextBox4Job.AppendText("Online Adressen und Anzahl korrigiert"+"`r`n")
            }
        else
            {
            $ObjTextBoxoutputBox.AppendText($ObjPingBox.Text+" offline"+"`r`n")              
             Write-Host $ObjPingBox.Text + " offline"
            }
     $ObjTextBox4Job.AppendText("Manuell Ping Fertig"+"`r`n")
     }
   "$($global:OnlineAdressen)" | Add-content $IPRangeAdressbook 

}

function SaveJobBox
{
    if (!(Test-Path -Path $OrdnerPfad))#Ordner existiert nicht
    {
       New-Item -ItemType directory -Path $OrdnerPfad
       $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner erstellt"+"`r`n")
       if(!(Test-Path $File ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $SaveJobBox 
             $ObjTextBox4Job.AppendText($SaveJobBox+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($SaveJobBox+" Datei existiert bereits"+"`r`n")
            #Rename-Item -Path $File -NewName Adressbuch.bak  #Backup Option einbauen wenn Zeit bleibt
            }            
     }
    else
    {
        $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner existiert bereits"+"`r`n")
        if(!(Test-Path $TextBoxSavedFile ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $SaveJobBox 
             $ObjTextBox4Job.AppendText($SaveJobBox+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($SaveJobBox+" Datei existiert bereits"+"`r`n")
            }             
    }
    "$($ObjTextBox4Job.Text)" | set-content $SaveJobBox 
    $ObjTextBox4Job.AppendText("Log in Datei gespeichert`r`n")
}

function SaveTextBox
{
    if (!(Test-Path -Path $OrdnerPfad))#Ordner existiert nicht
    {
       New-Item -ItemType directory -Path $OrdnerPfad
       $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner erstellt"+"`r`n")
       if(!(Test-Path $File ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $TextBoxSavedFile 
             $ObjTextBox4Job.AppendText($TextBoxSavedFile+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($TextBoxSavedFile+" Datei existiert bereits"+"`r`n")
            #Rename-Item -Path $File -NewName Adressbuch.bak  #Backup Option einbauen wenn Zeit bleibt
            }            
     }
    else
    {
        $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner existiert bereits"+"`r`n")
        if(!(Test-Path $TextBoxSavedFile ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $TextBoxSavedFile 
             $ObjTextBox4Job.AppendText($TextBoxSavedFile+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($TextBoxSavedFile+" Datei existiert bereits"+"`r`n")
            }             
    }
    "$($ObjTextBoxoutputBox.Text)" | set-content $TextBoxSavedFile 
    $ObjTextBox4Job.AppendText("Textbox in Datei gespeichert`r`n")
}

function remoteDNS
{
    $ObjTextBox4Job.AppendText("DNS Informationen werden geladen. Bitte Warten..."+"`r`n")    
    $temp = @()
    $global:CredetnialInfo = Get-Credential -Message "Bitte geben Sie Nutzername und Passwort ein"
    $userValue = $CredetnialInfo.UserName
    $passValue = $CredetnialInfo.GetNetworkCredential().Password

    $temp = Invoke-Command -ComputerName $RemoteIP -Credential $global:CredetnialInfo -ScriptBlock{
    Get-ComputerInfo -Property CSDnsHost** , CSDomain*, CSDomainRole* |foreach { "DNSName: `r`n" +$_.CsDNSHostName,"`r`nArbeitsgruppe: "+ $_.CsDomain , "`r`nClient oder Server:`r`n"+$_.CSDomainRole+"`r`n"} 
    }
    $ObjTextBoxoutputBox.AppendText("$temp" + "`r`n")
    $ObjTextBox4Job.AppendText("Remote Host DNS Info Wird eingelesen"+"`r`n")
        
}

function RemoteRAMInfo
{      
    $temp = Invoke-Command -ComputerName $RemoteIP -Credential $CredetnialInfo -ScriptBlock{
    Get-WmiObject win32_physicalmemory -Property Manufacturer,Configuredclockspeed,Capacity,Serialnumber |`
    foreach {"RAM Hersteller: `r`n"+$_.Manufacturer+"`r`n", "Eingestellte Taktfrequenz: "+$_.Configuredclockspeed+" MHZ`r`n", "Kapazität: "+("{0:N2}" -f ($cap = ($_.Capacity/1073741274)))+" GB`r`n", "Seriennummer: "+$_.Serialnumber+"`r`n"}
    }
    $ObjTextBoxoutputBox.AppendText("$temp" + "`r`n")
    $ObjTextBox4Job.AppendText("Remote Host Ram Info Wird eingelesen"+"`r`n")
}
function getRemoteIpv4
{
    $temp = Invoke-Command -ComputerName $RemoteIP -Credential $CredetnialInfo -ScriptBlock{
    gwmi Win32_NetworkAdapterConfiguration |Where {$_.IPAddress, $_.DHCPEnabled, $_.ServiceName, $_.Description } | Select -Expand IPAddress | Where { $_ -like '192.168.0.*' } 
    }
    $ObjTextBoxoutputBox.AppendText("$temp" + "`r`n")
    $ObjTextBox4Job.AppendText("Remote Host IPv4 Adresse wird ausgelesen"+"`r`n")
}

function GetRemoteInfoOsName
{
    $temp = Invoke-Command -ComputerName $RemoteIP -Credential $CredetnialInfo -ScriptBlock{
    Get-ComputerInfo -Property Osname*, OsArchitecture*, OSLocale* | foreach {$_.Osname, $_.OsArchitecture, $_.OSLocale }
    }    
    $temp +=Invoke-Command -ComputerName $RemoteIP -Credential $CredetnialInfo -ScriptBlock{
    Get-HotFix |select HotFixID | foreach{"Installierte Hotfixe: "+$_.HotFixID+"`r`n"}
    }
    $ObjTextBoxoutputBox.AppendText("$temp" + "`r`n")
    $ObjTextBox4Job.AppendText("Remote Host Os Informationen werden geladen"+"`r`n")
}
function GetRemotelogicalDiskInfo
{
    $temp = Invoke-Command -ComputerName $RemoteIP -Credential $CredetnialInfo -ScriptBlock{
    get-WmiObject win32_logicaldisk -Property DeviceID, FreeSpace,DeviceID, Size, VolumeName | foreach {"Partition " + $_.DeviceID+ "`r`n","Belegter Speicher: " +[math]::Round(($_.Size-$_.FreeSpace)/1GB,2)+ " GB`r`n", "Freier Speicher: " +[math]::Round($_.FreeSpace/1GB,2)+ " GB`r`n"+"Groesse: " +[math]::Round($_.Size/1GB,2)+ " GB`r`n", "Partions Name: "+$_.VolumeName}
    }
    $ObjTextBoxoutputBox.AppendText("$temp" + "`r`n")
    $ObjTextBox4Job.AppendText("Remoste Host HDD Info wird angezeigt"+"`r`n")
    
}
function RemoteCpuInfo
{
    $temp = Invoke-Command -ComputerName $RemoteIP -Credential $CredetnialInfo -ScriptBlock{
    
    Get-WmiObject Win32_Processor  -Property  Caption, Name, NumberOfCores, MaxClockSpeed, NumberOfLogicalProcessors, L2CacheSize, L3CacheSize, SocketDesignation, DeviceID |`
    foreach {"Serie: "+$_.Caption+ "`r`n", $_.Name + "`r`n", " Anzahle Kerne: "+$_.NumberOfCores+ "`r`n", "Max Speed: "+ ($_.MaxClockSpeed/1000)+ " GHz`r`n", "Anzahl logischer Prozessoren: "+$_.NumberOfLogicalProcessors+"`r`n", "L2 Cache Groesse: "+$_.L2CacheSize+" Kb`r`n"+"L3 Cache Groesse: "+($_.L3CacheSize/1000)+" MB`r`n"+"Socket Design: "+$_.SocketDesignation+"`r`n"+"Device ID: "+$_.DeviceID+"`r`n" }
    }
    $ObjTextBoxoutputBox.AppendText("$temp" + " `r`n" )
    $ObjTextBox4Job.AppendText("Cpu Info wird angezeigt"+"`r`n")   

}

function GetRemoteBiosInfo
{
$temp=  Invoke-Command -ComputerName $RemoteIP -Credential $CredetnialInfo -ScriptBlock{
Get-WmiObject win32_bios -Property SMBIOSBIOSVersion, Manufacturer, Name, SerialNumber, Version |`
    foreach{"System Management BIOS version: " + $_.SMBIOSBIOSVersion+ "`r`n", "Hersteller: "+$_.Manufacturer + "`r`n", "Name: " +$_.Name+"`r`n","Seriennummer: "+ $_.SerialNumber+"`r`n", "Version: "+ $_.Version+"`r`n"}
     }
     $ObjTextBoxoutputBox.AppendText("$temp" + " `r`n" )
    $ObjTextBox4Job.AppendText("Remote Host Bios Info wird angezeigt"+"`r`n")   

}

function GetRemoteMotherboardInfo
{
    $temp =Invoke-Command -ComputerName $RemoteIP -Credential $CredetnialInfo -ScriptBlock{
    Get-WmiObject win32_baseboard -Property Manufacturer,Model,Name,SerialNumber |`
    foreach{"Hersteller: "+$_.Manufacturer+"`r`n", "Model: "+$_.Model+"`r`n","Name: "+ $_.Name+"`r`n","Seriennummer: "+ $_.SerialNumber+"`r`n"}
    }
    $ObjTextBoxoutputBox.AppendText("$temp" + "`r`n")
    $ObjTextBox4Job.AppendText("Mainboard Infos werden angezeigt"+"`r`n")
   
}

function RemoteInfo
{    
   
    remoteDNS
    getRemoteIpv4
    GetRemoteInfoOsName
    GetRemotelogicalDiskInfo
    RemoteCpuInfo
    RemoteRAMInfo
    GetRemoteBiosInfo
    GetRemoteMotherboardInfo
      
}

function RemoteIPEingabe
{
#IP eingabeaufforderung
$Form1 = New-Object System.Windows.Forms.Form
$Form1.Text = "IP Erforderlich"
$Form1.Size = New-Object System.Drawing.Size(300,200)
$Form1.StartPosition = "CenterScreen"
$Form1.Add_KeyPress({if ( ($_.KeyChar -notlike "[0-9 , .]") -and ([int]$_.KeyChar -ne 8 )) {$_.Handled = $true} })

# Icon
#$Form1.Icon = [Drawing.Icon]::ExtractAssociatedIcon(C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe)
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$Form1.AcceptButton = $OKButton
$Form1.Controls.Add($OKButton)
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$Form1.CancelButton = $CancelButton
$Form1.Controls.Add($CancelButton)
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Location = New-Object System.Drawing.Point(10,20)
$Label1.Size = New-Object System.Drawing.Size(280,20)
$Label1.Text = "Bitte hier die IP eingeben:"
$Form1.Controls.Add($Label1)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$textBox.Add_KeyPress({if ( ($_.KeyChar -notlike "[0-9 , .]") -and ([int]$_.KeyChar -ne 8 )) {$_.Handled = $true} })
$Form1.Controls.Add($textBox)
$Form1.Topmost = $True
$Form1.Add_Shown({$textBox.Select()})
$result = $Form1.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
$x = $textBox.Text
$x}
if ($x -eq "") {[System.Windows.Forms.MessageBox]::Show("Ungueltige oder Keine Eingabe!", "Fehler")}
else 
{
[System.Windows.Forms.MessageBox]::Show($x, "Ihre Eingabe")
CreateRemoteScript
}
}
function HostIPEingabe
{
#IP eingabeaufforderung
$Form1 = New-Object System.Windows.Forms.Form
$Form1.Text = "IP Erforderlich"
$Form1.Size = New-Object System.Drawing.Size(300,200)
$Form1.StartPosition = "CenterScreen"
$Form1.Add_KeyPress({if ( ($_.KeyChar -notlike "[0-9 , .]") -and ([int]$_.KeyChar -ne 8 )) {$_.Handled = $true} })

# Icon
$Form1.Icon = [Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$Form1.AcceptButton = $OKButton
$Form1.Controls.Add($OKButton)
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$Form1.CancelButton = $CancelButton
$Form1.Controls.Add($CancelButton)
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Location = New-Object System.Drawing.Point(10,20)
$Label1.Size = New-Object System.Drawing.Size(280,20)
$Label1.Text = "Bitte hier die IP eingeben:"
$Form1.Controls.Add($Label1)
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$textBox.Add_KeyPress({if ( ($_.KeyChar -notlike "[0-9 , .]") -and ([int]$_.KeyChar -ne 8 )) {$_.Handled = $true} })

$Form1.Controls.Add($textBox)
$Form1.Topmost = $True
$Form1.Add_Shown({$textBox.Select()})
$result = $Form1.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
$x = $textBox.Text
$x
if ($x -eq "") {[System.Windows.Forms.MessageBox]::Show("Ungueltige oder Keine Eingabe!", "Fehler")}
else 
{
[System.Windows.Forms.MessageBox]::Show($x, "Ihre Eingabe")}}
CreateScriptforHost
}

function RemoteIPEingabe4RemoteInfo
{
#IP eingabeaufforderung
$Form1 = New-Object System.Windows.Forms.Form
$Form1.Text = "IP Erforderlich"
$Form1.Size = New-Object System.Drawing.Size(300,200)
$Form1.StartPosition = "CenterScreen"
$Form1.Add_KeyPress({if ( ($_.KeyChar -notlike "[0-9 , .]") -and ([int]$_.KeyChar -ne 8 )) {$_.Handled = $true} })

# Icon
$Form1.Icon = [Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$Form1.AcceptButton = $OKButton
$Form1.Controls.Add($OKButton)
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$Form1.CancelButton = $CancelButton
$Form1.Controls.Add($CancelButton)
$Label1 = New-Object System.Windows.Forms.Label
$Label1.Location = New-Object System.Drawing.Point(10,20)
$Label1.Size = New-Object System.Drawing.Size(280,20)
$Label1.Text = "Bitte hier die IP eingeben:"
$Form1.Controls.Add($Label1)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,40)
$textBox.Size = New-Object System.Drawing.Size(260,20)
$textBox.Add_KeyPress({if ( ($_.KeyChar -notlike "[0-9 , .]") -and ([int]$_.KeyChar -ne 8 )) {$_.Handled = $true} })
$Form1.Controls.Add($textBox)
$Form1.Topmost = $True
$Form1.Add_Shown({$textBox.Select()})
$result = $Form1.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
$global:RemoteIP = $textBox.Text
$global:RemoteIP
if ($RemoteIP -eq "") {[System.Windows.Forms.MessageBox]::Show("Ungueltige oder Keine Eingabe!", "Fehler")}
else 
{
[System.Windows.Forms.MessageBox]::Show($RemoteIP, "Ihre Eingabe")}}
RemoteInfo
}

function CreateRemoteScript
{    
    $temp = @()
    $temp += "#Achtung dieses Script dient dazu eine unverschluesselte Verbindung aufzubauen"
    $temp += "#Es wird dringend empfohlen entsprechende Sicherheitsvorkehrungen zu Treffen"
    $temp += "#Es werden keinerlei Haftung und oder anderweitere Rechtsansprueche entgegen genommen"
    
    $temp += "#Bitte dieses Script auf dem Remote Host verwenden"
    $temp += "#Dieses Syript als Administrator Mit Powershell ausfuehren"
    $temp += "winrm quickconfig"
    $temp += "enable-psremoting -force"
    $temp += "Set-Item WSMan:\localhost\Client\TrustedHosts $x -Force"
    $ObjTextBoxoutputBox.AppendText("$temp" + " `r`n" )
    $ObjTextBox4Job.AppendText("Remotscript wird exportiert..."+"`r`n") 
    if (!(Test-Path -Path $OrdnerPfad))#Ordner existiert nicht
    {
       New-Item -ItemType directory -Path $OrdnerPfad
       $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner erstellt"+"`r`n")
       if(!(Test-Path $RemoteScript ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $RemoteScript 
             $ObjTextBox4Job.AppendText($RemoteScript+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($RemoteScript+" Datei existiert bereits"+"`r`n")
            #Rename-Item -Path $File -NewName Adressbuch.bak  #option fuer backup
            }            
     }
    else
    {
        $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner existiert bereits"+"`r`n")  
        if(!(Test-Path $RemoteScript ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $RemoteScript 
             $ObjTextBox4Job.AppendText($RemoteScript+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($RemoteScript+" Datei existiert bereits"+"`r`n")
            #Rename-Item -Path $File -NewName Adressbuch.bak  #option fuer backup
           }       
    }
    $temp | set-content $global:RemoteScript   
}

function OneClick
{
   
   ClearTextBox
   SaveArpTable
   LocalSystemInfo

   AllIPOneCount ###Messagbox mit auswahl einbauen
   4CountPing
   ReachableHosts

   RemoteIPEingabe
   RemoteInfo

   SaveTextBox
   SaveJobBox
   OpenFolder
}
function CreateScriptforHost
{
$temp = @()
    $temp += "#Achtung dieses Script dient dazu eine unverschluesselte Verbindung aufzubauen"
    $temp += "#Es wird dringend empfohlen entsprechende Sicherheitsvorkehrungen zu Treffen"
    $temp += "#Es werden keinerlei Haftung und oder anderweitere Rechtsansprueche entgegen genommen"
    $temp += ""
    $temp += "#Bitte dieses Script auf dem localen Host verwenden"
    $temp += "#Dieses Script als Administrator Mit Powershell ausfuehren"
    $temp += "winrm quickconfig"
    $temp += "enable-psremoting -force"
    $temp += "Set-Item WSMan:\localhost\Client\TrustedHosts $x -Force"
    $ObjTextBoxoutputBox.AppendText("$temp" + " `r`n" )
    $ObjTextBox4Job.AppendText("Script fuer Host wird exportiert..."+"`r`n") 
    if (!(Test-Path -Path $OrdnerPfad))#Ordner existiert nicht
    {
       New-Item -ItemType directory -Path $OrdnerPfad
       $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner erstellt"+"`r`n")
       if(!(Test-Path $HostScript ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $HostScript 
             $ObjTextBox4Job.AppendText($HostScript+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($HostScript+" Datei existiert bereits"+"`r`n")
            #Rename-Item -Path $File -NewName Adressbuch.bak  #option fuer backup
            }            
     }
    else
    {
        $ObjTextBox4Job.AppendText($OrdnerPfad+" Ordner existiert bereits"+"`r`n")  
        if(!(Test-Path $HostScript ))#File existiert nicht
            { 
             New-Item -ItemType File -Path $HostScript 
             $ObjTextBox4Job.AppendText($HostScript+" Datei erstellt"+"`r`n")
             }
        else
            {
            $ObjTextBox4Job.AppendText($HostScript+" Datei existiert bereits"+"`r`n")
            #Rename-Item -Path $File -NewName Adressbuch.bak  #option fuer backup
            }       
    }
    $temp | set-content $global:HostScript   
    }

function EnterPsSession
{
    $ObjTextBoxoutputBox.AppendText("Sie koennnen nun ueber die Powershell Konsole CMDlets absetzen" + " `r`n" )
    $ObjTextBox4Job.AppendText("Achtung unverschluesselte Verbindung wird aufgebaut"+"`r`n")   
    Enter-PsSession -ComputerName 192.168.0.45 -Credential "baki.dag@outlook.de" 
}



function exitPsSession
{
    Exit-PSSession 
}

function RemoveAllSessions
{
   # Get-PSSession | Remove-PSSession Remove-PSSession -Session (Get-PSSession)
    $s = Get-PSSession
    Remove-PSSession -Session $s
}


#Main Form
$objForm = New-Object System.Windows.Forms.Form #Form erzeugen
$objForm.StartPosition = "CenterScreen" # Form zentriert auf Bildschirm
$objForm.Size = New-Object System.Drawing.Size(960,650) # Groesse der Form( Breite x Höhe)
$objForm.Text = "Home Netzwerk Scan" #Titel der Form
$objForm.FormBorderStyle = 1
$objForm.AllowTransparency =$true
$objForm.Opacity = .98;
$objForm.ControlBox = $true
#$objForm.Add_Closing({RemoveAllSessions}) #abfangen von close und remove sessions
#$objForm.BackgroundImage =[system.drawing.image]::FromFile("C:\Users\Dell\Desktop\Kalenderwoche 23\Projekt\photo-1579548122080-c35fd6820ecb.jfif")
$objForm.BackgroundImageLayout = "Stretch"
$objForm.ForeColor = "black"
#$objForm.BackColor = "Grey";
#$objForm.add_paint({$brush = new-object System.Drawing.Drawing2D.LinearGradientBrush((new-object system.drawing.point 0,0),(new-object system.drawing.point($this.clientrectangle.width,$this.clientrectangle.height)),"black","white")
#  $_.graphics.fillrectangle($brush,$this.clientrectangle)
  # })
#$objForm.TransparencyKey = $objForm.BackColor
#$objForm.TaskbarItemInfo.Overlay = "C:\"
#$objForm.Icon = [Drawing.Icon]::ExtractAssociatedIcon((Get-Command powershell).Path)
#$objForm.TopMost = "True" # Form im Vordergrund starten; topmost nervt

#Manuelle Ip Eingabe
$ObjPingBox = New-Object System.Windows.Forms.TextBox 
$ObjPingBox.Location = New-Object System.Drawing.Size(180,260) 
$ObjPingBox.Size = New-Object System.Drawing.Size(100,20) 
$ObjPingBox.MultiLine = $False 
$ObjPingBox.Add_KeyPress({if ( ($_.KeyChar -notlike "[0-9 , .]") -and ([int]$_.KeyChar -ne 8 )) {$_.Handled = $true} })
$ObjPingBox.AppendText("")
$objForm.Controls.Add($ObjPingBox)

#ProgressBar
    
#$ProgressBar = New-Object System.Windows.Forms.ProgressBar
#$ProgressBar.Location = "350,200" # Enter Location
#$ProgressBar.Size = "450,25" # Enter Size
#$ProgressBar.Name = "ProgressbarName"
#$objForm.Controls.Add($ProgressBar)

#ExitPsSession
$objExitPsSession = New-Object System.Windows.Forms.Button
$objExitPsSession.Size = New-Object System.Drawing.Size(120,40)
$objExitPsSession.Location = New-Object System.Drawing.Size(170,490)
$objExitPsSession.Text = "Exit PsSession"
$objExitPsSession.Add_Click({exitPsSession})
$objForm.Controls.Add($objExitPsSession)

#Script fuer Remote Einrichtung
$objScript4Remote = New-Object System.Windows.Forms.Button
$objScript4Remote.Size = New-Object System.Drawing.Size(120,40)
$objScript4Remote.Location = New-Object System.Drawing.Size(170,540)
$objScript4Remote.Text = "Script fuer Remote"
$objScript4Remote.Add_Click({RemoteIPEingabe})
$objForm.Controls.Add($objScript4Remote)

#Script fuer Remote Einrichtung auf Host
$objCreateScriptforHost = New-Object System.Windows.Forms.Button
$objCreateScriptforHost.Size = New-Object System.Drawing.Size(120,40)
$objCreateScriptforHost.Location = New-Object System.Drawing.Size(30,540)
$objCreateScriptforHost.Text = "Script fuer Host"
$objCreateScriptforHost.Add_Click({HostIPEingabe})
$objForm.Controls.Add($objCreateScriptforHost)


#EnterPsSession
$objEnterPsSession = New-Object System.Windows.Forms.Button
$objEnterPsSession.Size = New-Object System.Drawing.Size(120,40)
$objEnterPsSession.Location = New-Object System.Drawing.Size(30,490)
$objEnterPsSession.Text = "EnterPsSession"
$objEnterPsSession.Add_Click({})
$objForm.Controls.Add($objEnterPsSession)

#RemoteHardwareInfo
$objRemoteHardwareInfo = New-Object System.Windows.Forms.Button
$objRemoteHardwareInfo.Size = New-Object System.Drawing.Size(120,40)
$objRemoteHardwareInfo.Location = New-Object System.Drawing.Size(680,540)
$objRemoteHardwareInfo.Text = "Remote Hardware Info"
$objRemoteHardwareInfo.Add_Click({RemoteIPEingabe4RemoteInfo})
$objForm.Controls.Add($objRemoteHardwareInfo)

#Save ARP Table  SaveArpTable
$objSaveArpTable = New-Object System.Windows.Forms.Button
$objSaveArpTable.Size = New-Object System.Drawing.Size(120,40)
$objSaveArpTable.Location = New-Object System.Drawing.Size(170,400)
$objSaveArpTable.Text = "Save Arp Table"
$objSaveArpTable.Add_Click({SaveArpTable})
$objForm.Controls.Add($objSaveArpTable)

#ManuellesPing
$objManuellesPing = New-Object System.Windows.Forms.Button
$objManuellesPing.Size = New-Object System.Drawing.Size(120,40)
$objManuellesPing.Location = New-Object System.Drawing.Size(30,250)
$objManuellesPing.Text = "Ip manuell Ping"
$objManuellesPing.Add_Click({ManuellesPing})
$objForm.Controls.Add($objManuellesPing)

#Reachable DNS auflösen
$objReachableHosts = New-Object System.Windows.Forms.Button
$objReachableHosts.Size = New-Object System.Drawing.Size(120,40)
$objReachableHosts.Location = New-Object System.Drawing.Size(170,300)
$objReachableHosts.Text = "Reachable DNS aufloesen"
$objReachableHosts.Add_Click({ReachableHosts})
$objForm.Controls.Add($objReachableHosts)

#löschen TextBox
$objClearTextBox = New-Object System.Windows.Forms.Button
$objClearTextBox.Size = New-Object System.Drawing.Size(120,40)
$objClearTextBox.Location = New-Object System.Drawing.Size(810,185)
$objClearTextBox.Text = "Textbox delete"
$objClearTextBox.Add_Click({ClearTextBox})
#$objClearTextBox.Icon= "C:\Pojekt\imageres_54.ico"
$objForm.Controls.Add($objClearTextBox)


#save JobTextBox
$objJobBoxSave = New-Object System.Windows.Forms.Button
$objJobBoxSave.Size = New-Object System.Drawing.Size(120,40)
$objJobBoxSave.Location = New-Object System.Drawing.Size(810,30)
$objJobBoxSave.Text = "Log save"
$objJobBoxSave.Add_Click({SaveJobBox})
$objForm.Controls.Add($objJobBoxSave)


#save TextBox
$objSaveTextBox = New-Object System.Windows.Forms.Button
$objSaveTextBox.Size = New-Object System.Drawing.Size(120,40)
$objSaveTextBox.Location = New-Object System.Drawing.Size(810,230)
$objSaveTextBox.Text = "Textbox save"
$objSaveTextBox.Add_Click({SaveTextBox})
$objForm.Controls.Add($objSaveTextBox)

#System info dieser PC in TextBox
$objGeLocalSystemInfo = New-Object System.Windows.Forms.Button
$objGeLocalSystemInfo.Size = New-Object System.Drawing.Size(120,40)
$objGeLocalSystemInfo.Location = New-Object System.Drawing.Size(350,540)
$objGeLocalSystemInfo.Text = "Systeminfo dieser PC in TextBox"
$objGeLocalSystemInfo.Add_Click({LocalSystemInfo})
$objForm.Controls.Add($objGeLocalSystemInfo)

#lade letzte IpRange1Count
$objLoadIpRangeOneCount = New-Object System.Windows.Forms.Button
$objLoadIpRangeOneCount.Size = New-Object System.Drawing.Size(120,40)
$objLoadIpRangeOneCount.Location = New-Object System.Drawing.Size(170, 200)
$objLoadIpRangeOneCount.Text = "Letzte 1 Count Adressbuch laden"
$objLoadIpRangeOneCount.Add_Click({Show1Countreply 
                                loadLastOneCountBook})
$objForm.Controls.Add($objLoadIpRangeOneCount)

#öffne Adressbuch mit Notepad
$objInvokeFile = New-Object System.Windows.Forms.Button
$objInvokeFile.Size = New-Object System.Drawing.Size(120,40)
$objInvokeFile.Location = New-Object System.Drawing.Size(170,90)
$objInvokeFile.Text = "Oeffne Adressbuch mit Notepad"
$objInvokeFile.Add_Click({InvokeFile})
$objForm.Controls.Add($objInvokeFile)

#open folder mit explorer
$objOpenFolder = New-Object System.Windows.Forms.Button
$objOpenFolder.Size = New-Object System.Drawing.Size(120,40)
$objOpenFolder.Location = New-Object System.Drawing.Size(170,40)
$objOpenFolder.Text = "Oeffne Ordner mit Explorer"
$objOpenFolder.Add_Click({OpenFolder})
$objForm.Controls.Add($objOpenFolder)

#Arp Table
$objShowArpTable = New-Object System.Windows.Forms.Button
$objShowArpTable.Size = New-Object System.Drawing.Size(120,40)
$objShowArpTable.Location = New-Object System.Drawing.Size(30,400)
$objShowArpTable.Text = "Zeige Arp Tabelle"
$objShowArpTable.Add_Click({ShowArpTable})
$objForm.Controls.Add($objShowArpTable)

#textbox
$ObjTextBoxoutputBox = New-Object System.Windows.Forms.TextBox 
$ObjTextBoxoutputBox.Location = New-Object System.Drawing.Size(350,185) 
$ObjTextBoxoutputBox.Size = New-Object System.Drawing.Size(450,350) 
$ObjTextBoxoutputBox.ReadOnly = $true 
$ObjTextBoxoutputBox.MultiLine = $True 
$ObjTextBoxoutputBox.ScrollBars = "Vertical"
$ObjTextBoxoutputBox.BackColor = "MidnightBlue"
$ObjTextBoxoutputBox.AppendText("")
$ObjTextBoxoutputBox.ForeColor = "white"
$ObjTextBoxoutputBox.Font =  "Enviro, 12"
#$ObjTextBoxoutputBox.Font= new Font(textBox1.Font, FontStyle.Bold);
#$ObjTextBoxoutputBox.Font.Style.
$objForm.Controls.Add($ObjTextBoxoutputBox)

#Jobstatus
$ObjTextBox4Job = New-Object System.Windows.Forms.TextBox 
$ObjTextBox4Job.Location = New-Object System.Drawing.Size(350,30) 
$ObjTextBox4Job.Size = New-Object System.Drawing.Size(450,100)
$ObjTextBox4Job.ReadOnly = $true 
$ObjTextBox4Job.BackColor = "MidnightBlue"
$ObjTextBox4Job.Font =  "Enviro, 10"
$ObjTextBox4Job.ForeColor = "white"
$ObjTextBox4Job.MultiLine = $True 
$ObjTextBox4Job.ScrollBars = "Vertical"
$ObjTextBox4Job.AppendText("")
$objForm.Controls.Add($ObjTextBox4Job)

# Online Adressen 4 count anpingen
$obj4CountPing = New-Object System.Windows.Forms.Button
$obj4CountPing.Size = New-Object System.Drawing.Size(120,40)
$obj4CountPing.Location = New-Object System.Drawing.Size(30, 300)
$obj4CountPing.Text = "Online Adressen 4 count anpingen"
$obj4CountPing.Add_Click({ 4CountPing })#-IpRange $Adressbuch2 -RepliedIPs $OnlineAdressen -onlineAnzhal $online})
$objForm.Controls.Add($obj4CountPing)

#one count ping
$objAllIPOneCount = New-Object System.Windows.Forms.Button
$objAllIPOneCount.Size = New-Object System.Drawing.Size(120,40)
$objAllIPOneCount.Location = New-Object System.Drawing.Size(30, 200)
$objAllIPOneCount.Text = "Scannen starten"
$objAllIPOneCount.BackColor  = "yellow"
$objAllIPOneCount.Add_Click({ AllIPOneCount })#-IpRange $Adressbuch2 -RepliedIPs $OnlineAdressen -onlineAnzhal $online})
$objForm.Controls.Add($objAllIPOneCount)

#JustOneClick
$objJustOneClick = New-Object System.Windows.Forms.Button
$objJustOneClick.Size = New-Object System.Drawing.Size(120,40)
$objJustOneClick.Location = New-Object System.Drawing.Size(820,540)
$objJustOneClick.Text = "Automatic Proceed"
$objJustOneClick.BackColor  = "green"
$objJustOneClick.Add_Click({OneClick})
$objForm.Controls.Add($objJustOneClick)

#Adressbuch fuellen und erstellen
$objAdressbuch = New-Object System.Windows.Forms.Button
$objAdressbuch.Size = New-Object System.Drawing.Size(120,40)
$objAdressbuch.Location = New-Object System.Drawing.Size(30,90)
$objAdressbuch.Text = "Adressbuch fuellen und erstellen"
$objAdressbuch.Add_Click({AdressbuchErstellen})
$objForm.Controls.Add($objAdressbuch)

#CreateFileFolder
$objCreateFileFolder = New-Object System.Windows.Forms.Button
$objCreateFileFolder.Size = New-Object System.Drawing.Size(120,40)
$objCreateFileFolder.Location = New-Object System.Drawing.Size(30,40)
$objCreateFileFolder.Text = "CreateFileFolder"
$objCreateFileFolder.Add_Click({CreateFileFolder})
$objForm.Controls.Add($objCreateFileFolder)

# GroupArpBox 
$ObjGroupArpBox = New-Object System.Windows.Forms.GroupBox
$ObjGroupArpBox.Location = New-Object System.Drawing.Point(20, 380)
$ObjGroupArpBox.Size = New-Object System.Drawing.Size(282, 80)
$ObjGroupArpBox.TabIndex = 0
$ObjGroupArpBox.TabStop = $false
$ObjGroupArpBox.Text = "Arp Tabelle als Vergleich"
$objForm.Controls.Add($ObjGroupArpBox)

# GroupRemoteTools 
$ObjGroupRemoteTools = New-Object System.Windows.Forms.GroupBox
$ObjGroupRemoteTools.Location = New-Object System.Drawing.Point(20, 470)
$ObjGroupRemoteTools.Size = New-Object System.Drawing.Size(282, 130)
$ObjGroupRemoteTools.TabIndex = 0
$ObjGroupRemoteTools.TabStop = $false
$ObjGroupRemoteTools.Text = "Remote tools"
$objForm.Controls.Add($ObjGroupRemoteTools)

# GroupBox 
$ObjGroupbox = New-Object System.Windows.Forms.GroupBox
$ObjGroupbox.Location = New-Object System.Drawing.Point(20, 20)
$ObjGroupbox.Size = New-Object System.Drawing.Size(282, 130)
$ObjGroupbox.TabIndex = 0
$ObjGroupbox.TabStop = $false
$ObjGroupbox.Text = "Windows Explorer Actions"
<#$ObjGroupbox.add_paint({$brush = new-object System.Drawing.Drawing2D.LinearGradientBrush((new-object system.drawing.point 0,0),(new-object system.drawing.point($this.clientrectangle.width,$this.clientrectangle.height)),"black","blue")
    $_.graphics.fillrectangle($brush,$this.clientrectangle)
    })#>
$objForm.Controls.Add($ObjGroupbox)

# IPGroupBox 
$IPGroupBox = New-Object System.Windows.Forms.GroupBox
$IPGroupBox.Location = New-Object System.Drawing.Point(20, 180)
$IPGroupBox.Size = New-Object System.Drawing.Size(282, 180)
$IPGroupBox.TabIndex = 0
$IPGroupBox.TabStop = $false
$IPGroupBox.Text = "Ip Scanner"
#$IPGroupBox.add_paint({$brush = new-object System.Drawing.Drawing2D.LinearGradientBrush((new-object system.drawing.point 0,0),(new-object system.drawing.point($this.clientrectangle.width,$this.clientrectangle.height)),"black","blue")
#   $_.graphics.fillrectangle($brush,$this.clientrectangle)
  # })
$objForm.Controls.Add($IPGroupBox)



[void] $objForm.ShowDialog() # Form anzeigen las letztes
