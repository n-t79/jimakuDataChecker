# �쐬�J�n 2020.11.14
# �쐬�I�� 2020.11.15
# �v���O�����̍X�V���F2021.4.29
# vtt�t�@�C���𕪊�����v���O����
# �X�V 2021.07.01 : �Ō�ɍ쐬�����split_xxx.txt�̃t�@�C�����̂����u���v��\�������ɂ��āA�Ⴆ�΁u1���v�Ȃǂ̈ꌅ�̏ꍇ�́u1m�v�ł͂Ȃ��u01m�v��2���\�L����悤�ɏC�������B
# �X�V 2021.09.20 : YouTube �܂��� LecRec ����_�E�����[�h����vtt�t�@�C���ɂ��Ή�����悤�ɁA����S�̂̎��Ԃ̑�������ύX�����B�o�[�W�����A�b�v���Av3�Ƃ����B

##### ��ƃf�B���N�g���̐ݒ�B�^�[�~�i�����J���Ă���ꏊ���A��ƃf�B���N�g���Ƃ���B
$myFilePath = Get-Location
###############################################################

Set-Location $myFilePath

$ErrorActionPreference = "Stop" #�G���[�������������ɂ́C�����𒆎~����ݒ�Ƃ���B


##### �e��֐��̐ݒ�B��������B #####
function press_enter_key{
    Write-Host ""
    Write-Host ""
    Read-Host "> press enter key to continue ... "
    Write-Host ""
    Write-Host ""
}

##### �e��֐��̐ݒ�B�����܂ŁB #####


##### vtt�t�@�C����1�i�[����Ă���ꍇ�́C�����𑱂���B����ȊO�̏ꍇ�́C�����𒆎~����B��������B ##########
if ((@(Get-ChildItem *.vtt)).Length -eq 1)
{
    Write-Host "# vtt�t�@�C���𕪊�����v���O���������s���܂��B"
    press_enter_key
}
else
{
    Write-Host "�y�x���zvtt�t�@�C��������܂���B�܂��́C2�ȏ��vtt�t�@�C����������܂����B"
    Write-Host "�y�x���z�����𒆎~���܂��B"
    Read-host "press Enter key to end"
    exit
}
##### vtt�t�@�C����1�i�[����Ă���ꍇ�́C�����𑱂���B����ȊO�̏ꍇ�́C�����𒆎~����B�����܂ŁB ##########



##### �m�F�̂��߁A�ΏۂƂ���vtt�t�@�C���̓��e�̂����A�擪����і����̂T�s����\������B��������B #####
Clear-Host
Write-Host "##### �t�@�C���擪����5�s��\�� ##########"
Get-Content *.vtt -Encoding UTF8 -TotalCount 5
Write-Host ""
Write-Host ""
press_enter_key

Write-Host "##### �t�@�C����������5�s��\�� ##########"
Get-Content *.vtt -Encoding UTF8 -Last 5
Write-Host ""
Write-Host ""
press_enter_key
Clear-Host
##### �m�F�̂��߁A�ΏۂƂ���vtt�t�@�C���̓��e�̂����A�擪����і����̂T�s����\������B��������B #####

##### vtt�̓��e�ƁA���̂����̎����s�̕������i�[�B��������B #####
$myVtt = Get-Content *.vtt -Encoding UTF8
$myVttTimes = $myVtt | Select-String -Pattern " --> "
##### vtt�̓��e�ƁA���̂����̎����s�̕������i�[�B�����܂ŁB #####


##### �����s�̃f�[�^�̂����ő�̂��́i�����s�̍ŏI�s�̉E���j�����o���Ď����̒����Ƃ��Đݒ肷��B��������B #####
$myDuration = $myVttTimes[-1].ToString()
# $myDuration = ($myVtt | Select-String -Pattern "^NOTE duration").ToString()

$timeStartNum = $myDuration.IndexOf('>') + 2
# $timeStartNum = $myDuration.IndexOf('"') + 1

Write-Host ""
Write-Host "##### ����i�����j�̒��� ##########"
$myDuration = $myDuration.Substring($timeStartNum,8)
# $myDuration = $myDuration.Substring($timeStartNum,8)
$myDuration
Write-Host ""
##### �����s�̃f�[�^�̂����ő�̂��́i�����s�̍ŏI�s�̉E���j�����o���Ď����̒����Ƃ��Đݒ肷��B�����܂ŁB #####


##### $myDuration�̕������hms�\�L�Ή��ɂ���B��������B #####
$myDuration_h = [Byte]$myDuration.Substring(0,2)
$myDuration_m = [Byte]$myDuration.Substring(3,2)
$myDuration_hm_string = $myDuration_h.ToString() + "h" + ("00" + $myDuration_m.ToString()).Substring(("00" + $myDuration_m.ToString()).Length -2, 2) + "m"
press_enter_key
##### $myDuration�̕������hms�\�L�Ή��ɂ���B�����܂ŁB #####



Write-Host ""
Write-Host "##### vtt�t�@�C���̕���������͂��Ă������� ##########"
[ValidateRange(2,10)]$splitNum = [Byte](Read-Host vtt�t�@�C���̕���������́i���p�����@�u2�v�`�u10�v�j)
Write-Host "�������� $($splitNum)"




$splitTimeArr = New-Object 'Byte[,]' ($splitNum-1), 3 #�񎟌��z��̕ϐ����쐬�B�s���́u$splitNum-1�v�C�񐔂́u3�v�B

Write-Host ""
Write-Host "##### �t�@�C���𕪊����鎞��(����)����͂��Ă������� ##########"
for ($i=0; $i -lt $splitNum - 1 ; $i++){
    Write-Host "$($i+1) �߂̕����_�����: "
    $splitTimeArr[$i, 0] = [Byte](Read-Host ���Ԃ����)
    $splitTimeArr[$i, 1] = [Byte](Read-Host ������́i0�`59�j)
    $splitTimeArr[$i, 2] = [Byte](Read-Host �b����́i0�`59�j)
    Write-Host "$($i+1) �߂̕����_: $($splitTimeArr[$i,0])���� $($splitTimeArr[$i,1])�� $($splitTimeArr[$i,2])�b"
    Write-Host ""
}




$fileNameTimeStr = @() #��ŁC�����t�@�C�����쐬�����Ƃ��ɁC�t�@�C�����Ɏ��Ԃ����邽�߂ɔz����쐬�B

Write-Host "##### �t�@�C���̕�������(����)���͌��� ##########"
Write-Host "���@Start"
Write-Host "|"
for ($i=0; $i -lt $splitNum - 1; $i++){
    Write-Host "���@$($i+1) �߂̕����_: $($splitTimeArr[$i,0])���� $($splitTimeArr[$i,1])�� $($splitTimeArr[$i,2])�b"
    Write-Host "|"
    $fileNameTimeStr += ($splitTimeArr[$i,0]).ToString() + "h" + ("00"+($splitTimeArr[$i,1]).ToString()).Substring(("00"+($splitTimeArr[$i,1]).ToString()).Length - 2, 2) + "m"
}
Write-Host "���@End"



#####��œ��͂����C$splitTimeArr �� TimeSpan Object �ɕϊ����Ĕz��Ɋi�[����B ##########

$splitTimes = @()

for ($i=0; $i -lt $splitNum - 1; $i++){
    $splitTimes += New-TimeSpan -Hours $splitTimeArr[$i, 0] -Minutes $splitTimeArr[$i, 1] -Seconds $splitTimeArr[$i, 2]
}





##### $splitTimes�Ɋi�[�������Ԃ̃f�[�^�����������ɕ���ł��邩�`�F�b�N�B����ł��Ȃ���΁C�v���O�����𒆎~����B ##########
for ($i = 0; $i -lt $($splitTimes.Length-1); $i++){
    if ($splitTimes[$i] -lt $splitTimes[$i+1])
    {
    }
    else
    {
        Write-Host ""
        Write-Host "�y�x���z�t�@�C���̕�������(����)�̐ݒ肪�����ł��B"
        Write-Host "�y�x���z�����𒆎~���܂��B"
        exit
    }
}



Write-Host ""
Read-host "press Enter key to continue"
Write-Host ""




##### vtt�ɋL�ڂ���Ă��鎞���\�L�� TimeSpan Object �ɕϊ� #####

$myVttTimesTimeSpan = @()

for ($i=0; $i -lt $myVttTimes.Length ; $i++){

    # $myVttTimes[$i].ToString().Substring(0, 8)

    $myVttTimes_h = [Byte]$myVttTimes[$i].ToString().Substring(0, 2)
    $myVttTimes_m = [Byte]$myVttTimes[$i].ToString().Substring(3, 2)
    $myVttTimes_s = [Byte]$myVttTimes[$i].ToString().Substring(6, 2)

    $myVttTimesTimeSpan += New-TimeSpan -Hours $myVttTimes_h -Minutes $myVttTimes_m -Seconds $myVttTimes_s

}


##### ��������s������肷��B��������B #####
# ��������ہAvtt�f�[�^�� stream / youtube / LecRec �̂����ꂩ��̗R�������肵�A��������s���𒲐�����B

# vtt�̃^�C�v��I������B

Write-Host "# vtt�̃^�C�v��I�����Ă��������B"
Write-Host ""
Write-Host "  1 : Stream�^�C�v"
Write-Host "  2 : YouTube�^�C�v"
Write-Host "  3 : LecRec�^�C�v"
Write-Host ""

$vtt_type = ""
do {
    $vtt_type = [string](Read-Host "> press 1 or 2 or 3")
}
while (-Not($vtt_type -in @("1", "2", "3")))

Write-Host ""

# vtt�̃^�C�v�ɂ�蕪������s�̒�������ς���B
$lines_num_for_adjust = 3 # �W���ł�stream�^�C�v�́u3�v�ɐݒ肵�Ă����B

switch ($vtt_type){
    1 {
        Write-Host "# �I������vtt�^�C�v�́A �y1 : Stream�^�C�v�z �ł��B"
        $lines_num_for_adjust = 3
    }
    2 {
        Write-Host "# �I������vtt�^�C�v�́A �y2 : YouTube�^�C�v�z �ł��B"
        $lines_num_for_adjust = 0
    }
    3 {
        Write-Host "# �I������vtt�^�C�v�́A �y3 : LecRec�^�C�v�z �ł��B"
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
Write-Host "##### ��������s�̈ʒu(�s��) ##########"
$split_lineNum
Write-Host ""
Write-Host ""


Write-Host ""
Read-host "press Enter key to continue"
Write-Host ""
##### ��������s������肷��B�����܂ŁB #####





if ($splitNum -eq 2)
{
    $myVtt[0..($split_lineNum[0]-1)] | Set-Content -Path "split1_0h00m_to_$($fileNameTimeStr[0])_$($myVtt.PSchildName[0]).txt" -Encoding UTF8
    $myVtt[($split_lineNum[0])..($myVtt.Length)] | Set-Content -Path "split$($splitNum)_$($fileNameTimeStr[0])_to_$($myDuration_hm_string)_$($myVtt.PSchildName[0]).txt" -Encoding UTF8
    Write-Host "##### ���� ##########"
    Write-Host "$($splitNum)�ɕ��������t�@�C�����쐬���܂����B"
}
elseif ($splitNum -ge 3)
{

    $myVtt[0..($split_lineNum[0]-1)] | Set-Content -Path "split1_0h00m_to_$($fileNameTimeStr[0])_$($myVtt.PSchildName[0]).txt" -Encoding UTF8
    
    for ($i=0; $i -lt ($splitNum-1-1); $i++){
        $myVtt[($split_lineNum[$i])..($split_lineNum[$i+1]-1)] | Set-Content -Path "split$($i+2)_$($fileNameTimeStr[$i])_to_$($fileNameTimeStr[$i+1])_$($myVtt.PSchildName[0]).txt" -Encoding UTF8
    }

    $myVtt[($split_lineNum[($splitNum-1-1)])..($myVtt.Length)] | Set-Content -Path "split$($splitNum)_$($fileNameTimeStr[-1])_to_$($myDuration_hm_string)_$($myVtt.PSchildName[0]).txt" -Encoding UTF8
    Write-Host "##### ���� ##########"
    Write-Host "$($splitNum)�ɕ��������t�@�C�����쐬���܂����B"
}
else
{
    # <�O�̏��������������������Ȃ��ꍇ�Ɏ��s�����R�[�h�u���b�N>
    Write-Host "��������else�̏ꍇ�́C�H�����ł��B"
}




for ($i = 0; $i -lt (@(Get-ChildItem -Path *.vtt.txt)).Length; $i++){

    Write-Host "$((Get-ChildItem -Path *.vtt.txt)[$i].Name)  �S$((Get-Content (Get-ChildItem -Path *.vtt.txt)[$i]).Length)�s"

}




Write-Host ""
Write-Host ""
Read-host "press Enter key to end"


