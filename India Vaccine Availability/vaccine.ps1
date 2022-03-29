
Clear-Host
Add-Type -AssemblyName System.speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$waitSeconds = 15
$flag = 0

$city_id=0

if($null -eq $city_id -or $city_id -eq 0)
{
    $speak.Speak("Enter your city name")
    $city=read-host "Enter your city name"


    $execution=$true
    $city_range=1
    do
    {
        $uri = "https://cdn-api.co-vin.in/api/v2/admin/location/districts/$city_range" 
        $webData = Invoke-RestMethod -Uri $uri
        if($webdata.districts -match $city)
        {
            $execution=$false
            $city_id=($webdata.districts -match $city).district_id
            $msg="City $city found in the list with district code as $city_id"
            write-host $msg
            $speak.Speak($msg)
            break

        }
        $webdata=$uri=$null
        $city_range++
    }while($execution -and $city_range -lt 40)
 }


$speak.Speak("Please enter desired slot date in format of dd-mm-yyyy")  
$date = Read-Host "Please enter desired slot date (dd-mm-yyyy)"#"06-05-2021"


do
{
    $speak.Speak("Please enter age group")
    [int]$minAgeLimit = Read-Host "Please enter age group (18 or 45)" # 18 or 45
}
while($minAgeLimit.GetType().Name -ne 'Int32' -or $minAgeLimit -notin(18,45))

#$city_id= Read-Host "Please enter district id (default is Mumbai)"
if($city_id -eq '')
{
	$city_id = 395 # default value
}

try
{
	do
	{
	$currentTime = Get-Date -Format "dd/MMM/yyyy HH:mm:ss"
	$uri = "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=$city_id&date=$date"
	$webData = Invoke-RestMethod -Uri $uri
	$dataCount = 0
    $sr=0

	if($null -ne $webData.sessions -and $webData.sessions.Count -gt 0)
	{
        write-host "-----------------------------------------------------------------------------------------------"
		foreach($session in $webData.sessions)
		{
			if($null -eq $session.min_age_limit -OR $session.min_age_limit -le $minAgeLimit)
			{
                $sr++
				write-host "$sr. Block: "$session.block_name",			Pin Code: "$session.pincode",	" -nonewline        
				write-host "Available: "$session.available_capacity -ForegroundColor White -BackgroundColor DarkGreen
                $Phrase = "Vaccine available at $($session.block_name) with pin code $($session.pincode) having capacity of $($session.available_capacity)"
                $speak.Speak($Phrase)
				$dataCount = $dataCount + 1        
			}          
		}
        write-host "-----------------------------------------------------------------------------------------------"
	}

	if($dataCount -eq 0)
	{
		Write-Host "No slot available." -ForegroundColor White -BackgroundColor Red
        $speak.Speak("No slot available.")
	}
	else
	{
		[console]::beep(3000,500)
	}

#mumbai 395
#Delhi 146
#Goa 151
#Pune 363
#Jaipur 505


	Write-Host
	Write-Host "LastRefresh: $currentTime, Age Group: $minAgeLimit Years, Next Refresh In: $waitSeconds Seconds" -ForegroundColor Yellow
	Write-Host "---------------------------------------------------------"
	Start-Sleep -s $waitSeconds
	}while($flag -eq 0)

}
catch{
	write-error "An Error Occurred."
}