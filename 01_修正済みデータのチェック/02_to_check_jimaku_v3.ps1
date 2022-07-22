#プログラムの更新日：2020.6.23
#プログラムの更新日：2021.9.19 ... YouTube と LecRec の .vtt形式に対応するための更新を実施。v3にバージョンアップ。

#####はじめに，ワーキングディレクトリ（作業するフォルダ）を設定しておく。#####
$workingFPath = Set-Location
###########################################################

cd $workingFPath


##### 各種関数の設定。ここから。 #####

function press_enter_key{
    Write-Host ""
    Read-Host "> press enter key to continue ... "
    Write-Host ""
    Write-Host ""
}

##### 各種関数の設定。ここまで。 #####



##### vttのタイプを選択する。ここから。 #####

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

switch ($vtt_type){
    1 {Write-Host "# 選択したvttタイプは、 【1 : Streamタイプ】 です。"}
    2 {Write-Host "# 選択したvttタイプは、 【2 : YouTubeタイプ】 です。"}
    3 {Write-Host "# 選択したvttタイプは、 【3 : LecRecタイプ】 です。"}
}
Write-Host ""
press_enter_key
Clear-Host
##### vttのタイプを選択する。ここまで。 #####



Write-Host "# ファイル名が「for_check_」から始まり「txt」で終わるファイルを解析し、"
Write-Host "  vttのタイプに応じて、次の中から必要なチェック用出力ファイルを作成します。"
Write-Host ""
Write-Host "    check1_NOTE.log            ：「NOTE」からはじまる行をチェック。"
Write-Host "    check2_slideNO.log         ：スライド番号が記入されている行をチェック。"
Write-Host "    check3_content.log         ：字幕の発言部分のみ取り出す。"
Write-Host "    check4_Words.log           ：キーワードをチェック。"
Write-Host "    check5_times.log           ：時刻表示の構造が保たれているかチェック。"
Write-Host "    check6_content_sep_time.log：時刻行のあと1行または2行の空行が入っている行を抽出。"
Write-Host "    check7_SerrialLine.log     ：時刻行の前のシリアル行の前後行を抽出。"
Write-Host ""
press_enter_key
Clear-Host



#####check1_NOTE.logの作成：「NOTE」からはじまる行をチェックする。#####
if (($vtt_type -eq 1) -or ($vtt_type -eq 3)){
    # Select-String -Path ./for_check_*txt -Encoding UTF8 -Pattern "^NOTE" -Context 1, 1 > check1_NOTE.log
    $result_text = Select-String -Path ./for_check_*txt -Encoding UTF8 -Pattern "^NOTE" -Context 1, 1
    $result_text > check1_NOTE.log

    $result_text = Get-Content -Path "./check1_NOTE.log" | Select-String -Pattern ":NOTE " -NotMatch | Select-String -Pattern ":$" -NotMatch

    "`r`n`r`n`r`n====================`r`n`r`n`r`n" >> check1_NOTE.log
    $result_text >> check1_NOTE.log

    # -Pattern は，Select-Stringで，正規表現を使うためのオプション。
    # -Context 1, 1 は，検索する文字列のある行の前後1行も含めて表示する。
    Write-Host ""
    Write-Host "=========="
    Write-Host "# check1_NOTE.log を出力しました。"
    Write-Host "  「NOTE」からはじまる行をチェックしました。"
    Write-Host ""
    Write-Host "# この出力ファイルの確認が必要なのは、次のタイプの場合です。"
    Write-Host "  【1 : Streamタイプ】"
    Write-Host "  【3 : LecRecタイプ】"
    Write-Host ""
    press_enter_key
    Clear-Host
}
#####check1_NOTE.logの作成、ここまで。#####


#####check2_slideNO.logの作成：スライド番号が記入されている行（「, 」(コンマ　＋　半角スペース)を含む行）をチェックする。#####
if ($vtt_type -eq 1){
    Select-String -Path ./for_check_*txt -Encoding UTF8 -Pattern ", " > check2_slideNO.log
    # これは前後1行まで出力する必要なし。
    Write-Host ""
    Write-Host "=========="
    Write-Host "# check2_slideNO.log を出力しました。"
    Write-Host "  スライド番号が記入されている行（「, 」(コンマ　＋　半角スペース)を含む行）をチェックしました。"
    Write-Host ""
    Write-Host "# この出力ファイルの確認が必要なのは、次のタイプの場合です。"
    Write-Host "  【1 : Streamタイプ】"
    Write-Host ""
    Write-Host "# このチェック項目は、特定の授業（2020年度 情報理工学部 秋山先生の授業）において設定したものです。"
    Write-Host "  通常は、 check2_slideNO.log は確認不要です。"
    press_enter_key
    Clear-Host
}
#####check2_slideNO.logの作成、ここまで。#####



######check3_content.logの作成：字幕の発言部分のみ取り出す。######
Select-String -Path ./for_check_*txt -Encoding UTF8 -Pattern "^NOTE" -NotMatch | ` 
    Select-String -Encoding UTF8 -Pattern ".*-.*-.*-.*-" -NotMatch | `
    Select-String -Encoding UTF8 -Pattern "^\d\d:" -NotMatch > check3_content.log
Write-Host ""
Write-Host "=========="
Write-Host "# check3_content.log を出力しました。"
Write-Host "  字幕の発言部分のみ取り出しました。"
Write-Host ""
Write-Host "# この出力ファイルの確認が必要なのは、次のタイプの場合です。"
Write-Host "  【1 : Streamタイプ】"
Write-Host "  【2 : YouTubeタイプ】"
Write-Host "  【3 : LecRecタイプ】"
Write-Host ""
press_enter_key
Clear-Host
######check3_content.logの作成、ここまで。######



#####check4_Words.logの作成：キーワードをチェックする。#####
#任意で設定したキーワードを含む行を抽出する。

#「$checkWord」にキーワードを入力する。
$checkWord = @("、", "，", "。", "^　", "　$", "聞き取れない", "聞こえない", "ラムダ", "Moodle", "moodle", "自乗", "二乗", "２乗", "2乗", "パイソン")

$j = $checkWord.Length
# $checkWordの長さを$jに格納して，for ループで使用する。

Start-Transcript check4_Words.log

for ($i=0; $i -lt $j; $i++){
    Write-Host "#####"
    $checkWord[$i]
    Write-Host ""
    Select-String -Path ./for_check_*txt -Encoding UTF8 -Pattern $checkWord[$i] -CaseSensitive
    Write-Host ""
    Write-Host ""
}

Stop-Transcript

Clear-Host
Write-Host ""
Write-Host "=========="
Write-Host "# check4_Words.log を出力しました。"
Write-Host "  任意で設定したキーワードを含む行を抽出しました。"
Write-Host ""
Write-Host "# この出力ファイルの確認が必要なのは、次のタイプの場合です。"
Write-Host "  【1 : Streamタイプ】"
Write-Host "  【2 : YouTubeタイプ】"
Write-Host "  【3 : LecRecタイプ】"
Write-Host ""
press_enter_key
Clear-Host
##### check4_Words.logの作成、ここまで。 #####



##### check5_times.log の作成：時刻表示の構造が保たれているかチェックする。 #####
#時刻表示の構造が保たれていない行を抽出する。
Select-String -Path ./for_check_*txt -Encoding UTF8 -Pattern "-->" | `
Select-String -Pattern "^\d\d:\d\d:\d\d\.\d\d\d --> \d\d:\d\d:\d\d\.\d\d\d$" -NotMatch > check5_times.log

Write-Host ""
Write-Host "=========="
Write-Host "# check5_times.log を出力しました。"
Write-Host "  時刻表示の構造が保たれていない行を抽出しました。"
Write-Host ""
Write-Host "# この出力ファイルの確認が必要なのは、次のタイプの場合です。"
Write-Host "  【1 : Streamタイプ】"
Write-Host "  【2 : YouTubeタイプ】"
Write-Host "  【3 : LecRecタイプ】"
Write-Host ""
press_enter_key
Clear-Host
##### check5_times.logの作成、ここまで。 #####



##### check6_content_sep_time.log の作成：時刻行のあとに1行または2行の空行が入っている行を抽出する(2020.6.13追加) #####
$Line = Get-Content -Path ./for_check_*.txt -Encoding UTF8
$allLineNum = $Line.Length

$j = 1

Start-Transcript check6_content_sep_time.log

for ($i=0; $i -lt $allLineNum; $i++){
    if($Line[$i] -match "-->" -and $Line[$i+1] -eq "" -and $Line[$i+2] -match "." -and $Line[$i+2] -notmatch "^NOTE"){
        Write-Host "##### No." $j " ##### There is 1 empty line "
        Write-Host $Line[$i]
        Write-Host $Line[$i+1]
        Write-Host $Line[$i+2]
        Write-Host ""
        Write-Host ""
        $j++
    }
} 

for ($i=0; $i -lt $allLineNum; $i++){
    if($Line[$i] -match "-->" -and $Line[$i+1] -eq "" -and $Line[$i+2] -eq "" -and $Line[$i+3] -match "." -and $Line[$i+3] -notmatch "^NOTE"){
        Write-Host "##### No." $j " ########## There are 2 empty lines "
        Write-Host $Line[$i]
        Write-Host $Line[$i+1]
        Write-Host $Line[$i+2]
        Write-Host $Line[$i+3]
        Write-Host ""
        Write-Host ""
        $j++
    }
} 


Stop-Transcript

Write-Host ""
Write-Host "=========="
Write-Host "# check6_content_sep_time.log を出力しました。"
Write-Host "  時刻行のあとに1行または2行の空行が入っている行を抽出しました。"
Write-Host ""
Write-Host "# この出力ファイルの確認が必要なのは、次のタイプの場合です。"
Write-Host "  【1 : Streamタイプ】"
Write-Host "  【2 : YouTubeタイプ】"
Write-Host "  【3 : LecRecタイプ】"
Write-Host ""
press_enter_key
Clear-Host
##### check6_content_sep_time.logの作成、ここまで。 #####


##### check7_SerrialLine.logの作成：時刻行の前のシリアル行の前後行を抽出する(2020.6.23作成) #####
if ($vtt_type -eq 1){
    ($forCheckFile = @(Get-ChildItem -Path "for_check_*.txt"))
    $forCheckFileNum = $forCheckFile.Length


    Write-Host "checkするファイル数は　" $forCheckFileNum
    Write-Host ""


    Start-Transcript check7_SerrialLine.log


    for ($k=0; $k -lt $forCheckFileNum; $k++){

        $Line = Get-Content $forCheckFile[$k] -Encoding UTF8
        $allLineNum = $Line.Length

        $j = 1

        for ($i=0; $i -lt $allLineNum; $i++){
            if($Line[$i] -match ".*-.*-.*-.*-" -and $Line[$i+1] -notmatch "-->"){
                #Write-Host "##### No." $j " :" 
                Write-Host $forCheckFile[$k].Name " - No." $j
                Write-Host $($i+1) " 行目" 
                Write-Host $Line[$i]
                Write-Host $Line[$i+1]
                Write-Host ""
                Write-Host ""
                $j++
            }
        } 

    }

    Stop-Transcript

    Write-Host ""
    Write-Host "=========="
    Write-Host "# check7_SerrialLine.log を出力しました。"
    Write-Host "  時刻行の前のシリアル行の前後行を抽出しました。"
    Write-Host ""
    Write-Host "# この出力ファイルの確認が必要なのは、次のタイプの場合です。"
    Write-Host "  【1 : Streamタイプ】"
    Write-Host ""
    press_enter_key
    Clear-Host
}
##### check7_SerrialLine.log の作成、ここまで。 #####


Write-Host ""
Write-Host ""
Write-Host "    check1_NOTE.log"
Write-Host "    check2_slideNO.log"
Write-Host "    check3_content.log"
Write-Host "    check4_Words.log"
Write-Host "    check5_times.log"
Write-Host "    check6_content_sep_time.log"
Write-Host "    check7_SerrialLine.log"
Write-Host ""
Write-Host "  を作成/更新しました。プログラムを終了します。出力されたlogファイルを確認してください。"
Write-Host ""
Write-Host ""
press_enter_key
