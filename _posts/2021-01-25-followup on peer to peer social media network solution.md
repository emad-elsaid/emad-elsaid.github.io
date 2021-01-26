---
title: Follow up on peer to peer social media network solution
image: /images/IMG_20201225_134447.jpg
---

In [the last post](/a-general-idea-of-a-peer-to-peer-social-network) I presented
some simple ideas that can work together to create a peer to peer social
network.

In this post I want to get into more details. Imagine a simple application and its
interface with the user and with other instances of itself.

- So lets imagine a simple process, an empty process that does nothing.
- Let this process assume the current directory is the data directory that will
  hold all of the social feeds for the current user and his friends.
- That means this application can manage multiple users on the same machine just
  by running different instances in different directories.
- Now lets establish a sub directory for identities and simple enough call it
  "identities"
- The identity is a keypair, assuming the public part is `PUB` and the private
  part is `PRIV` and `PUB` fingerprint is `FP`.
- When we create an identity for current user we'll save `PUB` file as
  `<FP>.pub` and his `PRIV` as `<PRIV>` without extension.
- When we receive an identity for another user `PUB1` we can calculate the
  fingerprint `FP1` and save it in `identities/<FP1>.pub`
- This structure means we can lookup an identity public key if we have the
  fingerprint value. so when we get any content signed by `FP1` with signature
  `SG1` we can validate the content is really signed by that person using the
  public key value from the file. and if we failed to find the full key we can
  then ask for it from another instance.
- Now we know where to save and lookup the user identity to sign content and to
  validate other people signatures.
- Now lets have an interface for this process to do basic operations that manage
  identities. We'll open a port "8888" for example for local user to manage
  identities.
- 8888 interface will be an HTTP server. let it accepts requests to create
  identity with a password. and sign text with an identity private key given the
  content, the identity fingerprint and the private key password.
- It also deletes an identity given it's fingerprint and password.
- For identities other than the ones for the current user, we need endpoints to
  list, create, read, delete identities.

Now we're done with the basic identities management. that previous structure
will allow:

- Multiple user identities as he can create as many key pairs as he wants. so
  he can have a work identity and another separate identity for personal use.
  another anonymous one.
- The structure allow segmenting keys to groups in subdirectories. so you can
  group family in a directory. Friends in another. and work colleagues in
  another. Journalists in another directory.
- The user can have an friend identity in more than one category by copying the
  public key in two or more directories. So say a friend "Sam" can be a friend
  and also we work together so his public key will be in "identities/friends"
  and "identities/coworkers"
- Blocking someone can also be done simple by creating a directory "blocked" and
  add the public keys to it. so when we get any content from this keys we'll
  ignore this content.

Now if we need these processes to exchange identities with each other we'll need
a public interface to ask each other for identities

- Let the process listen on a port on external networks "8889" for example.
- Let one process know the IP of the other one on another machine
- One proceess can do HTTP requests to the other process asking for identities
  full public keys by their fingerprint. this is similar to the PGP key servers.
  just simpler.
- So one process got a piece of content that's signed by a key with finger print
  `FP1` but `identities/<FP1>.pub` doesn't exist. it'll ask some other processes
  about this FP1 public key. simple. you get a bunch of content from people you
  know but the comments for example is from other people you don't know. to get
  their public keys you ask the same user that gave you the content. over time
  you accumelate enough identities and you don't have to ask for it. and we
  don't have to transfer the full public key with every piece of content. that
  will save alot of bandwidth over time.


Now couple users can have identities on their machines and when one machine
doesn't have the full public key for a fingerprint it'll ask the others to
provide it. the advantages I see for this appraoch is:

- You don't need persistent servers like key servers. but still open for
  dedicated servers that can be used just for key exchange. a client can have a
  dedicated server when creating a new identity it can send the public key to a
  server and then that same client can ask for the full public key from another
  user saving the bandwidth of the users and moving it to that server.
- Identities are still anonymous. it doesn't hold personal information. so we
  separated identity from profile information. allowing the user to have
  multiple identities with same profile or multiple identities with multiple
  profiles or an identity without a profile at all.
- We can touch the identity file everytime we use it. then the last modified
  date of the identity file will keep track of the outdated profiles and delete
  the ones that are not used for a while allowing clients to reduce disk usage.
- When asking about the full public key for a fingerprint and the server lied
  and sent another public key it's easy to regenerate the fingerprint from the
  key and match it with the requested then punish the server by blocking it as
  it's a malicious actor in the network.

So far we have a process that listens on 2 ports one available only inside the
machine for the administration and another for public consumption from another
process. It uses the disk to store identities for current user and other users
and can exchange it between each other.

Note that there are already an infrastructure for PGP keys exchange. that can be
also utilized to exchange identities. I just want to keep it simple and limited
to the features we need and not inherit a whole protocol for exchanging
identities.

Now we get to the content itself. The social feed we want to share between
users.

- For sure we'll need a place to save the data whatever it is. lets have a
  `posts` directory and put everything there.
- Our data is for sure split to units, each unit is a post, image, link,
  video...etc the usual social feed we're used to. so lets save each in a
  separate file. the file name is the SHA1 sum of the content of this post.
- For each post we need to make sure it's created by an identity. so when it
  moves from one machine to the other it should have the proof that it
  originated from the key pair owner. so we'll need the post content whatever
  the format it to be signed and the signature needs to reside in the same post
  file. So the file content should hold the post content, the public key
  fingerprint and the signature. this reminds be of JWT format where it's
  formatted in 3 parts separated by a dot. So we can have each post file
  formatted as follow:

  ```
  P1 = content of the post base64
  FP = creator key fingerprint
  SIG = P1 signed by the public key PUB of the fingerprint FP
  File = P1.FP.SIG
  ```

- If we set the file modification date to the post creation time itself we then
  can query the file system for files ordered by the modification time and we'll
  get the latest posts. so if the client want to show the last 100 posts or so
  it can do this easily without reading the content of each file.
- This means we'll need the post content to have the `created at` time. lets
  keep this in mind.
- Now if we need to see posts only from a specific person. like when we get to
  his profile. we can't do that without reading all files and check if it belong
  to this user. or the client can build an index for it. it would be nice if we
  can organize the files in sub directories each for an identity fingerprint. so
  lets add that. now we'll have the structure as so `posts/<FB>/<SHA1>`
- The client can still create custom indexes to make it faster to list posts.
  but it doesn't have to be part of our structure. this is good enough I guess.
- Now the content of the post itself. there are many formats we can use. I would
  have preferred XML but there is a stigma attached to it and most modern
  developers are used to something like JSON so be it. generating and parsing
  JSON isn't a problem for anyone nowadays so we can go for it.
- The attributes of this JSON should be different based on the what we need to
  share. so the simplist post will contain `TEXT` and `CREATED_AT` fields. a
  string and unix timestamp respectively.
- If the user want to share an image we can have it in two different ways,
  either the a field `IMAGE` with the URL of the image on the web. or `IMAGE`
  field with the image content base64 encoded content. If we named the
  attributes with a suffix of the type we can support both. `IMAGE_URL` means
  the attribute name is `IMAGE` and the value must be treated as a URL. if it's
  `IMAGE_JPG` means the value is `JPEG` format encoded as base64. then we can
  support more images and more formats `IMAGE` in this case would be just an
  identifier and doesn't matter if the name is `123_JPG` we already know the
  content is an image.
- That means to support sharing a link we can just send it as `ATTRIBUTE_URL`
  and the client can read the content of the URL and display it based on the
  returned file signature.
- So we can generalize it even more. if we named the image `IMAGE_BIN` instead
  of `IMAGE_JPG` then we can also decode it from base64 and get the file type
  from the magic bytes and render it based on the type. if it's an image we
  render it as image. audio rendered as audio player...etc
- Other types can be another post. like when we share a post written by someone
  else to our own timeline. we can do that by supporting a `*_POST` format where
  the content is another post content. with the file format `P1.FP.SIG`. that
  means I can take a post from my friend and wrap it in another post with
  commentary and reshare it to someone else.
- One thing that maybe we'll need to enforce here is the `CREATED_AT` attribute.
  As we need to know when the post was created. and to conform to the previous
  naming we can use `CREATED_TIME` where `_TIME` is a unix timestamp.
- Rendering post content in clients can be a problem if we have many attributes.
  I thought we can enforce having the order of rendering in the post itself as a
  special attribute. but then that wouldn't be fun. I mean if we left it then it
  would be fun to see how the designers decide to render posts based on the
  available attributes. and we'll get lots of creativity out of that. so lets
  leave it be.


Now that we know how to save and retrieve posts. How are we gonna exchange them?

- Assuming I have 2 users `Ahmed` and `Basant` and each of their processes knows
  each other IP addresses.
- `Ahmed` process every 10 minutes can as `Basant` process for new posts
- `Ahmed` knows the most recent post from `Basant` fro her directory on his
  machine so he can always ask for posts after that itmestamp
- `Basant` process can do the same to get `Ahmed` new posts.
- So we need our Process to do 2 things. 1 check for new posts for all users
  that we care for every period and when it gets the posts it will save them in
  the corresponding directory. 2 an endpoint that serve the user timeline given
  his fingerprint.
- The fingerprint must match a public key we have its private key to distribute
  the content of our identity only.
- The endpoint will take a timestamp and return the first say 10 posts after
  that timestamp.
- This is like asking your friend every day `How are you doing?` and he respond
  with every thing happened since you last talked to each other. pretty simple.
- And as the posts are signed we can make sure the posts we get are really
  signed by `Basant` or `Ahmed`
- If we lifted the contraints that you can't respond unless you own the private
  key we can have users distributing other users content. so we can have servers
  that volunteer to redistribute people public social feeds. but also that opens
  a door to sensorship as a server can lie about the existence of a post or two
  that it doesn't like. so lets make sure we have that contraint and not open a
  door for sensorship. we all have seen what's behind that door.
- So then we need to make sure when `Ahmed` is asking `Basant` that he's really
  talking to `Basant` not a middle man. So we'll need to encrypt the requests
  from `Ahmed` to `Basant` with `Basant` public key. so only her can read the
  request. and do the same to the request. `Basant` response needs to be
  encrypted with `Ahmed` public key so only `Ahmed` can read the response. even
  if there is a middleman he can't decrypt them or read the content.
- But also we'll need to make sure there is no middle man changing the request
  and signing it and passing it to the other side. sooo lets also add a nonce to
  the request `Basant` will include it in the response to make sure we're
  getting the response for that request not anything else.

So now we have processes that can exchange social feed with each other. note
that there is a format and specification for social feeds called ActivityPub
that could be used. I rethought that in this post to develope the idea based on
the reasoning in my head.

Now that we have posts exchanged between users. how about replies to posts.
where one is commenting or replying to a post.

- One thing I want to avoid is the number craze that's associated with
  commenting and reacting to posts (likes, fav, love, care, sad) and all these
  things that drive people mad and makes thme stupid to drive more of them. At
  least avoid having these number propagate. so I don't need to know a post got
  1M likes to appreciate it's content. So I will avoid propagating numbers from
  the user to another user.
- So You'll see a post from a friend. you can send him a comment, telling him
  you appreaciate it. if the comment text is just an emojie we can display it
  in a different way. so that means we can have only one type of replies. a
  comment
- This comment send from `Ahmed` to `Basant` so it needs to be also signed by
  `Ahmed` like any post.
- The comment as creation time and text like a post
- It can also include an image or attachment.
- So what makes a comment special? we can make the comment is just a post with a
  parent post.
- We can have comments are just posts that are directed to a specific person on
  a specific post. so we'll need to indicate that in the post. a special
  attribute with `TO_FINGERPRINT` that has `Basant` fingerprint in it. and
  `REPLY_POSTSHA` is the SHA1 of the post we're replying to.
- That means we can comment to a comment, and the comment can have any content
  we want like any post. and we have endless comments on comments.
- Now were do we save these posts. I say save them like any other posts in
  `posts` directory. that means we'll propagate the comments like any post. and
  the client doesn't have to show the comment unless he has the original post.
- That opens up the discovery a bit by getting the fingerprints of users from
  comments `TO_FINGERPRINT` and looking up their full public key and their profiles (we didn't
  talk about profiles so far).
- Clients can restrict posts with `TO_FINGERPRINT` to the user with that
  fingerprint leading to less discoverability but more privacy and less
  bandwidth.
- Also if `Basant` want to send comments of the post to `Camal` for example we
  have 2 options. either return `Ahmed` comment to `Camal` or not. I think this
  is up to `Ahmed` to decide not `Basant` so I would say NO `Basant` shouldn't
  broadcast the comment. the comments was meant for her and if `Ahmed` want to
  broadcast it he should do that himself. so If `Camal` already knows `Ahmed`.
  Ahmed can choose to broadcast comments to `Camal` while syncing posts. then
  Camal can see the comment on the post.
- That leads to people distributing only their content. so no freeloading or
  piggybacking on a friend to distribute videos or images. if you want to tell
  someone something you tell him not `Basant` in this case.
- Also that opens the door for private messages. As you can by extension create
  a post with `TO_FINGERPRINT` attribute but not `REPLY_POSTSHA` to send a post
  to a specific person not a reply to a post. the client can separate posts from
  private message like that. and as the posts doesn't propagate then the message
  won't be sent to anyone else.
- How about messages to multiple people? well then we can generalize that
  `TO_FINGERPRINT` attribute. we can say any post with a `_FINGERPRINT`
  attribute is meant to be sent to that user. and while we're at it any
  `_POSTSHA` attribute is meant as a reply to the post with this post SHA1
  value. and in this case you can write a comment/post/message and send it to
  multiple people. that will do it for group chat. people send posts to each
  other with their fingerprints in the message so the private message will have
  the same capability of a post.

Now we get the the profiles. people pictures and names and other basic
information they want to share with each other that's persistent. how do we deal
with them?

- So the profile is like a document or a post that special because it's more
  persistent.
- So why it's not just a normal Post, with image field, text field, phone field.
  an other fields. maybe we can just have special types to signify that this
  image is a profile picture? like a data type? and the user name as another
  type `_PROFILENAME` and another for `_BIRTHDATE` and another for `_WORKPLACE`
  and so on.
- That will allow users to have a public profile that's addressed to everyone
  and a more private one with `_FINGERPRINT` list in it to address it to
  specific people.
- Also that means when you get a request from a new person you can choose which
  profile post get sent to him. the client can copy that profile and change the
  `_FINGERPRINT` to that person giving the user a finetuning for who sees what.
- The special types like `_BIRTHDATE` will allow clients to have a list of
  birthdays or friends phone numbers which other features can built on like
  reminder of birthdays or a phone book, or address book

That's basic usage. I guess. that covers basic usage. next we'll have the issue
of discoverability. how to know the network routes to each other. probably we
can use mDNS for the same network. probably we can use webRTC infrastructure
servers like STUN servers. The whole ICE will be useful in this case.

Let me know if I missed something or something can be taken out of this concept
to make it simpler. it's easy to add more stuff. but what I would like to do is
a small consistent concept that as minimal as possible.
