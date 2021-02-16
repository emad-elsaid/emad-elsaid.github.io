---
title: Sound approach for a p2p social network which falls back to current web
image: /images/e420d55f-a60c-4892-8d1f-1c7ec03a2d08.jpg
---


Following the last 2 posts and other videos in the past weeks. The following
will continue on the same track of a peer to peer social network.

I'll build the idea as layers over each other so:

# First: Data format

- I will write my notes, recipes and any activity I want as JSON file on my filesystem.
- To have a common schema I'll use schema.org specifications to present my
  activities.

# Second: Protecting my data

- I will create an openPGP key pair for signing and a sub key for encryption
- I will sign and encrypt my files with the keys so only me can read it and make
  sure no body else edits it.
- Files are now formatted in openPGP format on disk.

# Third: Exchanging my data

- To exchange a note with my friend
- My friend will upload his public key to a keyserver
- I will get the key and verify the signature in another channel
- I will add him as a receiver to the file I want to share
- I will send the file to my friend in an email or chat message or any other
  channel.

# Forth: Organizing my files

- To separate files that are created by me from my friends I will create a
  subdirectory for each keypair named after the key short form.
- Now I can see all files shared by one friend in one directory

# Fifth: Browsing my files

- I can build a CLI tool or a UI to create schema.org files signed/encrypted by
  my key and also for a friend
- I can extend the UI to show the files content in a user friendly presentation
  ordered by creation time latest first
- Now I have a timeline of my activities and my friends
- Now I can filter the files with a subdirectory which makes it my friend
  timeline.

# Sixth: Syncing with friends

- I can extend the client UI to join a kademlia network that connect me to my friends
- I can make the client UI send the missing files to my friend and delete the
  files I deleted locally

# Seventh: Social interactions

- Liking/disliking and other interactions can be also schema.org files
- That will make them ordinary files which has save privacy and exchange
  mechanism as normal activities
- The UI can choose how to display the social interactions.

# Eightieth: Falling back to the web

- websites are using schema.org for SEO
- my client UI can read the webpage and extract schema.org parts and render them
  like any other post
- I can subscribe to a website which will make the client crawl it regularily
  and extract the schema.org parts and save it to a separate subdirectory for
  this website.
- Having the peers interact together over HTTP will make it easier to use the
  same code for crawling the websites.
- Having the peers exchange schema.org format will make the code reusable.
- My client can have another interface that render my public activities as HTML
  pages with schema.org microformats in the same page and a HTTP proxy server
  can sync regularily with the client and serve my social feed over HTTP
- Having the activity as a JSON file without encryption means it's a public data
  so anyone on the internet can download the file and read it.

# Ninth: Sharing content

- A file I exchanged with a friend is encrypted for him and other receipients
- My friend can create schema.org shareAction that reference my file address as
  the "object" attribute value.
- He can exchange this file with his friends
- His friends will retrieve the file from me if they're one of the recepients
- My client will refuse to transfer the file if the user requesting it is not
  one of the recepients.
- Even if my friends transferred the file to them without my permission the file
  can't be decrypted by their client.
- If my friend added his friends as recepients to the file and transferred it to
  them it is technically possible but it will be breaking my trust in him.
  similar to taking a screenshot of private messages. technically possible but
  a social violation.
