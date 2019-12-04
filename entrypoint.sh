#!/bin/bash

# Author https://github.com/ntimo

sleep 5

while true
do

config=`cat /config.json`

echo "Sleeping for 300 seconds"
sleep 300

    for row in $(echo "${config}" | jq -r '.[] | @base64'); do
        _jq() {
         echo ${row} | base64 --decode | jq -r ${1}
        }

        sleep 1

        emailregex="^(.*)@(.*)$"
        [[ $(_jq '.username') =~ $emailregex ]]

        localpart=${BASH_REMATCH[1]}
        domainpart=${BASH_REMATCH[2]}
        directory="/tmp/${domainpart}/${localpart}/$(_jq '.imapfolder')"


        if [[ ! -e ${directory} ]]; then
          echo "Creating Storage directory"
          mkdir -p ${directory}
        fi

        echo "Starting attachment download"
        attachment-downloader --host $(_jq '.host') --username $(_jq '.username') --password $(_jq '.password') --imap-folder $(_jq '.imapfolder') --output ${directory} --delete
        echo "Finished attachment download"

        # Interates over a folder and subfolders and uploads all files using sendcloud.sh
        while IFS= read -r -d $'\0' file; do
          for ((i=0; i<=0; i++)); do

            directoryfile=$(dirname "${file}")
            filename=$(basename "${file}")
            fileextension="${filename##*.}"

            if [[ $fileextension =~ $(_jq '.allowedfileextsions') ]]; then

              cd $directoryfile
              echo "Uploading $filename using drop link $(_jq '.nextclouddroplink')"
              /cloudsend.sh "$filename" "$(_jq '.nextclouddroplink')"
              echo "Upload finished"

              sleep 5
              echo "Removing $filename"
              rm "$filename"

            else

            echo "Filetype is not allowed"
            rm "$filename"

            fi

          done
        done < <(find ${directory} -maxdepth 2 -type f -print0)

    done

done
