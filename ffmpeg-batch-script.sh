#!/bin/bash
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg is not found in the PATH. Please ensure ffmpeg is installed and added to the PATH."
    exit 1
fi

echo -ne "\033]0;Ffmpeg Batch Converter\007"
clear

read -p "Enter the path to the input files: " input
read -p "Enter the path to output files: " output
clear
read -p "Enter the videos width after conversion: " width
read -p "Enter the videos height after conversion: " height
clear
echo "Common codec names: libx264, h264_nvenc, libx265, hevc_nvenc, vp9, lbsvtav1"
read -p "Enter the video codec name (visit https://ffmpeg.org/ffmpeg-codecs.html for codec info or run ffmpeg -codecs): " codec
read -p "Enter the framerate after conversion: " fps
read -p "Enter the video container after conversion (example... mp4, mkv, webm): " container
read -p "Enter the quality from 0 to 51 (0 - Lossless, 51 - Worst quality): " quality

filelist=()
while IFS= read -r -d '' file; do
    filelist+=("$file")
done < <(find "$input" -maxdepth 1 -type f ! -name ".*" -print0)
filecount=${#filelist[@]}

i=0

for file in "${filelist[@]}"; do
  ((i++))
  oldfile="$file"
  newfile="$output/$(basename "${file%.*}").$container"

  progress=$(echo "scale=2; ($i / $filecount) * 100" | bc)

  clear
  echo "-------------------------------------------------------------------------------"
  echo "Ffmpeg Batch Converter"
  echo "by LukaCafuka - z.com.hr"
  echo "Video Settings: Resolution - $width x $height, Codec - $codec, FPS - $fps, Container - $container, CRF - $quality"
  echo "Processing - $oldfile"
  echo "File $i of $filecount - $progress%"
  echo "-------------------------------------------------------------------------------"

  ffmpegcommand="ffmpeg -i \"$oldfile\" -r \"$fps\" -vcodec \"$codec\" -movflags faststart -crf \"$quality\" -map 0 -c:a copy -vf scale=\"$width:$height\" \"$newfile\" -hide_banner -loglevel warning"
    
  eval $ffmpegcommand

done
