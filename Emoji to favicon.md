#javascript 

The following JS function will: 

* Create a favicon from an emoji
* Change the current page favicon
* Remove the emoji from the page title if exists

```js
function setEmojiAsFavicon(emoji) {
  // Remove emoji from page title if exists
  document.title = document.title.replace(/^[\p{Emoji}\s]+/u, '').trim();

  // Create a canvas to draw the emoji
  const canvas = document.createElement('canvas');
  canvas.width = 16;
  canvas.height = 16;
  const ctx = canvas.getContext('2d');
  
  // Draw emoji, centered and scaled with transparent background
  ctx.font = '16px serif';
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  ctx.fillText(emoji, 8, 10);
  
  // Convert canvas to favicon
  const link = document.querySelector("link[rel~='icon']") || document.createElement('link');
  link.type = 'image/x-icon';
  link.rel = 'shortcut icon';
  link.href = canvas.toDataURL();
  
  // Append to head if not already there
  if (!document.querySelector("link[rel~='icon']")) {
    document.head.appendChild(link);
  }
}
``` 
