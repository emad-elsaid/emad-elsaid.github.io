---
title: what are we sharing?
image: /images/IMG_20201225_123145.jpg
---

In the past weeks I had this continious thinking about how can we approach a
distributed peer to peer social media network. I faced this problem where I
don't know the best way to identify a piece of content and here is why.

If we say the post I wrote on my blog is identified by the the URL and you
shared this URL you assume people will open the link and find the article you
mean to share.

But If after you shared it I changed the content completely to something else
now the URL doesn't point to the actual article you wanted to share.

But "changing the content completely" is the extreme. there is a scale between
not changing the not changing the content at all and replacing the whole post
with another post like fixing a typo or adding referenced at the end or thanks
and aknowledgment section or adding a paragraph or a notice that the content is
outdated.

## So where exactly is the identity of the content?

Twitter for example is on the side of immutable content. you write the tweet
once and fire it. you can't even fix a typo. and that is annoying.

Facebook on the other end of the scale you can write a post it goes viral and
you can change it to a punch of ads afterwards.

So If I'm sharing this article. what am I exactly sharing? it's not the literal
content of the article right? because you can accept little changes like me
fixing a typo or adding a clarification or footnotes. but you won't accept it if
I started to change the article to a review of some hardware with affiliate
links.

A system like IPFS went on to address the content with the hash of its bytes. if
you change one byte it's different content.

## In the context of a social media

These are the things I assumed when I thought about a solution for this issue.

If I'm building a social media how can I address a piece of content?

- I assumed that I shared the approximate content of the content
- changing the content slightly is acceptable

So the solution I though that will be in the middle ground between both worlds
(immutability and extreme alteration):

- Keep all versions of the content.
- The content identifier is a generated UUID by the user
- When sharing a piece of content you are pointing at this content UUID and the
  version hash
- When you retreive a piece of content you should get all the versions

The previous solution means:

- You can build a client that shows only the latest version of the shared
  content
- You can build a client that shows the content at the point of sharing
- You can browse all content versions (what facebook call "edit history")
- You can update content as you wish as long as you keep the UUID
- You can build clients that measure the distance between shared content and
  latest version and show old version of the latest version alterations are over
  a threshold the user defines.
- You can attach comments and reactions to the content to the post the same way.
  reference content ID and version hash.
- clients can show older version while showing a label "new version available"
- Or the reverse: show latest version while showing "shared from 3 versions old"
