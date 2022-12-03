The following is a research for the minimum requirement to have Xlog alow following the user from mastodon

* From any account on a mastodon instance tried to search for `@emad@whoispopulartoday.com` the logs were the following

```
W, [2022-11-28T02:24:29.325631 #9]  WARN -- : Exception (ActiveRecord::RecordNotFound) while processing https://whoispopulartoday.com/.well-known/webfinger?resource=acct:emad@whoispopulartoday.com for http.rb/5.1.0 (Mastodon/4.0.2; +https://toot.community/)
W, [2022-11-28T02:24:29.482088 #13]  WARN -- : Exception (ActiveRecord::RecordNotFound) while processing https://whoispopulartoday.com/.well-known/host-meta for http.rb/5.1.0 (Mastodon/4.0.2; +https://toot.community/)
```

* When I request https://toot.community/.well-known/webfinger?resource=acct:emad__elsaid@toot.community to check what should the response be this is what I got

```json
{
  "subject": "acct:emad__elsaid@toot.community",
  "aliases": [
    "https://toot.community/@emad__elsaid",
    "https://toot.community/users/emad__elsaid"
  ],
  "links": [
    {
      "rel": "http://webfinger.net/rel/profile-page",
      "type": "text/html",
      "href": "https://toot.community/@emad__elsaid"
    },
    {
      "rel": "self",
      "type": "application/activity+json",
      "href": "https://toot.community/users/emad__elsaid"
    },
    {
      "rel": "http://ostatus.org/schema/1.0/subscribe",
      "template": "https://toot.community/authorize_interaction?uri={uri}"
    }
  ]
}
```

* Which I understand that it's part of the finger protocol https://www.rfc-editor.org/rfc/rfc7033

* Requesting https://toot.community/.well-known/host-meta returned xml file

```xml
<?xml version="1.0" encoding="UTF-8"?>
<XRD xmlns="http://docs.oasis-open.org/ns/xri/xrd-1.0">
  <Link rel="lrdd" template="https://toot.community/.well-known/webfinger?resource={uri}"/>
</XRD>
```

* Added these files to xlog repo on github https://github.com/emad-elsaid/xlog/commit/30db7caac07f262ed195114a27bf72af186a3fb4
* this repo deploys to xlog.emadelsaid.com
* trying the follow `@xlog@xlog.emadelsaid.com` still didn't show anything. I thought maybe it crawls `/@xlog` and can't find anyting. my profile on toot.community has a link tag. maybe that's it

```html
<link href='https://toot.community/users/emad__elsaid' rel='alternate' type='application/activity+json'>
```

* Crawling the link `curl -H"Accept: application/activity+json" https://toot.community/users/emad__elsaid` returns this json. which is an activity streams person https://www.w3.org/TR/activitystreams-core

```json
{
  "@context": [
    "https://www.w3.org/ns/activitystreams",
    "https://w3id.org/security/v1",
    {
      "manuallyApprovesFollowers": "as:manuallyApprovesFollowers",
      "toot": "http://joinmastodon.org/ns#",
      "featured": {
        "@id": "toot:featured",
        "@type": "@id"
      },
      "featuredTags": {
        "@id": "toot:featuredTags",
        "@type": "@id"
      },
      "alsoKnownAs": {
        "@id": "as:alsoKnownAs",
        "@type": "@id"
      },
      "movedTo": {
        "@id": "as:movedTo",
        "@type": "@id"
      },
      "schema": "http://schema.org#",
      "PropertyValue": "schema:PropertyValue",
      "value": "schema:value",
      "discoverable": "toot:discoverable",
      "Device": "toot:Device",
      "Ed25519Signature": "toot:Ed25519Signature",
      "Ed25519Key": "toot:Ed25519Key",
      "Curve25519Key": "toot:Curve25519Key",
      "EncryptedMessage": "toot:EncryptedMessage",
      "publicKeyBase64": "toot:publicKeyBase64",
      "deviceId": "toot:deviceId",
      "claim": {
        "@type": "@id",
        "@id": "toot:claim"
      },
      "fingerprintKey": {
        "@type": "@id",
        "@id": "toot:fingerprintKey"
      },
      "identityKey": {
        "@type": "@id",
        "@id": "toot:identityKey"
      },
      "devices": {
        "@type": "@id",
        "@id": "toot:devices"
      },
      "messageFranking": "toot:messageFranking",
      "messageType": "toot:messageType",
      "cipherText": "toot:cipherText",
      "suspended": "toot:suspended",
      "Hashtag": "as:Hashtag",
      "focalPoint": {
        "@container": "@list",
        "@id": "toot:focalPoint"
      }
    }
  ],
  "id": "https://toot.community/users/emad__elsaid",
  "type": "Person",
  "following": "https://toot.community/users/emad__elsaid/following",
  "followers": "https://toot.community/users/emad__elsaid/followers",
  "inbox": "https://toot.community/users/emad__elsaid/inbox",
  "outbox": "https://toot.community/users/emad__elsaid/outbox",
  "featured": "https://toot.community/users/emad__elsaid/collections/featured",
  "featuredTags": "https://toot.community/users/emad__elsaid/collections/tags",
  "preferredUsername": "emad__elsaid",
  "name": "emad__elsaid",
  "summary": "<p>A Software Engineer <a href=\"https://toot.community/tags/Ruby\" class=\"mention hashtag\" rel=\"tag\">#<span>Ruby</span></a> <a href=\"https://toot.community/tags/Golang\" class=\"mention hashtag\" rel=\"tag\">#<span>Golang</span></a><br />🇪🇬 Egyptian 📷 Youtuber 🎮 Casual gamer and 🚀 Sci-Fi addict<br />My opinions are my own</p>",
  "url": "https://toot.community/@emad__elsaid",
  "manuallyApprovesFollowers": false,
  "discoverable": false,
  "published": "2022-11-05T00:00:00Z",
  "devices": "https://toot.community/users/emad__elsaid/collections/devices",
  "publicKey": {
    "id": "https://toot.community/users/emad__elsaid#main-key",
    "owner": "https://toot.community/users/emad__elsaid",
    "publicKeyPem": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzde2MpFVF2HpkNBzvC92\njwEx4T7BBqUULLj37sTkUj3j87shXNBq03GLLjYmTewtVRlePvQOUEvFyNljNYdT\nZjhhad2lKEGTb4mYhCNtZBqx456Lo+8RiBY/JQTwmqtfh6CLZGZ4jzv2i3W9tv5e\nU7qV8CUO+LALWD/QyIE+WiT4iZ50gc9EPD3YG0wkREDH0wmmoYbifRekAMBZyEad\n6W7VpzjDe7gJug0fOllgfwY2aCN73OBLga6Gj1cJI+j4qxG66OdFeGGDRrZU2p0t\nMJW3zfdBEiPGwJ510P5Yieb0WeAquGcsukPbZsPD7a+bm7Bk9Uk7craKUFnR98wV\n1wIDAQAB\n-----END PUBLIC KEY-----\n"
  },
  "tag": [
    {
      "type": "Hashtag",
      "href": "https://toot.community/tags/golang",
      "name": "#golang"
    },
    {
      "type": "Hashtag",
      "href": "https://toot.community/tags/ruby",
      "name": "#ruby"
    }
  ],
  "attachment": [],
  "endpoints": {
    "sharedInbox": "https://toot.community/inbox"
  },
  "icon": {
    "type": "Image",
    "mediaType": "image/jpeg",
    "url": "https://files.toot.community/static/accounts/avatars/109/293/903/126/839/684/original/2e879ecd79c7238c.jpg"
  },
  "image": {
    "type": "Image",
    "mediaType": "image/jpeg",
    "url": "https://files.toot.community/static/accounts/headers/109/293/903/126/839/684/original/96510da372657af0.jpg"
  }
}
```

* Added the file after cleanup to github repo https://github.com/emad-elsaid/xlog/commit/5627dbea0c60f87c08d98cab00d1fd8a9ec378cc
* Still nothing
* I checked the code and it hits `host-meta` only if there is a problem fetching `webfinger` so removing `host-meta` shouldn't be a problem
* used ngrok locally and wrote an extension that handle these two files instead of static files and it worked

![](/public/bbc73ef39594cacbb836fa0e4fcabbd4e0e20f7656b06ab551d8c5c17b09d800.png)

* clicking the item shows the profile

![](/public/3f27d9c5cd0f75a8a4c13abd1bc726a185d1d9c8caeb9ce62b7263219e94af06.png)

* So far after some improvements it worked https://github.com/emad-elsaid/xlog/commit/d2730ad1a862e7eedf0fdf2d732b14ab44e86884
* Here is the profile appearing on Mastodon https://toot.community/@Emad@www.emadelsaid.com
* And here is the configuration https://github.com/emad-elsaid/emad-elsaid.github.io/blob/master/.github/workflows/xlog.yml#L41
* The mastodon blog post about implementing basic activitypub server explains a lot of things well. I wish I have seen it first before the struggle https://blog.joinmastodon.org/2018/06/how-to-implement-a-basic-activitypub-server/


# Resources

* [How to implement a basic ActivityPub server](https://blog.joinmastodon.org/2018/06/how-to-implement-a-basic-activitypub-server/)