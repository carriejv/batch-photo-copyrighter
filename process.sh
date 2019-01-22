#!/bin/sh

declare -a sizes=("256" "576" "768" "960" "1200" "1440" "1920" "4096")
declare name="Carrie Vrtis"
declare website="www.carrievrtis.com"
declare copyright="Copyright 2019 Carrie Vrtis. All Rights Reserved. $website"
declare watermark="./watermark/watermark.png"

for file in photo-source/*.jpg; do
    mkdir -p ./working
    filename=$(basename "$file")
    [ -e "$file" ] || continue
    if [ ! -d "$file" ]; then
        echo "$filename..."
        filebase="${filename%.*}"
        filetitle="${filebase//-/ }"
        filearr=( $filetitle )
        filetitle="${filearr[@]^}"
        filedate=$(exiftool -createdate -S "$file")
        filedate="${filedate:12:4}"
        mkdir -p exif
        exiftool -exif:all= -tagsfromfile @ -exif:all -unsafe -thumbnailimage -F "$file"
        exiftool -createdate -aperture -shutterspeed -focallength -iso -json "$file" >> "exif/$filebase.json"
        exiftool -m -artist="$name" "$file" > /dev/null
        exiftool -m -copyright="$copyright" "$file" > /dev/null
        exiftool -m -caption="$filetitle by $name. $filedate." "$file" > /dev/null
        exiftool -m -description="$filetitle by $name. $filedate. $website." "$file" > /dev/null
        cp "$file" "./working/$filename"
        gm mogrify -auto-orient "./working/$filename"
        gm composite "$watermark" "./working/$filename" -geometry +17+17 "./working/wm-$filename"
        gm composite "$watermark" "./working/wm-$filename" -gravity SouthEast -geometry +17+17 "./working/tile-$filename"
        for i in "${sizes[@]}"
        do
            mkdir -p "photo-cache/$i"
            if [ "$i" = "4096" ]; then
                gm convert "./working/tile-$filename" -resize "${i}x${i}" -quality 80 "photo-cache/$i/$filename"
            elif [ "$i" = "256" ]; then
                gm convert "./working/$filename" -resize "${i}x${i}" -quality 80 "photo-cache/$i/$filename" 
            else
                gm convert "./working/wm-$filename" -resize "${i}x${i}" -quality 80 "photo-cache/$i/$filename"
            fi
        done
    fi
    rm -rf ./working
done

echo "Cleaning up..."

mkdir -p "archive-cache"

mkdir -p "archive-source"

for i in "${sizes[@]}"; do
    for file in photo-cache/$i/*; do
        filename=$(basename "$file")
        [ -e "$file" ] || continue
        if [ ! -d "$file" ]; then
            mkdir -p "archive-cache/$i"
            cp "$file" "archive-cache/$i/$filename"
        fi
    done
done

for file in photo-source/*.jpg_original; do
    filename=$(basename "$file")
    [ -e "$file" ] || continue
    if [ ! -d "$file" ]; then
        rm "$file"
    fi
done

echo "Done."
