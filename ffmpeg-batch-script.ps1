if (-not (Get-Command "ffmpeg.exe" -ErrorAction SilentlyContinue)) {
    Write-Host "ffmpeg.exe is not found in the PATH. Please ensure ffmpeg is installed and added to the PATH."
    exit
}

$host.ui.RawUI.WindowTitle = "Ffmpeg Batch Converter"
Clear-Host

$path = Read-Host "Enter the path to the input files"
$filelist = Get-ChildItem $path

$output = Read-Host "Enter the path to output files"
Clear-Host
$width = Read-Host "Enter the videos width after conversion"
$height = Read-Host "Enter the videos height after conversion"
Clear-Host
Write-Host "Common codec names: libx264, h264_nvenc, libx265, hevc_nvenc, vp9, lbsvtav1"
$codec = Read-Host "Enter the video codec name (visit https://ffmpeg.org/ffmpeg-codecs.html for codec info or run ffmpeg -codecs)"

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
    Write-Host Ffmpeg Batch Converter
    Write-Host by LukaCafuka - z.com.hr
    Write-Host "Video Settings: Resolution - $width x $height, Codec - $codec, FPS - $fps, Container - $container, CRF - $quality"
    Write-Host "Processing - $oldfile" 
    Write-Host "File $i of $filecount - $progress%"
    Write-Host -------------------------------------------------------------------------------

    $ffmpegcommand = "ffmpeg.exe -i `"$oldfile`" -r `"$fps`" -vcodec `"$codec`" -movflags faststart -crf `"$quality`" -map 0 -c:a copy -vf scale=`" `"$width`":`"$height`" `" `"$newfile`" -hide_banner -loglevel warning "

    & cmd /c $ffmpegcommand

}