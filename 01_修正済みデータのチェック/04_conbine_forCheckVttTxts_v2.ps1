# �������ăT�|�[�^�[�ɏC�����Ă�������ufor_check_xxxxx.vtt.txt�v�t�@�C����1�̃t�@�C���Ɍ�������v���O����
# �쐬�J�n : 2021.4.29
# �쐬�I�� : 2021.4.29
# �v���O�����̍X�V : ���X�V


#####�͂��߂ɁC���[�L���O�f�B���N�g���i��Ƃ���t�H���_�j��ݒ肵�Ă����B#####
$workingFPath = Set-Location
###########################################################

cd $myFilePath


Write-Host "2�ȏ�́ufor_check_xxxxx.vtt.txt�v�t�@�C����"
Write-Host "1�̃t�@�C���Ɍ������܂��B"
Write-Host ""
Read-host "press Enter key to continue"



$ErrorActionPreference = "Stop" #�G���[�������������ɂ́C�����𒆎~����ݒ�Ƃ���B

##### �ufor_check_�v����n�܂�A�u.vtt.txt�v�ŏI���t�@�C�����̃t�@�C����T���āA $targetFiles �Ɋi�[����B

$targetFiles = Get-ChildItem "for_check_*.vtt.txt" | Sort-Object { $_.Name }

Write-Host "�����Ώۂ̃t�@�C���͎��̒ʂ�ł��B"
Write-Host ""
$i = 1
foreach ($targetFile in $targetFiles)
{
    Write-Host "  $($i)�Ԗڂ̃t�@�C�� : " $targetFile.Name
    $i += 1
}
Write-Host ""


Write-Host ""
Write-Host "�����̃t�@�C�����������܂����H"
Write-Host "press 'y' for Yes"
Write-Host "press other keys for No"
Write-Host ""
$discrim = Read-Host "press �uy�v + Enter key to continue..."
# Write-Host $discrim

if ($discrim -eq "y") {
    # Write-Host "�����𑱂��܂��B"
}
else {
    Write-Host "�y�x���z�����𒆎~���܂��B"
    Read-host "press Enter key to end"
    exit
}
Write-Host ""
Write-Host ""



##### targetFiles ���ꂼ��̐擪����і���5�s��\������B

$i = 1
foreach ($targetFile in $targetFiles)
{
    Clear-Host
    Write-Host "�y$($i)�Ԗڂ̃t�@�C���z" $targetFile.Name
    Read-host "press Enter key to continue"
    Write-Host "(�擪5�s)"
    Get-Content $targetFile -Encoding UTF8 -TotalCount 5
    Read-host "---------- press Enter key to continue ----------"
    Write-Host "(����5�s)"
    Get-Content $targetFile -Encoding UTF8 -Last 5
    Read-host "++++++++++ press Enter key to continue ++++++++++"
    $i += 1
}
Write-Host ""



##### $targetFiles �̍ŏ��́i�擪�́j�t�@�C�����R�s�[���A�����f�[�^�̃x�[�X�ƂȂ�t�@�C�����쐻����B #####

Copy-Item $targetFiles[0].Name -Destination "conbined.vtt.txt"

# Write-Output "" | Add-Content conbined.vtt.txt -Encoding UTF8
# Write-Output "" | Add-Content conbined.vtt.txt -Encoding UTF8


##### $targetFiles[0]�������āA$targetFiles[1]�A$targetFiles[2]�@...�@�� add-content ���Ă����B #####

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



Write-Host "�t�@�C�����������A�uconbined.vtt.txt�v���쐬���܂����B"
Write-Host "�K�X�A�t�@�C������ύX���Ă��������B"
Write-Host ""
Read-host "press Enter key to end"
