## Boring Rails

Couple days ago [Amr](https://twitter.com/amrabdelwahab) shared a nice website called [Boring
Rails](https://boringrails.com/) that resonates with what I believe a simple way
to develop web applications that has less JavaScript fatigue.

I tend to minimize JavaScript on my websites to the point that sometimes I
remove JavaScript all together like on this blog.

The first article [Building GitHub-style Hover cards with StimulusJS and
HTML-over-the-wire](https://boringrails.com/articles/hovercards-stimulus/) talks
in details what's wrong with the modern culture of developing web
applications and the SPA frenzy going on.

Then the article went to implement hover cards with some tools, I believe that
the same feature can be delivered with less code, The following paragraphs will
walk you through implementing the same feature without any JavaScript
dependency.

## Write it in HTML

You'll need a simple HTML that shows/hides hovercards like so

![screenshot-hover-card.png](/images/screenshot-hover-card.png)

```html
<html>
  <style>
   .has-hover-card {
       display: inline-block;
       position: relative;
   }

   .hover-card {
       display: none;
       background: #ddd;
       border: 1px solid black;
       padding: 10px;
       position: absolute;
       top: 1em;
       left: 0;
       white-space: nowrap;
   }

   .has-hover-card:hover .hover-card {
       display: inline-block;
   }
  </style>
  <body>
    User:
    <span class="has-hover-card">
      Emad Elsaid
      <span class="hover-card">
        User: Emad Elsaid <br />
        Title: Software Engineer <br />
        Web: <a href="https://www.emadelsaid.com">emadelsaid.com</a>
      </span>
    </span>
    Has created a new repository, and 30 other actions.
  </body>
</html>
```

You can save this on your disk and open it in the browser, putting your mouse
over my name will show the card, and moving away will hide it, what make this
behavior possible is the `display` CSS property change when we hover on the
name, checkout the `Style` tag.

## Create a server

I'll use Ruby and Sinatra here so install Sinatra

```
$ gem install sinatra
```

Move your HTML page to `views/index.erb` and write a `server` file as follows

```ruby
#!/usr/bin/env ruby

require 'sinatra'
set :port, 3000

get '/' do
  erb :index
end
```

Make it executable

```
$ chmod +x server
```

And run it

```
$ ./server
```

It should listen on port 3000 so opening `localhost:3000` will show your page.

But as your page grows inserting the card for every name on the page will hurt
your performance, so to make this page faster we'll load only the card when the
user move on the name.

## Isolate the card to another page

Remove your hover card from the body and add a reference in the parent to the
URL that will return it from the server.

```html
User:
<span data-hover-card="/card/emad elsaid" class="has-hover-card">Emad Elsaid</span>
Has created a new repository, and 30 other actions.

<script type="text/javascript" src="/hovercard.js"> </script>
```

The endpoint can take the user name as a parameter as follows

```ruby
get '/card/:name' do
  erb :card, locals: { name: params[:name] }
end
```

And the card `views/card.erb` can print anything the server pass to it like
that:

```html
<span class="hover-card">
  User: <%= name %> <br />
  Title: Software Engineer <br />
  Web: <a href="https://www.emadelsaid.com">emadelsaid.com</a>
</span>
```

Now if you visit `localhost:3000/card/emad elsaid` it'll return the hover card
content.

## Load the card with JavaScript

We now need to load the card when hovering on any element with `data-hover-card`
attribute, we'll load it once in the page lifetime then append it to this
element.

your `hovercard.js` will look like that

```javascript
function loadCard(event) {
  let target = event.target;
  target.removeEventListener('mouseover', loadCard);
  let url = target.getAttribute('data-hover-card');

  fetch(url).then(function(response) {
    return response.text();
  }).then(function(html){
    target.insertAdjacentHTML('beforeend', html);
  });
}

let hasHoverCards = document.querySelectorAll('[data-hover-card]');
hasHoverCards.forEach(function(element) {
  element.addEventListener('mouseover', loadCard);
});
```

It'll attach a function to the `mouseover` of every element that has
`data-hover-card` attribute, the function will remove itself to avoid loading
the card twice.

Then we'll get the card from the server and append it to this element.

## Conclusion

This approach doesn't need Sinatra/ruby at all, any web server will work, it
doesn't depend on any JavaScript package, or other dependencies other than the
browser itself and CSS to show/hide the card.

You can generalize this technique to other things you want to fetch from the
server on click or any other event.
