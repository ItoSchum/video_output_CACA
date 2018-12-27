# Video Export
	# Ref: http://stariocek.asuscomm.com/watch-ascii-libcaca.html


# 1. video2jpg
echo "Step 1: Video to jpg"

read -p "Enter the FPS of the original video: " video_fps
read -p "Enter the resolution of the original video in style like '1920x1080': " video_resolution
echo "Confirmed FPS: $FPS\nConfirmed Resolution: $video_resolution"

ffmpeg -i $INPUT -r $video_fps -s $video_resolution -f image2 %7d.jpg


# 2. img2txt
echo "Step 2: jpg to txt (html):"

for ascii in *.jpg
	img2txt -W 128 -H 36 -x 3 -y 5 $ascii -f html > $(basename $ascii .jpg).html;
	# "... -W 128" means 128 ASCII columns.
	# "... -H 36" means 36 rows.
	# "... -x 3 -y 5" means font size 3x5.


# 3. html2png
echo "Step 3: html to png"

for LibCaca in *.html
	webkit2png -F -o $(basename $LibCaca .html) $LibCaca;


# 4. FFmpeg PackUp
echo "Step 4: png to video"

read -p "Enter the number of the therad amount: " thread_amount
ffmpeg -threads $thread_amount -r $video_fps -i %07d-full.png png_packed_up.mp4


# YUV444 to YUV420
INPUT=packup_png.mp4
OUTPUT=packup_yuv420.mp4

ffmpeg -i $INPUT -movflags +faststart -pix_fmt yuv420p -c:v libx264 -crf 20 -preset slower -profile:v high -level 5.0 $OUTPUT


# Frame Size Modify (Including Scale and Pad)
INPUT=packup_yuv420.mp4
OUTPUT=packup_1080p.mp4

ffmpeg -i $INPUT -c:a copy -vf "crop=2458:1296:16:16, scale=1920:-1:force_original_aspect_ratio=decrease, pad=1920:1080:0:(1080-in_h)/2:black"  $OUTPUT


# Ref
	# 4:3 --> 16:9
	# -vf cropdetect, pad=ih*16/9:ih:(ow-iw)/2:0:black, scale=1920:1080


# Capture Screenshot
ffmpeg -ss 00:04:03 -i ./EvagelionOP_1080P.mp4 -vframes 1 -f mjpeg sample.jpg


####################
# Screen Recording

# List Devices
ffmpeg -f avfoundation -list_devices true -i ""

# Rec Screen
ffmpeg -y -f avfoundation -i 1:3 -framerate 30 -c:v libx264 -r 60 -pix_fmt uyvy422 -preset 0 -crf 19 -c:a aac -b:a 192k "$Home/Users/ItoShen/Downloads/Screen Record $(date "+%Y-%m-%d %H-%M-%S").mp4"
ffmpeg -y -f avfoundation -i 2:3 -framerate 30 -c:v libx264 -r 60 -pix_fmt yuv420p -preset 0 -crf 19 -c:a aac -b:a 192k "~/Downloads/Screen Record $(date "+%Y-%m-%d %H-%M-%S").mp4" 

# Rec Terminal
#ffmpeg -f x11grab -s wxga -r 25 -i :0.0 -sameq /tmp/out.mpg


#####################
# DISPLAY Setting
#echo $DISPLAY
#DISPLAY=/tmp/com.apple.launchd.cZDh63T4aX/org.macosforge.xquartz:0

#CACA_GEOMETRY=240x68 mpv -vo caca /Users/itoshen/Downloads/【調教すげぇ】初音ミク『FREELY\ TOMORROW』【公式PV】-KmvydnVTriE.mp4



