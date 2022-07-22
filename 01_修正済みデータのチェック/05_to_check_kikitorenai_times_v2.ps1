#プログラムの更新日：2020.10.03
#プログラムの更新日：2021.4.29

#####はじめに，ワーキングディレクトリ（作業するフォルダ）を設定しておく。#####
$workingFPath = Set-Location
###########################################################

cd $workingFPath


Write-Host "ファイル名が「.vtt」で終わるファイルを1つだけ作業フォルダに保存してください。"
Write-Host "解析して次のテキストファイルを作成します。"
Write-Host ""
Write-Host "    check99_kikitorenai_times_xxxxx.txt : 「聞こえない」「聞き取れない」の行とその時刻を取り出す。"
Write-Host ""
Read-host "press Enter key to continue"


#####check99_kikitorenai_times.logの作成：「聞こえない」「聞き取れない」の行とその時刻を取り出して書き出すプログラム(2020.10.03作成)#####

$forCheckFile = @(Get-ChildItem -Path "*.vtt")
$forCheckFileNum = $forCheckFile.Length

Write-Host ""
Write-Host "checkするファイル数 : " $forCheckFileNum


# 「.vtt」で終わるファイルのファイル数が1でない場合、処理を終了する（エラーとする）。

If($forCheckFileNum -ne 1){
    Write-Host "Warning!"
    Write-Host "    「.vtt」で終わるファイルのファイル数が1でありません。"
    Write-Host "    処理を終了します。"
    Write-Host ""
    Read-host "press Enter key to end"
    exit
}

Write-Host ""
Write-Host "checkするファイル名 : " $forCheckFile.Name
Write-Host ""
Read-host "press Enter key to continue"


# Start-Transcript check99_kikitorenai_times.log
Start-Transcript $("check99_kikitorenai_times_" + $($forCheckFile.Name) + ".txt")

Write-Host ""
Write-Host ""
Write-Host "##### このログファイルは，文字列「聞こえない」または「聞き取れない」を検索し，" 
Write-Host "##### その行と，その行の前の行，その行の前の前の行の3行を書き出したものです。" 
Write-Host "##### 必要な情報に整形して利用してください。" 
Write-Host ""
Write-Host ""

for ($k=0; $k -lt $forCheckFileNum; $k++){

    $Line = Get-Content $forCheckFile[$k] -Encoding UTF8
    $allLineNum = $Line.Length

    $j = 1

    for ($i=0; $i -lt $allLineNum; $i++){
#        if($Line[$i] -match ".*-.*-.*-.*-" -and $Line[$i+1] -notmatch "-->"){
         if(($Line[$i] -match "聞こえない") -Or ($Line[$i] -match "聞き取れない")){
            #Write-Host "##### No." $j " :" 
#            Write-Host $forCheckFile[$k].Name " - No." $j
            Write-Host $($i-1) " 行目:" $Line[$i-2] 
            Write-Host $($i) " 行目:" $Line[$i-1] 
            Write-Host $($i+1) " 行目:" $Line[$i] 
#            Write-Host $Line[$i]
#            Write-Host $Line[$i+1]
            Write-Host ""
            Write-Host ""
            $j++
        }
    } 

}


Stop-Transcript


Write-Host ""
Write-Host ""
Write-Host "check99_kikitorenai_times.log"
Write-Host "を作成/更新しました"
Write-Host ""
Write-Host ""
Read-host "press Enter key to end"

