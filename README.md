# E-Mail Attachments to Nextcloud

This project aims to solve a very simple problem, you have a email account with one folder that contains all your bills and you want to have the pdf attachments in your finance folder in your Nextcloud. But are too lazy to upload them all manually.

## Features
Upload all attachments from one email folder to Nextcloud using a drop only link and then delete the email from the mailbox.

## Configuration
You can configure multiple email accounts using a json config that has to be mountet at /config.json inside of the container. Using the `allowedfileextsions` you can define a regex pattern for fileextensions that should be uploaded example: (pdf|png) to upload pdf and png files.

Example:
```json
[
{
  "host":"mail.domain.com",
  "username":"attachments@domain.com",
  "password":"password",
  "imapfolder":"INBOX",
  "nextclouddroplink":"https://nextcloud.domain.com/s/123456789",
  "allowedfileextsions":"(pdf|png)"
},
{
  "host":"mail.domain.com",
  "username":"attachments-bills@domain.com",
  "password":"password",
  "imapfolder":"INBOX",
  "nextclouddroplink":"https://nextcloud.domain.com/s/123456789",
  "allowedfileextsions":"(pdf|png|jpg)"
}
]
```

## Docker
```
docker run -v $(pwd)/config.json:/config.json:ro timovibritannia/emailattachments-to-nextcloud:latest
```

## Important
All emails with a attachment will be deleted by this container to avaid uploading duplicates. Please use a special mailbox for this like bills@domain.com