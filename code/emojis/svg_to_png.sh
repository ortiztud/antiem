emoji_dir='/Users/javierortiz/github_repos/emojidex-vectors/emoji'
emoji_dir='/Users/javierortiz/Documents/svg_online'

output_dir='/Users/javierortiz/Downloads/emoji_png'
output_dir='/Users/javierortiz/Documents/svg_online/png'

# Get file names
#ls -d $emoji_dir/utf/* > names.txt
#ls -1 $emoji_dir/utf/* | sed -e 's/\..*$//' >names.txt
#ls -1 $emoji_dir/extended/* | sed -e 's/\..*$//' >names.txt
cd $emoji_dir

# Read them in
while read -r cSub
do
  	array[$c]=$cSub
        c=$(($c + 1))
done < svg_names.txt

for c_svg in `seq 871`
do
    # svg file
    svg_file=${array[$c_svg]}
    echo $svg_file

    # convert
    /Applications/Inkscape.app/Contents/MacOS/inkscape -w 600 -h 600 $svg_file.svg -o $svg_file.png

  done


# Move the pngs to a new folder
#mv $emoji_dir/utf/*png $output_dir/
mv $emoji_dir/extended/*png $output_dir/
