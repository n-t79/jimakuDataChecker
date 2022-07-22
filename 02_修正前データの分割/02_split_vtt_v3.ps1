# 作成開始 2020.11.14
# 作成終了 2020.11.15
# プログラムの更新日：2021.4.29
# vttファイルを分割するプログラム
# 更新 2021.07.01 : 最後に作成されるsplit_xxx.txtのファイル名のうち「分」を表す部分について、例えば「1分」などの一桁の場合は「1m」ではなく「01m」と2桁表記するように修正した。
# 更新 2021.09.20 : YouTube または LecRec からダウンロードしたvttファイルにも対応するように、動画全体の時間の捉え方を変更した。バージョンアップし、v3とした。

##### 作業ディレクトリの設定。ターミナルが開いている場所を、作業ディレクトリとする。
$myFilePath = Get-Location
###############################################################

Set-Location $myFilePath

$ErrorActionPreference = "Stop" #エラーが発生した時には，処理を中止する設定とする。


##### 各種関数の設定。ここから。 #####
function press_enter_key{
    Write-Host ""
    Write-Host ""
    Read-Host "> press enter key to continue ... "
    Write-Host ""
    Write-Host ""
}

##### 各種関数の設定。ここまで。 #####


##### vttファイルが1つ格納されている場合は，処理を続ける。それ以外の場合は，処理を中止する。ここから。 ##########
if ((@(Get-ChildItem *.vtt)).Length -eq 1)
{
    Write-Host "# vttファイルを分割するプログラムを実行します。"
    press_enter_key
}
else
{
    Write-Host "【警告】vttファイルがありません。または，2つ以上のvttファイルが見つかりました。"
    Write-Host "【警告】処理を中止します。"
    Read-host "press Enter key to end"
    exit
}
##### vttファイルが1つ格納されている場合は，処理を続ける。それ以外の場合は，処理を中止する。ここまで。 ##########



##### 確認のため、対象とするvttファイルの内容のうち、先頭および末尾の５行ずつを表示する。ここから。 #####
Clear-Host
Write-Host "##### ファイル先頭から5行を表示 ##########"
Get-Content *.vtt -Encoding UTF8 -TotalCount 5
Write-Host ""
Write-Host ""
press_enter_key

Write-Host "##### ファイル末尾から5行を表示 ##########"
Get-Content *.vtt -Encoding UTF8 -Last 5
Write-Host ""
Write-Host ""
press_enter_key
Clear-Host
##### 確認のため、対象とするvttファイルの内容のうち、先頭および末尾の５行ずつを表示する。ここから。 #####

##### vttの内容と、そのうちの時刻行の部分を格納。ここから。 #####
$myVtt = Get-Content *.vtt -Encoding UTF8
$myVttTimes = $myVtt | Select-String -Pattern " --> "
##### vttの内容と、そのうちの時刻行の部分を格納。ここまで。 #####


##### 時刻行のデータのうち最大のもの（時刻行の最終行の右側）を取り出して字幕の長さとして設定する。ここから。 #####
$myDuration = $myVttTimes[-1].ToString()
# $myDuration = ($myVtt | Select-String -Pattern "^NOTE duration").ToString()

$timeStartNum = $myDuration.IndexOf('>') + 2
# $timeStartNum = $myDuration.IndexOf('"') + 1

Write-Host ""
Write-Host "##### 動画（字幕）の長さ ##########"
$myDuration = $myDuration.Substring($timeStartNum,8)
# $myDuration = $myDuration.Substring($timeStartNum,8)
$myDuration
Write-Host ""
##### 時刻行のデータのうち最大のもの（時刻行の最終行の右側）を取り出して字幕の長さとして設定する。ここまで。 #####


##### $myDurationの文字列をhms表記対応にする。ここから。 #####
$myDuration_h = [Byte]$myDuration.Substring(0,2)
$myDuration_m = [Byte]$myDuration.Substring(3,2)
$myDuration_hm_string = $myDuration_h.ToString() + "h" + ("00" + $myDuration_m.ToString()).Substring(("00" + $myDuration_m.ToString()).Length -2, 2) + "m"
press_enter_key
##### $myDurationの文字列をhms表記対応にする。ここまで。 #####



Write-Host ""
Write-Host "##### vttファイルの分割数を入力してください ##########"
[ValidateRange(2,10)]$splitNum = [Byte](Read-Host vttファイルの分割数を入力（半角数字　「2」～「10」）)
Write-Host "分割数は $($splitNum)"




$splitTimeArr = New-Object 'Byte[,]' ($splitNum-1), 3 #二次元配列の変数を作成。行数は「$splitNum-1」，列数は「3」。

Write-Host ""
Write-Host "##### ファイルを分割する時間(時刻)を入力してください ##########"
for ($i=0; $i -lt $splitNum - 1 ; $i++){
    Write-Host "$($i+1) つめの分割点を入力: "
    $splitTimeArr[$i, 0] = [Byte](Read-Host 時間を入力)
    $splitTimeArr[$i, 1] = [Byte](Read-Host 分を入力（0～59）)
    $splitTimeArr[$i, 2] = [Byte](Read-Host 秒を入力（0～59）)
    Write-Host "$($i+1) つめの分割点: $($splitTimeArr[$i,0])時間 $($splitTimeArr[$i,1])分 $($splitTimeArr[$i,2])秒"
    Write-Host ""
}




$fileNameTimeStr = @() #後で，分割ファイルを作成したときに，ファイル名に時間を入れるために配列を作成。

Write-Host "##### ファイルの分割時間(時刻)入力結果 ##########"
Write-Host "■　Start"
Write-Host "|"
for ($i=0; $i -lt $splitNum - 1; $i++){
    Write-Host "■　$($i+1) つめの分割点: $($splitTimeArr[$i,0])時間 $($splitTimeArr[$i,1])分 $($splitTimeArr[$i,2])秒"
    Write-Host "|"
    $fileNameTimeStr += ($splitTimeArr[$i,0]).ToString() + "h" + ("00"+($splitTimeArr[$i,1]).ToString()).Substring(("00"+($splitTimeArr[$i,1]).ToString()).Length - 2, 2) + "m"
}
Write-Host "■　End"



#####上で入力した，$splitTimeArr を TimeSpan Object に変換して配列に格納する。 ##########

$splitTimes = @()

for ($i=0; $i -lt $splitNum - 1; $i++){
    $splitTimes += New-TimeSpan -Hours $splitTimeArr[$i, 0] -Minutes $splitTimeArr[$i, 1] -Seconds $splitTimeArr[$i, 2]
}





##### $splitTimesに格納した時間のデータが小さい順に並んでいるかチェック。並んでいなければ，プログラムを中止する。 ##########
for ($i = 0; $i -lt $($splitTimes.Length-1); $i++){
    if ($splitTimes[$i] -lt $splitTimes[$i+1])
    {
    }
    else
    {
        Write-Host ""
        Write-Host "【警告】ファイルの分割時間(時刻)の設定が無効です。"
        Write-Host "【警告】処理を中止します。"
        exit
    }
}



Write-Host ""
Read-host "press Enter key to continue"
Write-Host ""




##### vttに記載されている時刻表記を TimeSpan Object に変換 #####

$myVttTimesTimeSpan = @()

for ($i=0; $i -lt $myVttTimes.Length ; $i++){

    # $myVttTimes[$i].ToString().Substring(0, 8)

    $myVttTimes_h = [Byte]$myVttTimes[$i].ToString().Substring(0, 2)
    $myVttTimes_m = [Byte]$myVttTimes[$i].ToString().Substring(3, 2)
    $myVttTimes_s = [Byte]$myVttTimes[$i].ToString().Substring(6, 2)

    $myVttTimesTimeSpan += New-TimeSpan -Hours $myVttTimes_h -Minutes $myVttTimes_m -Seconds $myVttTimes_s

}


##### 分割する行数を特定する。ここから。 #####
# 分割する際、vttデータが stream / youtube / LecRec のいずれからの由来か特定し、分割する行数を調整する。

# vttのタイプを選択する。

Write-Host "# vttのタイプを選択してください。"
Write-Host ""
Write-Host "  1 : Streamタイプ"
Write-Host "  2 : YouTubeタイプ"
Write-Host "  3 : LecRecタイプ"
Write-Host ""

$vtt_type = ""
do {
    $vtt_type = [string](Read-Host "> press 1 or 2 or 3")
}
while (-Not($vtt_type -in @("1", "2", "3")))

Write-Host ""

# vttのタイプにより分割する行の調整数を変える。
$lines_num_for_adjust = 3 # 標準ではstreamタイプの「3」に設定しておく。

switch ($vtt_type){
    1 {
        Write-Host "# 選択したvttタイプは、 【1 : Streamタイプ】 です。"
        $lines_num_for_adjust = 3
    }
    2 {
        Write-Host "# 選択したvttタイプは、 【2 : YouTubeタイプ】 です。"
        $lines_num_for_adjust = 0
    }
    3 {
        Write-Host "# 選択したvttタイプは、 【3 : LecRecタイプ】 です。"
        $lines_num_for_adjust = 0
    }
}
Write-Host ""
press_enter_key
Clear-Host



$split_lineNum = @()

for ($i=0; $i -lt $splitTimes.Length ; $i++) {
    $split_lineNum += $myVttTimes[($myVttTimesTimeSpan -lt $splitTimes[$i]).Length].LineNumber - 1 - $lines_num_for_adjust
}

Write-Host ""
Write-Host "##### 分割する行の位置(行目) ##########"
$split_lineNum
Write-Host ""
Write-Host ""


Write-Host ""
Read-host "press Enter key to continue"
Write-Host ""
##### 分割する行数を特定する。ここまで。 #####





if ($splitNum -eq 2)
{
    $myVtt[0..($split_lineNum[0]-1)] | Set-Content -Path "split1_0h00m_to_$($fileNameTimeStr[0])_$($myVtt.PSchildName[0]).txt" -Encoding UTF8
    $myVtt[($split_lineNum[0])..($myVtt.Length)] | Set-Content -Path "split$($splitNum)_$($fileNameTimeStr[0])_to_$($myDuration_hm_string)_$($myVtt.PSchildName[0]).txt" -Encoding UTF8
    Write-Host "##### 結果 ##########"
    Write-Host "$($splitNum)つに分割したファイルを作成しました。"
}
elseif ($splitNum -ge 3)
{

    $myVtt[0..($split_lineNum[0]-1)] | Set-Content -Path "split1_0h00m_to_$($fileNameTimeStr[0])_$($myVtt.PSchildName[0]).txt" -Encoding UTF8
    
    for ($i=0; $i -lt ($splitNum-1-1); $i++){
        $myVtt[($split_lineNum[$i])..($split_lineNum[$i+1]-1)] | Set-Content -Path "split$($i+2)_$($fileNameTimeStr[$i])_to_$($fileNameTimeStr[$i+1])_$($myVtt.PSchildName[0]).txt" -Encoding UTF8
    }

    $myVtt[($split_lineNum[($splitNum-1-1)])..($myVtt.Length)] | Set-Content -Path "split$($splitNum)_$($fileNameTimeStr[-1])_to_$($myDuration_hm_string)_$($myVtt.PSchildName[0]).txt" -Encoding UTF8
    Write-Host "##### 結果 ##########"
    Write-Host "$($splitNum)つに分割したファイルを作成しました。"
}
else
{
    # <前の条件がいずれも満たされない場合に実行されるコードブロック>
    Write-Host "分割数がelseの場合は，工事中です。"
}




for ($i = 0; $i -lt (@(Get-ChildItem -Path *.vtt.txt)).Length; $i++){

    Write-Host "$((Get-ChildItem -Path *.vtt.txt)[$i].Name)  全$((Get-Content (Get-ChildItem -Path *.vtt.txt)[$i]).Length)行"

}




Write-Host ""
Write-Host ""
Read-host "press Enter key to end"


