#!/bin/bash
if ! command -v HandBrakeCLI &> /dev/null; then
    echo "HandBrakeCLI is not found in the PATH. Please ensure handbrake is installed and added to the PATH."
    exit 1
fi

echo -ne "\033]0;Handbrake Batch Converter\007"
clear

read -p "Enter the path to the input files: " input
read -p "Enter the path to output files: " output
clear
read -p "Enter the videos width after conversion: " width
read -p "Enter the videos height after conversion: " height
clear
echo "Common codec names: svt_av1, x264, nvenc_h264, x265, nvenc_h265, VP8, VP9"
read -p "Enter the video codec name (see encoder options at https://handbrake.fr/docs/en/latest/cli/command-line-reference.html): " codec
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
  echo "Handbrake Batch Converter"
  echo "by LukaCafuka - z.com.hr"
  echo "Video Settings: Resolution - $width x $height, Codec - $codec, FPS - $fps, Container - $container, CRF - $quality"
  echo "Processing - $oldfile"
  echo "File $i of $filecount - $progress%"
  echo "-------------------------------------------------------------------------------"

  handbrakecommand="HandBrakeCLI -i \"$oldfile\" -r \"$fps\" -f \"$container\" -e \"$codec\" -O -q \"$quality\" -a 1,2 -E aac -6 stereo -R 44.1 -B 96k-x -w \"$width\" -l \"$height\" -o \"$newfile\" "
    
  eval $handbrakecommand

done
