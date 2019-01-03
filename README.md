# Video Output in ASCII Style via LibCACA

## Feature
- Convert and Export the video in ASCII Style via LibCACA

## Requirement
- bash
- ffmpeg
- img2txt
- webkit2png

## Usage
1. **File Path:** When `Enter the path of the input video: ` displayed<br>
	- Please input the path of the original video.

2. **Resolution:** When`Enter the resolution of the original and output video (e.g. 1920x1080): ` displayed<br>
	- Please input the `resolution` of the *original video*.
	- The input will also be used as the `resolution` of the *output video*.

3. **FPS:** When `Enter the FPS of the original video: ` displayed<br>
	- Please input the `FPS` of the original video.
	- The input will also be used as the `FPS` of the *output video*.

4. **Output Mode:** When `Please Choose a Output Mode:` displayed<br>
	- Input `1`: Output Unscaled Only
		- It will export both the unscaled video ONLY. 
	- Input `2`: Output Scaled Only
		- - It will export both the scaled video ONLY. 
	- Input `3`: Both 1 and 2, 
		- It will export BOTH the sacled and uncaled videos.
	- Input `4`: **Verbose Mode** 
		- It will export the videos as the option `3` does.
		- And it will keep all the .jpg .html and .png files created during the converting process.
	
5. **\* Black Pad:** When `Would you like to add a black pad as background? (Y/N) ` displayed <br>
	> ONLY when scaled video ouput included in the Output Mode option
	
	- Please input `Y` or `N` depending on whether you want a black pad added to you output video.
	- **Attention:** The actual `resolution` of the output video may not exactly be the input you typed in before because of the text converting opration.


6. **FFmpeg Thread Amount:** When `Enter the number of FFmpeg's thread amount: ` displayed<br>
	- Please input the `therad amount` of FFmpeg.

### Output Path
- All the file will be output in the current directory referring to the terminal tty.

### Demo
YouTube: <https://www.youtube.com/watch?v=JbMo_qHuyRw>  
Bilibili: <https://www.bilibili.com/video/av30360792>