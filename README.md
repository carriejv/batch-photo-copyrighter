# Batch Photo EXIF / Watermark Processor

A shell script that uses [ImageMagick](http://www.imagemagick.org/script/index.php) and [ExifTool](http://www.imagemagick.org/script/index.php) to quickly process photos for online hosting.

The script uses ExifTool to scan for and correct bad EXIF data while inserting authorship and copyright data. ImageMagick is used to generate multiple scaled versions of each image, with watermarks on any images larger than 256px in width, and a tiled watermark on any larger than 4096px.

## Usage

```
Move all photos to be processed into the photo-source directory. Originals will be copied to archive-soruce before any modifications are made.
```
```shell
chmod +x process.sh
./process.sh
```
```
Scaled, watermarked images will be sorted by width in new-cache. Copies are also created in archive-cache, if a peristent collection of processed images is desired.

Basic EXIF data is saved in JSON format in the exif directory.
```

## License

[MIT](https://github.com/carriejv/gc-speech-transcription-py/blob/master/LICENSE)