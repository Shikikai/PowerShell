function GetGreeting([datetime]$datetime) {
    $greet = ""
    if ($datetime.Hour -ge 5 -and $datetime.Hour -lt 11) {
        $greet = "おはようございます"
    }
    elseif ($datetime.Hour -ge 11 -and $datetime.Hour -lt 19 ) {
        $greet = "こんにちは"
    }
    else {
        $greet = "こんばんは"
    }
    return $greet
}

$today = Get-Date
#デバッグ用
 $today = [DateTime]::ParseExact("2020/01/01", "yyyy/MM/dd", $null)

$queryDate = $today.ToString("yyyyMMdd")
$statusCode = 0
$restResult = $null

try {
    $restResult = Invoke-RestMethod -Uri https://api.national-holidays.jp/$queryDate -Method Get
}
catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
}

$daySummary = ""

if ($null -ne $restResult) {
    $outDate = $today.ToString("D")
    $dateName = $restResult.name
    $daySummary = "本日${outDate}は${dateName}です"
}
elseif ($null -ne $restResult && $statusCode -ne 200) {
    $day = Get-Date -Format D
    $daySummary = "本日は${day}です"
}
# $testhour = [DateTime]::ParseExact("2018/01/01 10:22:33","yyyy/MM/dd hh:mm:ss", $null);
$greet = GetGreeting $today
Write-Host "${greet}、${env:USERNAME}さん"
Write-Host $daySummary

Remove-Variable today, queryDate, statusCode, restResult, greet, daySummary
