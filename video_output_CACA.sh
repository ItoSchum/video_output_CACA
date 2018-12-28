#!/usr/bin/bash
# -*- coding: UTF-8 -*- 

# Video Export
	# Ref: http://stariocek.asuscomm.com/watch-ascii-libcaca.html


# 0. Preset Input
read -p "Enter the path of the input video: " RAW_INPUT
read -p "Enter the resolution of the original video (e.g. 1920x1080): " video_resolution
read -p "Enter the FPS of the original video: " video_fps
echo "Confirmed Resolution: $video_resolution\nConfirmed FPS: " $FPS

PAD_ADD='Y'
PAD_NOT_ADD='N'

OUTPUT_UNSCALED_ONLY='1'
OUTPUT_SCALED_ONLY='2'
OUTPUT_BOTH='3'
VERBOSE_MODE='4'

read -p "
Please Choose a Output Mode: 

	1 -- Output Unscaled Only
	2 -- Output Scaled Only
	3 -- Both 1 and 2, 
	4 -- Verbose Mode

Mode Choice: " output_mode

if [ $output_mode != $OUTPUT_UNSCALED_ONLY ]; then
	
	read -p "Would you like to add a black pad as background? (Y/N) " pad_add_choice_input
	pad_add_choice=$(echo $pad_add_choice_input | tr "[:lower:]" "[:upper:]")
fi

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

if [ $output_mode == $OUTPUT_UNSCALED_ONLY ]; then

	ffmpeg -threads $thread_amount -start_number 1 \
	-i %07d-full.png \
	-i "$RAW_INPUT" \
	-movflags +faststart \
	-c:v libx264 -pix_fmt yuv420p -crf 20 -r $video_fps \
	-preset slower -profile:v high -level 5.0 \
	-vf "crop=2458:1296:16:16" \
	-map 0:v:0 -map 1:a:0 output_yuv420.mp4


elif [ $output_mode == $OUTPUT_SCALED_ONLY ]; then
	
	ffmpeg -threads $thread_amount -start_number 1 \
	-i %07d-full.png \
	-i "$RAW_INPUT" \
	-movflags +faststart \
	-c:v libx264 -pix_fmt yuv420p -crf 20 -r $video_fps \
	-preset slower -profile:v high -level 5.0 \
	-vf "crop=2458:1296:16:16, scale=1920:1080:force_original_aspect_ratio=decrease" \
	-map 0:v:0 -map 1:a:0 output_yuv420.mp4

	# Frame Size Modify (Including Scale and Pad)
	INPUT=output_yuv420.mp4
	OUTPUT=output_1080p.mp4

	if [ $pad_add_choice == $PAD_NOT_ADD ]; then
		ffmpeg -threads $thread_amount -i $INPUT -c:a copy \
		-vf "scale=1920:1080:force_original_aspect_ratio=decrease" \
		$OUTPUT

	elif [ $pad_add_choice == $PAD_ADD ]; then
		ffmpeg -threads $thread_amount \
		-i $INPUT -c:a copy \
		-vf "scale=1920:1080:force_original_aspect_ratio=decrease, pad=1920:1080:0:(1080-in_h)/2:black" \
		$OUTPUT
	fi	


elif [ $output_mode == $OUTPUT_BOTH ]; then

	ffmpeg -threads $thread_amount -start_number 1 \
	-i %07d-full.png \
	-i "$RAW_INPUT" \
	-movflags +faststart \
	-c:v libx264 -pix_fmt yuv420p -crf 20 -r $video_fps \
	-preset slower -profile:v high -level 5.0 \
	-vf "crop=2458:1296:16:16" \
	-map 0:v:0 -map 1:a:0 output_yuv420.mp4


	# Frame Size Modify (Including Scale and Pad)
	INPUT=output_yuv420.mp4
	OUTPUT=output_1080p.mp4


	if [ $pad_add_choice == $PAD_NOT_ADD ]; then
		ffmpeg -threads $thread_amount -i $INPUT -c:a copy \
		-vf "scale=1920:1080:force_original_aspect_ratio=decrease" \
		$OUTPUT

	elif [ $pad_add_choice == $PAD_ADD ]; then
		ffmpeg -threads $thread_amount \
		-i $INPUT -c:a copy \
		-vf "scale=1920:1080:force_original_aspect_ratio=decrease, pad=1920:1080:0:(1080-in_h)/2:black" \
		$OUTPUT
	fi	
fi



if [ $output_mode != $VERBOSE_MODE ]; then
	rm *.jpg
	rm *.html
	rm *.png
fi


# Ref
	# 4:3 --> 16:9
	# -vf cropdetect, pad=ih*16/9:ih:(ow-iw)/2:0:black, scale=1920:1080

