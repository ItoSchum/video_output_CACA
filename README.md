# Video Output in CACA Style

## Feature
- Export videos in CACA style

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

4. **Black Pad:** When `Would you like to add a black pad as background? (Y/N) ` displayed<br>
	- Please input `Y` or `N` depending on whether you want a black pad added to you output video.
	- **Attention:** The actual `resolution` of the output video may not exactly be the input you typed in before because of the text converting opration.

5. **Whether Keep the Temporary File:** When `Would you like to keep the original yuv420p file? (Y/N) ` displayed<br>
	- Please input `Y` or `N` depending on whether you want to keep the uncropped temporary Video.
	- `Y` is recommended, considering the preset cropping operation may not suitable for every setting.


6. **FFmpeg Thread Amount:** When `Enter the number of FFmpeg's thread amount: ` displayed<br>
	- Please input the `therad amount` of FFmpeg.
