function get-MF($url)
{
    $WebResponse = Invoke-WebRequest $url
    (($webresponse.ParsedHtml.getElementsByTagName('span') | Where-Object{ $_.className -eq 'amt' } ).innerText)[0]
    (($webresponse.ParsedHtml.getElementsByTagName('span') | Where-Object{ $_.className -eq 'green_text' } ).innerText)
}

#"https://www.moneycontrol.com/mutual-funds/nav/sbi-blue-chip-fund/MSB079" 
function get-sharePrice()
{
    $WebResponse = Invoke-WebRequest $url 
    $share_price=($webresponse.ParsedHtml.getElementsByTagName('div') | Where-Object{ $_.className -eq 'BNeawe iBp4i AP7Wnd' } ).innerText 
    $current_price=$share_price.Split(' ')[0]
    $increased_price=$share_price.Split(' ')[1]
    $percentage_increase=$share_price.Split(' ')[2]
    $current_price
    $increased_price
    $percentage_increase
}
$share_result=@()
$share_list=@('sbi','icici bank','idfc bank','bel','infosys','axis bank')
foreach($i in $share_list)
{
    $url= "https://www.google.com/search?q=$($i)+share+price+bse&rlz=1C1GGRV_enIN765IN765&oq=infosys+share+price+bse&aqs=chrome..69i57j69i59j0l5j69i60.8838j0j4&sourceid=chrome&ie=UTF-8"
    $share=get-sharePrice
    $temp_result=[PSCustomObject]@{
    'Share Name' = $i.toupper()
    'Current Share Price' = $share[0]
    'Change in share price'= $share[1]
    'Percentage change'= $share[2]
}
$share_result+=$temp_result
$temp_result=$share=$url=$null

}

$share_result






