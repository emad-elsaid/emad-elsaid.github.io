---
Title: "Social stream review"
date: 2015-01-16T18:38:29+02:00
---

[Social stream](http://social-stream.dit.upm.es/) is a gem that acts as a base for your social network rails application, if you're building a social network application, basically it is a rails plugin, a set of models, controllers, views and built on the famous authentication gem "devise".

I started using social stream when i was hired for [Zoser AG](http://www.zoser.com), a company that builds a Geographical social network, and they where using social stream as their application base.

Well, my impression at the first glance was [WOW](https://github.com/ging/social_stream/wiki/Social-Stream-Base-database-schema), they did a great job, thought of a lot of details, how groups, users, pages and other actors will behave, and how posts, checkins, images and other users activities will be stored and a lot of other great things.

![](/images/good-job.jpg)

After some digging i started the WTF state, well the idea is good but their implementation is so tights that forces you on certain architecture, other problems is the cleanness of the code, I sometimes get across some weird behavior and after some digging and tracing and banging my head against the wall i start to realize that social stream is the real problem in here, and to my surprise when i search the code i find it a known bug and the fix is there but no one did it for some reason.

![](/images/wtf-code.jpg)

Other problems with social stream that it is a really heavy gem, if you tried to start your project, run your specs it will be like hell, very looooong startup time + your application logic + jruby heavy startup, you'll stuck in a 2-5 mins startup time depends on your machine specs.

Another problem is the [last commit](https://github.com/ging/social_stream/commits/master) to the official repository is from 5 jun 2014, so apparently they abandoned it to the eagles to eat it.

The last problem is when you start to realize the problem with it, you won't we able to get rid of it as your application will be to stick to it's architecture so your options are :

1. Just keep going with it and fix and maintain your own version
2. Build your app from the start without depending on it.

And both of them are costy and will get you really upset.

So my advice is, use it if you're prototyping your app, but don't use it in your long term development application plan it'll be like hell.
