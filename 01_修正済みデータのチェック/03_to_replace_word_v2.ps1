#プログラムの更新日：2020.5.30
#プログラムの更新日：2021.4.29
#####はじめに，ワーキングディレクトリ（作業するフォルダ）を設定しておく。#####
$workingFPath = Set-Location
###########################################################

cd $workingFPath


Write-Host "「for_check_」から始まり「txt」で終わるファイルを解析し、"
Write-Host "指定の文字列を別の文字列に置き換えます。"
Write-Host ""
Read-host "press Enter key to continue"


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


# 解析対象のファイルの数を標準出力に表示する。確認のため。

Write-Host ""
$for_check_file = @()
$for_check_file += Get-ChildItem for_check_*.txt
Write-Host "対象ファイル数は、"
$fileNum = $for_check_file.Length
Write-Host "    " $fileNum
Write-Host "です。"
Write-Host ""
Read-host "press Enter key to continue"


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
Write-Host $j "種類の文字列を検索/置換しました"
Write-Host "もう一度「02_to_check_jimaku.ps1」を実行して"
Write-Host "結果を確認してください"
Write-Host ""
Write-Host ""
Read-host "press Enter key to end"
