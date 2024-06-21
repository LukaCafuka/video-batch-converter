if (-not (Get-Command "HandBrakeCLI.exe" -ErrorAction SilentlyContinue)) {
    Write-Host "HandBrakeCLI.exe is not found in the PATH. Please ensure that HandBrake is installed and added to the PATH."
    exit
}

$host.ui.RawUI.WindowTitle = "HandBrake Batch Converter"
Clear-Host

$path = Read-Host "Enter the path to the input files"
$filelist = Get-ChildItem $path

$output = Read-Host "Enter the path to output files"
Clear-Host
$width = Read-Host "Enter the videos width after conversion"
$height = Read-Host "Enter the videos height after conversion"
Clear-Host
Write-Host "Common codec names: svt_av1, x264, nvenc_h264, x265, nvenc_h265, VP8, VP9"
$codec = Read-Host "Enter the video codec name (see encoder options at https://handbrake.fr/docs/en/latest/cli/command-line-reference.html)"

$fps = Read-Host "Enter the framerate after conversion"

$container = Read-Host "Enter the video container after conversion: (example... mp4, mkv, webm)"

$quality = Read-Host "Enter the quality from 0 to 51 (0 - Lossless, 51 - Worst quality)"

$num = $filelist | measure
$filecount = $num.count
 
$i = 0;
ForEach ($file in $filelist)
{
    $i++;
    $oldfile = $file.DirectoryName + "\" + $file.BaseName + $file.Extension;
    $newfile = $output + "\" + $file.BaseName + "." + $container;
      
    $progress = ($i / $filecount) * 100
    $progress = [Math]::Round($progress,2)
 
    Clear-Host
    Write-Host -------------------------------------------------------------------------------
    Write-Host HandBrake Batch Converter
    Write-Host by LukaCafuka - z.com.hr
    Write-Host "Video Settings: Resolution - $width x $height, Codec - $codec, FPS - $fps, Container - $container, CRF - $quality"
    Write-Host "Processing - $oldfile" 
    Write-Host "File $i of $filecount - $progress%"
    Write-Host -------------------------------------------------------------------------------

    Start-Process "HandBrakeCLI.exe" -ArgumentList "-i `"$oldfile`" -o `"$newfile`" -f `"$container`" -O -r `"$fps`" -e `"$codec`" -q `"$quality`" -a 1,2 -E aac -6 stereo -R 44.1 -B 96k-x -w `"$width`" -l `"$height`" " -Wait -NoNewWindow
}