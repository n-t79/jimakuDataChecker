# 修正前のvttファイルから読点「、」を全角スペースに置き換えるプログラム。
# vttを分割（split）する前に実行する。
#プログラムの更新日：2020.5.30
#プログラムの更新日：2021.4.29
#プログラムの更新日：2021.5.2
#プログラムの更新日：2021.9.20 バージョンアップしv3とする。LecRecからvttをダウンロードしたときに、発話部分に含まれる半角空白を取り除くコードを追加。

#####はじめに，ワーキングディレクトリ（作業するフォルダ）は、ターミナルが開いている場所とする。
$workingFPath = Get-Location
##########################################################################

cd $workingFPath


##### 各種関数の設定。ここから。 #####
function press_enter_key{
    Write-Host ""
    Write-Host ""
    Read-host "> press Enter key to continue ... "
    Write-Host ""
    Write-Host ""
}
##### 各種関数の設定。ここまで。 #####



##### 解析対象のファイル名とファイル数を標準出力に表示する。確認のため。ここから。 #####
Write-Host ""
$for_check_file = @()
$for_check_file += Get-ChildItem *.vtt

Write-Host "# 対象ファイル名は、次の通りです。"
$file_name = $for_check_file.Name
$file_name
Write-Host ""


Write-Host "# 対象ファイル数は、"
$fileNum = $for_check_file.Length
Write-Host "    " $fileNum
Write-Host "  です。"
press_enter_key
##### 解析対象のファイルの数を標準出力に表示する。確認のため。ここまで。 #####





##### LecRec からダウンロードしたvttファイルの発言部分に含まれる半角空白を取り除く。ここから。 #####
$lines_with_space = $for_check_file | Get-Content -Encoding UTF8
# $lines_with_space

$lines_without_space = @()
foreach ($a_line in $lines_with_space){
    # Write-Host $a_line
    if($a_line -match "^\<v Speaker .\>"){
        $a_line_head = $a_line.Substring(0, $a_line.IndexOf(">")+1)
        $a_line_body = $a_line.Substring($a_line.IndexOf(">")+1)
        # Write-Host $($a_line_head + $a_line_body.Replace(" ", ""))
        $lines_without_space += $($a_line_head + $a_line_body.Replace(" ", ""))
    }
    else{
        # Write-Host $a_line
        $lines_without_space += $a_line
    }
}

# $lines_without_space

$lines_without_space | Set-Content -Path "./$($for_check_file.Name)" -Encoding UTF8

Write-Host ""
Write-Host "# LecRec からダウンロードしたvttファイルの発言部分に含まれる半角空白を取り除きました。"
press_enter_key
##### LecRec からダウンロードしたvttファイルの発言部分に含まれる半角空白を取り除く。ここまで。 #####




##### vttファイル内の指定の文字列を別の指定の文字列に置き換える。ここから。 #####
Write-Host "vttファイル内の指定の文字列を別の指定の文字列に置き換えます。"
press_enter_key

$targetWord = @("、", "，", "^　", "　$", "ラムダ", "Moodle", "自乗", "二乗", "パイソン")
$replacedWord = @("　", "　", "", "", "λ", "moodle", "2乗", "2乗", "Python")
#ターゲットとするキーワードを設定（targetWord）し，
#置き換える単語を設定（replacedWord）する。

$j = $targetWord.Length
# $targetWordの長さを$jに格納。$replacedWordの長さと同じかチェックする。

$k = $replacedWord.Length

If($j -ne $k){
    Write-Host "Warning!"
    Write-Host "「targetWord」と「replacedWord」の配列の長さが異なります。"
    Write-Host "処理を終了します。"
    exit
}


# 指定した文字列を標準出力に表示する。確認のため。

Write-Host ""
Write-Host "指定の文字列は次の通りです。"
Write-Host ""
for ($i=0; $i -lt $targetWord.Length; $i++){
    Write-Host "target" $($i+1) ":  " $targetWord[$i] "  -->  " $replacedWord[$i]
}
Write-Host ""


for ($i=0; $i -lt $fileNum; $i++){
    Write-Host "analyzing..." $for_check_file[$i].Name
    for ($m=0; $m -lt $j; $m++){
        $replacedContent = Get-Content $for_check_file[$i] -Encoding UTF8 | foreach{$_ -creplace $targetWord[$m], $replacedWord[$m]}
        Write-Host "    replacing..." $targetWord[$m] "...to..." $replacedWord[$m]
        #Set-Content $for_check_file[$i] -Encoding UTF8 -Value $replacedContent
        $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
        [System.IO.File]::WriteAllLines($for_check_file[$i], $replacedContent, $Utf8NoBomEncoding)
    }
}

Write-Host ""
Write-Host ""
Write-Host "# $($j)種類の文字列を検索/置換しました。"
Write-Host ""
##### vttファイル内の指定の文字列を別の指定の文字列に置き換える。ここまで。 #####

Write-Host ""
Write-Host "# プログラムを終了します。"
Write-Host ""
Write-Host ""
press_enter_key