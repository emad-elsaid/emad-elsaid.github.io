---
title: A general idea of a peer to peer social network
image: /images/IMG_20201227_115636.jpg
---

The following are some ideas that I have developed as a result of the discrete
discussions of abandoning centralized social media and privacy concerns related
to them.

These ideas can be stitched together to create a decentralized social network.

What I'm aiming for is to have all the user data on his machines (phone,
desktop, laptop) and exchange his social feed with other people machines on the
same network or across the internet.

## Format

My social feed on my phone can be stored as text files in a machine readable
format like JSON, YAML, BSON or any other format. This is not a new idea, text
files proved it's strength to hold information over time without being locked to
a specific editor. the user can open and read them in any text editor on any
machine. reading text files is simple and a developer can do it after having a
basic understanding of any programming language. parsing the format shouldn't be
a bottle neck. so we should use a format that's easy to parse.

Local files are easy to backup and move around with simple files operations.

Whatever application will manage them can build his own indexes over the data
inside these files and keep his indexes in sync with the files.

## Data Structure

- Every file in my social feed will contain what I'll call a post, like a text
  status or text with image, or text with link or text with any other attachment
  like geolocation or activity or event
- Every type of post can have a specification that include attributes and their
  data formats.
- Specifying the data structure specs instead of leaving it to every application
  will ensure interoperability between applications which prevent the effect of
  walled gardens we already have with proprietary file formats and current
  social media

## Exchanging social feeds

- Every user identity will be represented with an asymmetric encryption key. For
  a user to create a new account/identity he need to generate a key pair.
- To share my identity with another user I will need to send him my public key.
- There already infrastructure to share PGP keys we can use that to exchange
  keys across the internet or offline via QR codes
- The application managing the social feed will need to listen on a port on the
  machine exposed to local network or the internet
- The HTTP REST API interface seems to be simple enough to allow requesting
  social feed updates
- Requests to the API interface should be encrypted with the public key of the
  receiver so only the receiver can decrypt it
- Requests to the API should specify the public key of the requesting party so I
  can give that user only the social updates meant for him.
- Responses will be also encrypted with the public key of the requesting party
  so only him can read the social feed post addressed to him
- So if I want to get updates from my friend I'll ask his API to give me all
  updates after say `15-01-2021T00:00UTC` the request include my public key and
  encrypted with my friend public key. My friend API will get all updates that
  are meant for me after this timestamp and encrypt them all with my public key
  and send them back to me.
- To know what timestamp I should be asking for I can check my local friend feed
  recent post date and ask about the posts after that. and I can do this as many
  as I want until he respond with nothing. I then will know that I got all his
  updates.
- If a post is public then no need to encrypt the request or the response at
  all. so it'll work like a twitter or Facebook public feed
- Applications can group friends public keys into directories to allow the user
  to share posts to group of friends and when a friend ask about updates it'll
  check which groups he belongs to and send him new posts addressed to him
  personally like "comments, likes, posts" or to the group of friends he belongs
  to like a birthday invitation to the "Family" friends group.
- Blocking a person is as simple as refusing requests the include his public key.
- Asking for social updates can be more detailed but keeping it as simple as
  possible will also push for easier interoperability. So we can have a request
  to ask for specific type of posts but keeping the request as generic as
  possible will make it easier to build clients that talk to each other. and
  filtering then can be done on the client itself afterwards.


## Discovery

- Standard service discovery techniques can be used like mDNS to discover
  services in a local network
- Across the internet proxy servers can be used or a Kademlia p2p network to
  reach each other

## Final Notes


- what I'm trying to achieve is to simply exchange social feeds as simple as
  possible
- The previous ideas can be implemented with any language capable of creating a
  HTTP server
- The previous ideas are avoiding having long running servers or middle man as
  much as possible so it wouldn't deteriorate to centralization again
- Also I tried to make the user in control of his posts and make copies for
  specific people
- I tried to side with interoperability and simplicity to make it easier to
  create clients and make them talk to each other instead of diving into details
  ofr exchanging social feeds risking to make it harder to implement a
  client/server for the said network
- There are many efforts in this direction like ActivityPub with ocnsistent APIs
  and formats. I think it aims more to a distributed social network than a peer
  to peer network. but some pieces are still useful and can be borrowed.
