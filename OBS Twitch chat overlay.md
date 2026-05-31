1. Add new Browser element
2. Use url: `https://www.twitch.tv/popout/<your-channel-name>/chat` 
3. Choose a good width and height. mine (400,400)
4. Use this CSS to hide all elements that are not needed

```css
body { background-color: rgba(0, 0, 0, 0.2) !important; overflow: hidden; }
.chat-room { background: transparent !important; }
.tw-root--theme-dark .chat-room { background: transparent !important; }
.consent-banner, .chat-input, .stream-chat-header,.tw-transition,.chat-line__status {display: none !important;}
```

Where `rgba(0,0,0,0.2)` is the background the 0.2 is the alpha value 0 transparent 1 opaque



