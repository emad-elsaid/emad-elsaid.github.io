![Grunewald, Berlin](/public/IMG_20220411_124305.webp)

I'm using [Bulma.io](https://bulma.io) for a while now. it's a beautiful CSS framework. My latest project Xlog uses Bulma. This project includes a **tools dialog**, using [Bulma Modal](https://bulma.io/documentation/components/modal/). That solution needed a lot of javascript behavior that should be possible with an HTML5 dialog tag. The following post describes how I simplified the solution and reduced the Javascript involved.

# Current solution

Copy pasta from Bulma Modal documentation got me something running that looks like this.

![](/public/262d6f4945da574da7d4496efe3c50cbc00c1641b9f5bbaafcbc98f87190afcd.png)

The code that powers it is a piece of HTML styles with Bulma classes

```html
<button class="button js-modal-trigger" data-target="modal-js">
  Tools: Ctrl+K
</button>

<div id="modal-js" class="modal" tabindex="0">
  <div class="modal-background"></div>

  <div class="modal-content">
    <div class="box">
      <aside class="menu">
        // Tools HTML here
      </aside>
    </div>
  </div>

  <button class="modal-close is-large" aria-label="close"></button>
</div>
```

And some javascript that show/hides the dialog

```js
 (function() {
     // Functions to open and close a modal
     function openModal($el) {
         $el.classList.add('is-active');
     }

     function closeModal($el) {
         $el.classList.remove('is-active');
     }

     function closeAllModals() {
         (document.querySelectorAll('.modal') || []).forEach(function($modal) {
             closeModal($modal);
         });
     }

     // Add a click event on buttons to open a specific modal
     (document.querySelectorAll('.js-modal-trigger') || []).forEach(function($trigger) {
         const modal = $trigger.dataset.target;
         const $target = document.getElementById(modal);

         $trigger.addEventListener('click', function() {
             openModal($target);
         });
     });

     // Add a click event on various child elements to close the parent modal
     (document.querySelectorAll('.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button') || []).forEach(function($close) {
         const $target = $close.closest('.modal');

         $close.addEventListener('click', function() {
             closeModal($target);
         });
     });

     // Add a keyboard event to close all modals
     document.addEventListener('keydown', function(event) {
         const e = event || window.event;
         const kCharCode = "K".charCodeAt();

         if (e.keyCode === 27) { // Escape key
             closeAllModals();
             return;
         }

         if ( e.keyCode === kCharCode && ( e.metaKey || e.ctrlKey ) ) {
             e.preventDefault();
             const $target = document.getElementById('modal-js');
             openModal($target);
             $target.focus();
         }

     });
 })();
```

I don't know about you but this solution looks too complicated. there are lot of Javascript at play here that we probably don't need it.

I tried to have an input to filter the tools at the top of the dialog and have it focused when the dialog appears. but that required more javascript. I know HTML5 has `autofocus` attribute that works with `dialog`. When the dialog is shown it will autofocus the input by default. so apparently I should turn around and use `dialog` tag and `autofocus` attribute.

# Use HTML5 dialog

HTML5 has a [dialog](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dialog) tag with some default behavior. So instead of using a Div tag I replaced it with `dialog`.

That means I can show and hide the dialog with `.showModal` and `.close` methods instead adding/removing `is-active` class.

When I did that the dialog didn't appear. so turns out Bulma `modal` class hides the dialog. The browser already does that. so no need to use Bulma `modal` class.

# Use form to hide dialog

To hide a dialog HTML offers another synergy with `form` tag. adding a form tag with `method="dialog"` and a button to submit it will hide it's parent dialog.

```html
<dialog id="tools-modal">
  <div class="modal-content">
    <div class="box">
      <aside class="menu">
        // TOOLS HTML HERE
      </aside>
    </div>
  </div>

  <form method="dialog">
    <button class="modal-close is-large" aria-label="close"></button>
  </form>
</dialog>
```

That changes the dialog look

![](/public/f4613cb791aa47010d2f771957fbab03e704e1a8a6d55ba340ee3bec62209795.png)

# Autofocus search input

I noticed that focus is set on the first item in the list. but this list will be longer so I need to have a search input at the top that gets the focus automatically and filter the following list.

Adding the following before the `aside` tag does the trick.

```html
      <div class="field">
        <div class="control">
           <input class="input" type="search" placeholder="Search..." autofocus/>
        </div>
      </div>
```

Showing the dialog focuses the input instead of the link:

![](/public/cf223146da47544814be291c6be932529b92dea6848a0cedde58699487133d1f.png)

# Cleaning up JS

There is so many in the original JS code to allow for multiple dialogs and hide the dialog when clicking different parts of the page when the dialog is open. I have one dialog here so lets clean it up.

```js
 const tools = document.getElementById('tools-modal');

 document.addEventListener('keydown', function(e) {
     const kCharCode = "K".charCodeAt();

     if (e.keyCode === 27) { // Escape key
         tools.close();
         return;
     }

     if ( e.keyCode === kCharCode && ( e.metaKey || e.ctrlKey ) ) {
         e.preventDefault();
         tools.showModal();
     }
 });
```

The button that shows the dialog was wired with the `openModal` function dynamically. there is also no need for that we can call `window.openToolsModal` in `onclick` attribute

```html
<button class="button" onclick="tools.showModal()">Tools: Ctrl+K</button>
```

# Searching tools list

I need to filter the list of items that shows under the input whenever the user writes a keyword. tools items are in `li` tags. so I created a function that takes a keyword and hide all `li` tags in the dialog that doesn't include this keyword.

```js
 function filterToolsList(v) {
     const keyword = v.toLowerCase();
     const lis = document.querySelectorAll("#tools-modal li");

     for(var i=0; i < lis.length; i++){
         const li = lis[i];
         if( li.textContent.toLowerCase().includes(keyword) ) {
             li.classList.remove("is-hidden");
         } else {
             li.classList.add("is-hidden");
         }
     }
 }
```

Then called it `onkeyup` of the search input.

```html
<input class="input" type="search" placeholder="Search..." onkeyup="filterToolsList(this.value)" autofocus/>
```

And to save myself some code I passed the input value directly as I don't need the keyup event nor the whole input element. I just needed the value of the input in this case so I passed exactly what I need.

# In action

<video controls src="/public/64d1966f4b320ce18276dfa72f14f5efd1d23a046c829d1382eb998b942ce4cd.webm"></video>



# Full code

The full implementation can be found on [xlog repository on github](https://github.com/emad-elsaid/xlog/blob/8a2ccdad730d1677016b50f513b4c8114e5d1e89/views/view.html). I tried to remove irrelevant HTML attributes and surrounding code in this post for simplification.
