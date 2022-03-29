clear-host
function stop_p
{
	get-process chrome | Stop-Process -force
			get-process msedge | Stop-Process -force
			get-process iexplore | Stop-Process -force
}
$search_url='https://www.youtube.com/results?search_query=mycammyjourney&sp=QgIIAQ%253D%253D'
$custom_url='https://www.youtube.com/mycammyjourney'
$url=import-csv c:\temp\youtube_url.csv
	do
	 {
		foreach($i in $url)
		{
			try
			{
				$app=get-random -Maximum 4 -Minimum 1
				$div=get-random -Maximum 5 -Minimum 1
				$rand=get-random -Maximum 700 -Minimum 500
				$app=2
				if($app -eq 1)
				{
					"IE"
					$($i.name)
					if($true)
					{
						$IE1=new-object -com internetexplorer.application
						$IE1.navigate2($search_url)
					}
					$IE=new-object -com internetexplorer.application
					$IE.navigate2($i.url)
					start-sleep $($($i.time)/$div)
					#stop_p
					try{get-process iexplore -erroraction silentlycontinue| Stop-Process -force -erroraction silentlycontinue}catch{}
					try{get-process msedge -erroraction silentlycontinue| Stop-Process -force -erroraction silentlycontinue}catch{}
					try{get-process chrome -erroraction silentlycontinue| Stop-Process -force -erroraction silentlycontinue}catch{}
					start-sleep [int]$($i.time)/$div
				}
				if($app -eq 3)
				{
					"EDGE"
					$($i.name)
					if($true)
					{
						start microsoft-edge:$search_url
						#start microsoft-edge:$custom_url
					}
					start microsoft-edge:$($i.url)
					start-sleep $($($i.time)/$div)
					#stop_p
					try{get-process iexplore -erroraction silentlycontinue| Stop-Process -force -erroraction silentlycontinue}catch{}
					try{get-process msedge -erroraction silentlycontinue| Stop-Process -force -erroraction silentlycontinue}catch{}
					try{get-process chrome -erroraction silentlycontinue| Stop-Process -force -erroraction silentlycontinue}catch{}
					start-sleep [int]$($i.time)/$div
				}
				if($app -eq 2)
				{
					"CHROME"
					$($i.name)
					if($true)
					{
						start chrome $search_url
						start chrome $custom_url
					}
					start chrome $($i.url)
					start-sleep $($($i.time)/$div)
					#stop_p
					try{get-process iexplore -erroraction silentlycontinue| Stop-Process -force -erroraction silentlycontinue}catch{}
					try{get-process msedge -erroraction silentlycontinue| Stop-Process -force -erroraction silentlycontinue}catch{}
					try{get-process chrome -erroraction silentlycontinue| Stop-Process -force -erroraction silentlycontinue}catch{}
					start-sleep [int]$($i.time)/$div
				}
			}
			catch
			{}
		}
			$ie=$ie1=$ie2=$p_list=$null
			$second=[int]$((get-date).minute)
			$hour=[int]$((get-date).hour)
			$pause_time=[int](get-random -maximum $rand -minimum ($second+$hour+100))
			$pause_time
			"Paused for $pause_time"
	}while($true)
