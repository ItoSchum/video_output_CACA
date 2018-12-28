#!/usr/bin/bash
# -*- coding: UTF-8 -*- 

# Video Export
	# Ref: http://stariocek.asuscomm.com/watch-ascii-libcaca.html

read -p "Enter the path of the input video: " RAW_INPUT
read -p "Enter the resolution of the original and output video (e.g. 1920x1080): " video_resolution
read -p "Enter the FPS of the original video: " video_fps
echo "\nConfirmed Resolution: $video_resolution\nConfirmed FPS: $FPS"

PAD_ADD='Y'
PAD_NOT_ADD='N'

read -p "Would you like to add a black pad as background? (Y/N) " pad_add_choice_input
pad_add_choice=$(echo $pad_add_choice_input | tr "[:lower:]" "[:upper:]")

ORIGINAL_KEEP='Y'
ORIGINAL_NOT_KEEP='N'
VERBOSE_MODE='V'

read -p "Would you like to keep the original yuv420p file? (Y/N) " yuv420p_keep_choice_input
yuv420p_keep_choice=$(echo $yuv420p_keep_choice_input | tr "[:lower:]" "[:upper:]")

read -p "Enter the number of FFmpeg's thread amount: " thread_amount

# 1. video2jpg
echo "Step 1: Video to JPG"

ffmpeg -threads $thread_amount \
-i "$RAW_INPUT" \
-r $video_fps -s $video_resolution -f image2 \
%07d.jpg


# 2. img2txt
echo "Step 2: JPG to TXT (HTML):"

for ascii in *.jpg; do
	img2txt -W 128 -H 36 -x 3 -y 5 $ascii -f html > $(basename $ascii .jpg).html;
	# "... -W 128" means 128 ASCII columns.
	# "... -H 36" means 36 rows.
	# "... -x 3 -y 5" means font size 3x5.
done


# 3. html2png
echo "Step 3: TXT (HTML) to PNG"

for LibCaca in *.html; do
	webkit2png -F -o $(basename $LibCaca .html) $LibCaca;
done


# 4. png2video
echo "Step 4: PNG to Video"

# for i in *-full.png; do
# 	mv $i $(basename $i -full.png).png
# done

ffmpeg -threads $thread_amount -start_number 1 \
-i %07d-full.png \
-i "$RAW_INPUT" \
-movflags +faststart \
-c:v libx264 -pix_fmt yuv420p -crf 20 -r $video_fps \
-preset slower -profile:v high -level 5.0 \
-map 0:v:0 -map 1:a:0 output_yuv420.mp4

# YUV444 to YUV420
# INPUT=png_packup.mp4
# OUTPUT=yuv420_packup.mp4
# ffmpeg -i $INPUT -movflags +faststart -pix_fmt yuv420p -c:v libx264 -crf 20 -preset slower -profile:v high -level 5.0 $OUTPUT


# Frame Size Modify (Including Scale and Pad)
INPUT=output_yuv420.mp4
OUTPUT=output_1080p.mp4


if [ $pad_add_choice == $PAD_NOT_ADD ]; then
	ffmpeg -threads $thread_amount \
	-i $INPUT \
	-c:a copy \
	-vf "crop=2458:1296:16:16, scale=1920:1080:force_original_aspect_ratio=decrease" \
	$OUTPUT

elif [ $pad_add_choice == $PAD_ADD ]; then
	ffmpeg -threads $thread_amount \
	-i $INPUT \
	-c:a copy \
	-vf "crop=2458:1296:16:16, scale=1920:1080:force_original_aspect_ratio=decrease, pad=1920:1080:0:(1080-in_h)/2:black" \
	$OUTPUT
fi	


if [ $yuv420p_keep_choice != $VERBOSE_MODE ]; then
	rm *.jpg
	rm *.html
	rm *.png

	if [ $yuv420p_keep_choice == $ORIGINAL_NOT_KEEP ]; then
		rm ./output_yuv420.mp4
	fi
fi


# Ref
	# 4:3 --> 16:9
	# -vf cropdetect, pad=ih*16/9:ih:(ow-iw)/2:0:black, scale=1920:1080

