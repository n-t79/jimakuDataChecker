# 分割してサポーターに修正してもらった「for_check_xxxxx.vtt.txt」ファイルを1つのファイルに結合するプログラム
# 作成開始 : 2021.4.29
# 作成終了 : 2021.4.29
# プログラムの更新 : 未更新


#####はじめに，ワーキングディレクトリ（作業するフォルダ）を設定しておく。#####
$workingFPath = Set-Location
###########################################################

cd $myFilePath


Write-Host "2つ以上の「for_check_xxxxx.vtt.txt」ファイルを"
Write-Host "1つのファイルに結合します。"
Write-Host ""
Read-host "press Enter key to continue"



$ErrorActionPreference = "Stop" #エラーが発生した時には，処理を中止する設定とする。

##### 「for_check_」から始まり、「.vtt.txt」で終わるファイル名のファイルを探して、 $targetFiles に格納する。

$targetFiles = Get-ChildItem "for_check_*.vtt.txt" | Sort-Object { $_.Name }

Write-Host "結合対象のファイルは次の通りです。"
Write-Host ""
$i = 1
foreach ($targetFile in $targetFiles)
{
    Write-Host "  $($i)番目のファイル : " $targetFile.Name
    $i += 1
}
Write-Host ""


Write-Host ""
Write-Host "これらのファイルを結合しますか？"
Write-Host "press 'y' for Yes"
Write-Host "press other keys for No"
Write-Host ""
$discrim = Read-Host "press 「y」 + Enter key to continue..."
# Write-Host $discrim

if ($discrim -eq "y") {
    # Write-Host "処理を続けます。"
}
else {
    Write-Host "【警告】処理を中止します。"
    Read-host "press Enter key to end"
    exit
}
Write-Host ""
Write-Host ""



##### targetFiles それぞれの先頭および末尾5行を表示する。

$i = 1
foreach ($targetFile in $targetFiles)
{
    Clear-Host
    Write-Host "【$($i)番目のファイル】" $targetFile.Name
    Read-host "press Enter key to continue"
    Write-Host "(先頭5行)"
    Get-Content $targetFile -Encoding UTF8 -TotalCount 5
    Read-host "---------- press Enter key to continue ----------"
    Write-Host "(末尾5行)"
    Get-Content $targetFile -Encoding UTF8 -Last 5
    Read-host "++++++++++ press Enter key to continue ++++++++++"
    $i += 1
}
Write-Host ""



##### $targetFiles の最初の（先頭の）ファイルをコピーし、結合データのベースとなるファイルを作製する。 #####

Copy-Item $targetFiles[0].Name -Destination "conbined.vtt.txt"

# Write-Output "" | Add-Content conbined.vtt.txt -Encoding UTF8
# Write-Output "" | Add-Content conbined.vtt.txt -Encoding UTF8


##### $targetFiles[0]を除いて、$targetFiles[1]、$targetFiles[2]　...　を add-content していく。 #####

for ($i=1; $i -le $targetFiles.Length - 1 ; $i++){
    Write-Output "" | Add-Content conbined.vtt.txt -Encoding UTF8
    Write-Output "" | Add-Content conbined.vtt.txt -Encoding UTF8
    Write-Output "NOTE Working Files are conbined at this line." | Add-Content conbined.vtt.txt -Encoding UTF8
    Write-Output "" | Add-Content conbined.vtt.txt -Encoding UTF8
    Write-Output "" | Add-Content conbined.vtt.txt -Encoding UTF8
    Get-Content $targetFiles[$i] -Encoding UTF8 | Add-Content conbined.vtt.txt -Encoding UTF8
    Write-Host ""
    Write-Host ""
}



Write-Host "ファイルを結合し、「conbined.vtt.txt」を作成しました。"
Write-Host "適宜、ファイル名を変更してください。"
Write-Host ""
Read-host "press Enter key to end"
