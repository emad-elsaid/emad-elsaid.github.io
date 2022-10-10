![](/public/IMG_20220225_175133.webp)

I have been using [remarkable 2 tablet](https://remarkable.com/) over the past week. It's a beautiful device. a thin tablet with E-ink screen and a pen. with Linux OS on it. and custom interface that is totally distraction free. It tries to imitate the feeling of writing on real paper and it succeeded.

Here is what happened since I order it until today. my remarks. pros and cons and some suggestions for improvements.

# The order

* Remarkable is sold only on [remarkable.com](https://remarkable.com/). you can't buy it from amazon or eBay from them.
* I ordered Remarkable2 tablet, the basic pen (not the premium). and with no folio
* My order aimed at getting the basic experience before I pay extra for an improved pen or a folio.
* The order comes with 100 days of remarkable connect for free.

# Delivery

* The confirmation mentioned that I'll get an email for DHL tracking code
* After couple of days I didn't get the tracking code. so I contacted their support
* They were very responsive. and turns out DHL didn't send me the email and they didn't deliver it to my home either.
* The package was in the nearest DHL office.
* Sometimes when they try to deliver the package and I'm not home. Or when the courier ignores delivering the package they leave it in that office. in this case I believe the courier didn't try to deliver it in the first place. because I'm 24/7 at home for the past days.
* I got the package from the office and it was in a good condition.

# The packaging

![IMG_20220305_162306.webp](/images/IMG_20220305_162306.webp)
![IMG_20220305_162323.webp](/images/IMG_20220305_162323.webp)

* It's package is styled with Grey paper material and a texture that matches the tablet screen color and the pen material
* The package used only greys and black. no colors. it's a matching design to the device itself
* The tablet and USB type C to USB A flat cable is included in one package, and the pen is in another package + a card that holds a set of pen nips replacements.

# Material/Hardware

![IMG_20220305_162402.webp](/images/IMG_20220305_162402.webp)

* I loved the choice of a flat cable instead of the normal ones. it matches the flat design of the tablet itself.
* Pen material is not slippery. it's a material that feels like compressed paper. it feels good in the hand. and the weight is perfect. and the weight is distributed along the pen. so it's not heavier on one side that the other.
* I found the charger socket abit loose. when the cable is inserted it can be tilted as far as 20 degrees up or down freely.
* the tablet has 4 rubber pads on the back. I noticed it stops the tablet from moving on the desk. it's a nice detail in the design of this tablet that I loved.
* There are pins on the side of the tablet. near the USB-c socket. it's not documented and there are no accessories announced to use it.
* I noticed some degradation to the pen nip after couple days.

# Screen

* The screen has ghosting issue, flipping through pages of a notebook will cause ghosting. also opening and closing the toolbar will do. especially when using Grey colored brush on the page. I believe it's a general issue with E-Ink screens.

![IMG_20220228_142607.webp](/images/IMG_20220228_142607.webp)
![IMG_20220228_142501.webp](/images/IMG_20220228_142501.webp)

* I found some issues with the screen. Writing in one place and the line appears far from the tip. maybe a millimeter. it's annoying. and it happens in an area or two. the rest of the screen is perfectly calibrated. and I found that other people are complaining from the same issue on Reddit and Github issues.

# Software

It's Important to say I'm left handed and I write in Arabic. which I believe a very narrow use segment of the Remarkable 2 users. so I expected to hit more edge cases that the usual user.

* I had some concerns regarding me using my left hand but the system allow you to choose which hand you're using and it will switch the interface toolbar to the other side.
* I also had other concerns writing in Arabic script. I found that writing in Arabic is no different than English with some caveats. the keyboard doesn't have Arabic layout. And you can't convert Arabic writing to text.
* My experience when I opened the system was amazing. they had an onboarding tutorials and screens that was very helpful learning how the interface works. gestures and everything.
* I loved the writing experience. it felt like writing on paper. similar friction between pen nip and the screen. and there is no noticeable latency.
* Palm rejection overall is good. but I got some false positives. were I'm trying to open the toolbar while resting my palm on the screen.
* When creating a notebook you can choose the page template. Remarkable has many template, lined, squared, dotted, day planner, week planner, music sheet, Cornell. I loved this part. I usually use the small lined page with a margin.
* to draw a notebook cover I used 3 layers, one for fill, another for stroke and a third for highlight marks. when I merged the highlight to the stroke it worked perfectly. but then when I merged the result to the fill it didn't really work correctly.
* I was surprised to find that the operating system is Linux. and the kernel version/configuration is on their [GitHub page](https://github.com/reMarkable/linux). and there are discussions in the issues related to how to improve it and other stuff. I was very happy to see that.
* Also found that they have a lot of other repositories related to PDF rendering. pixels processing...etc
* And I found that they provide SSH username and password in the Help section of the device. which I can use to SSH to the device.
* When SSHing I found they included VIM configuration, bashrc file and changed the prompt and the login welcome text to be colorful. they didn't just throw in the SSH server and call it a day. That was great experience.
* Trying to print a writing that uses ballpen brush. the print looked exactly as if I used a real black ballpen. there is a distinct pattern to the end of the line that you can recognize if you looked closely.
* They have a desktop application for windows and MacOS (no application for Linux). it's simple and fast. I loved the simplicity. And the screenshare feature was hassle free. I loved it.
* The only comment on the desktop application and the mobile application is that it renders the pages with anti-aliasing off. so lines looks pixelated on mobile and desktop. while it's smooth on the tablet.
* I found brushes were perfect. ballpen is the one I use the most. then the marker for headings. except for the calligraphy. it doesn't seem to work as I expect. not like the Arabic calligraphy "feather" maybe I'm confusing it with another brush.
* The browser extension allow sending the current tab to the tablet as a file. I found that from chrome if I have a PDF in a tab. clicking the extension icon sends the file to the tablet. it was a nice hassle free experience. and fast.

# Cloud/Web interface

* When I bought the tablet it created an account for me with email + password
* And when the tablet arrive I logged in with gmail Single Sign On (SSO) and linked my tablet and the browser extension and the mobile app
* But then when i went to the account with email + password I found it was empty. then I realized there are two accounts for my email. one with SSO and another for email + password.
* I found that my SSO account was old. too old that my cloud subscription says "free" which I believe means that I have access for free forever. because I'm one of the people that created the account years ago.
* There is a feature to send the page from the tablet to an email. and it doesn't need access to your email. So that means they're using their own servers to send the email. I want to see how this will scale in the future.


# Conclusion

* I'm happy with the device and the system.
* It delivers on my expectation. I wanted a distraction free hassle free device and OS and that's what I got.
* The quality of the hardware and the OS is very high on my scale and I want to thank everyone that contributed to deliver this product.

# Update

* After using the tablet for couple weeks I tried to draw lines. simple ruler and pencil stright line. I decided that because I found that sometimes I write and the line is far away from the tip of the pencil. so I wanted to make sure I'm not crazy. and the [result looked bizarre](https://twitter.com/emad__elsaid/status/1501563386974322688/photo/1)
* So I contacted the support and they asked for the same result but with a recorded video. so I did. 
* They asked to send the tablet back for repair. and after couple weeks I got a replacement tablet.
* When I tried the same experiment on it. it worked perfectly. but still I feel that my writing is somehow odd. I can't articulate it but it feels that the first tablet got writing and not stright lines. the second got straight lines but slightly worse writing.
