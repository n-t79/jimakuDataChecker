#プログラムの更新日：2020.5.30
#プログラムの更新日：2021.4.29
#プログラムの更新日：2021.9.19 v3にバージョンアップ。

#####はじめに，ワーキングディレクトリ（作業するフォルダ）を設定しておく。#####
$workingFPath = Set-Location
###########################################################

cd $workingFPath


Write-Host "# 修正済（修正中）のテキストファイルのコピーを作成します。"
Write-Host "  テキストファイルは、拡張子が「.txt」を検索します。"
Write-Host ""
Write-Host "# コピーするときに、ファイル名の冒頭に「for_check_」を付けます。"
Write-Host ""
Read-host "press Enter key to continue"

$i = 0

Get-ChildItem *.txt | ForEach-Object{
     # Write-Host "for_check_" + $_.Name
     $copyName = "for_check_" + $_.Name
     Copy-Item $_.Name -Destination $copyName
     $i += 1
}
#修正済（修正中）のテキストファイルのコピーを作成する。
#コピーするときに，ファイル名の冒頭に，「for_check_」を付ける。

Write-Host $i "個のファイルをコピーしました"
Write-Host ""
Write-Host ""
Read-host "press Enter key to end"
