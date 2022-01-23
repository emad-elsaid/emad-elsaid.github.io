---
title: A solution for implementing Bulma navigation bar for mobile with CSS only
image: /images/IMG_20211114_122104.webp
tags: CSS
---

Today I liked the Navigation bar design for [Linux.com](https://www.linux.com/) and I wanted to implement it for my blog. While doing so I remembered that bulma navigation bar will collapse the menu and show burger menu on mobile when clicked it shows the menu. The proposed solution on [bulma website](https://bulma.io/documentation/components/navbar/) uses javascript. I had a principle on this blog not to introduce a single line of Javascript and I want to keep it this way. So here is how I did it with only CSS.

1- I added a checkbox called `menu-switch` between `navbar-brand` and `navbar-menu`
1- In `navbar-brand` I replaced the burger menu `a` tag with `label` tag that toggles the checkbox.
1- CSS is added to select any `navbar-menu` that comes after a checked checkbox called `menu-swtich`. and hide the checkbox itself

Now clicking the burger menu will toggle the checkbox and the menu will be shown if the checkbox is checked.

```html
  <nav class="navbar" role="navigation" aria-label="main navigation">
      <div class="navbar-brand">
        <a class="navbar-item" href="/">Site name</a>
        <label for="menu-switch" class="navbar-burger" role="button" aria-expanded="false">
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
        </label>
      </div>

      <input id="menu-switch" name="menu-switch" type="checkbox"/>

      <div class="navbar-menu">
        <div class="navbar-end">
          <a href="/" class="navbar-item">Link1</a>
          <a href="/" class="navbar-item">Link2</a>
          <a href="/" class="navbar-item">Link3</a>
        </div>
      </div>
  </nav>
```

```css
#menu-switch {
 display: none;
}
#menu-switch:checked + .navbar-menu{
 display: block;
}
```

This solution partially solved my problem. it's missing one piece. In the original Javascript solution the `navbar-burger` gets a class `is-active` which changes the 3 lines to X sign. unfortunately I didn't find a suitable CSS selector to select the `navbar-burger` that comes in `navbar-brand` before a checked `menu-switch`. and even if the selector exists I still need to replicate all the CSS that applies on the `span` tags inside the burger menu to change them into an X.

So this solution is good enough. and you can find it in action if you're on a small screen on this page.

![Screenshot-2022-01-22_14-05-24.webp](/images/Screenshot-2022-01-22_14-05-24.webp)
![Screenshot-2022-01-22_14-05-30.webp](/images/Screenshot-2022-01-22_14-05-30.webp)
