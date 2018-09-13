# Video Export
	# Ref: http://stariocek.asuscomm.com/watch-ascii-libcaca.html


# 1. video2jpg
echo "Step 1: Video to jpg"

read -p "Enter the FPS of the original video: " video_fps
read -p "Enter the resolution of the original video in style like '1920x1080': " video_resolution
echo "Confirmed FPS: $FPS\nConfirmed Resolution: $video_resolution"

ffmpeg -i $video_fps -r 30 -s $video_resolution -f image2 %7d.jpg


# 2. img2txt
echo "Step 2: jpg to txt (html):"

for ascii in $(ls *.jpg ) do ...
	img2txt -W 128 -H 36 -x 3 -y 5 $(basename $ascii .jpg) -f html > _$ascii.html;
	# "... -W 128" means 128 ASCII columns.
	# "... -H 36" means 36 rows.
	# "... -x 3 -y 5" means font size 3x5.


# 3. html2png
echo "Step 3: html to png"

for LibCaca in $(ls *.html) do ...
	webkit2png -o $(basename $LibCaca .jpg.html) $LibCaca;


# 4. FFmpeg PackUp
echo "Step 4: png to video"

read -p "Enter the number of the therad amount: " thread_amount
ffmpeg -threads thread_amount -r $video_fps -i %07d.jpg png_packed_up.mp4


# YUV444 to YUV420
ffmpeg -i $INPUT -c:v libx264 -profile:v high -crf 20 -pix_fmt yuv420p $OUTPUT

# Frame Size Modify
ffmpeg -i $INPUT -c:a copy -vf crop=1920:1080:0:0 $OUTPUT

# Scale and Pad
ffmpeg -i $INPUT -c:a copy -vf "scale=1920:-1:force_original_aspect_ratio=decrease, pad=1920:1080:0:(1080-in_h)/2:black" -movflags +faststart $OUTPUT

	# Ref: 4:3 --> 16:9
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
ffmpeg -f x11grab -s wxga -r 25 -i :0.0 -sameq /tmp/out.mpg


#####################
# DISPLAY Setting
echo $DISPLAY
DISPLAY=/tmp/com.apple.launchd.cZDh63T4aX/org.macosforge.xquartz:0

CACA_GEOMETRY=240x68 mpv -vo caca /Users/itoshen/Downloads/【調教すげぇ】初音ミク『FREELY\ TOMORROW』【公式PV】-KmvydnVTriE.mp4


#####################
# Other Ref
# → ./waf install
# Waf: Entering directory `/Users/itoshen/Downloads/mpv/build'
# [1/1] Compiling version.sh
# + install /usr/local/bin/mpv (from build/mpv)
# + install /usr/local/share/doc/mpv/input.conf (from etc/input.conf)
# + install /usr/local/share/doc/mpv/mplayer-input.conf (from etc/mplayer-input.conf)
# + install /usr/local/share/doc/mpv/mpv.conf (from etc/mpv.conf)
# + install /usr/local/share/doc/mpv/restore-old-bindings.conf (from etc/restore-old-bindings.conf)
# + install /usr/local/share/man/man1/mpv.1 (from build/DOCS/man/mpv.1)
# + install /usr/local/share/applications/mpv.desktop (from etc/mpv.desktop)
# + install /usr/local/etc/mpv/encoding-profiles.conf (from etc/encoding-profiles.conf)
# + install /usr/local/share/icons/hicolor/16x16/apps/mpv.png (from etc/mpv-icon-8bit-16x16.png)
# + install /usr/local/share/icons/hicolor/32x32/apps/mpv.png (from etc/mpv-icon-8bit-32x32.png)
# + install /usr/local/share/icons/hicolor/64x64/apps/mpv.png (from etc/mpv-icon-8bit-64x64.png)
# + install /usr/local/share/icons/hicolor/scalable/apps/mpv.svg (from etc/mpv-gradient.svg)
# + install /usr/local/share/icons/hicolor/symbolic/apps/mpv-symbolic.svg (from etc/mpv-symbolic.svg)
# Waf: Leaving directory `/Users/itoshen/Downloads/mpv/build'
# 'install' finished successfully (0.643s)

# → brew uninstall --verbose mpv
# Uninstalling /usr/local/Cellar/mpv/0.28.2... (26 files, 8.6MB)
# rm /usr/local/bin/mpv
# rm /usr/local/include/mpv
# rm /usr/local/lib/libmpv.1.26.0.dylib
# rm /usr/local/lib/libmpv.1.dylib
# rm /usr/local/lib/libmpv.dylib
# rm /usr/local/lib/pkgconfig/mpv.pc
# rm /usr/local/share/doc/mpv
# rm /usr/local/share/man/man1/mpv.1
# rm /usr/local/share/mpv
# rm /usr/local/share/zsh/site-functions/_mpv



