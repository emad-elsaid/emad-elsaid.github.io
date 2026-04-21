Update Books.md based on the user's reading status update: $ARGUMENTS

## Books.md location
`./Books.md`

## Cover image helper
Images live in `/home/emad/code/emad-elsaid.github.io/public/` named by SHA-256 of
their content. To fetch a cover for a new book, use this Python snippet:

```python
import hashlib, json
from urllib.request import urlopen, Request
from urllib.parse import quote

def fetch_cover(title, author=''):
    PUBLIC_DIR = './public'
    def get(url):
        try:
            r = urlopen(Request(url, headers={'User-Agent': 'BookCoverFetcher/1.0'}), timeout=10)
            return r.read(), r.headers.get('Content-Type','')
        except: return None, ''
    def save(data, ext='jpg'):
        import os
        h = hashlib.sha256(data).hexdigest()
        p = f'{PUBLIC_DIR}/{h}.{ext}'
        if not os.path.exists(p):
            open(p,'wb').write(data)
        return f'/public/{h}.{ext}'
    # Open Library by title+author
    import re
    clean = re.sub(r'\s*\([^)]*#\d+[^)]*\)', '', title).strip()
    for t in ([title, clean] if clean != title else [title]):
        q = quote(t)
        data, _ = get(f'https://openlibrary.org/search.json?title={q}&limit=1&fields=cover_i')
        if data:
            docs = json.loads(data).get('docs', [])
            if docs and docs[0].get('cover_i'):
                img, ct = get(f'https://covers.openlibrary.org/b/id/{docs[0]["cover_i"]}-L.jpg')
                if img and len(img) > 1000:
                    return save(img)
    return None
```

## Sections in Books.md (in order)
- `# Want to read`
- `# Currently Reading`
- `# {YEAR} Reads`  ← use current year for newly finished books
- `# Undated Reads`
- `# Tried to read and did not like it`

## Book block format
```
```book
title: <title>          ← wrap in double quotes if title contains : ' " # & * ! [ ] { }
author: <author>
image: /public/<sha256>.jpg
```
```

## Intent → action mapping

| What the user says | Action |
|---|---|
| "I'm reading / started / currently reading X" | Move book to `# Currently Reading` (or add if new) |
| "I finished / done with / completed X" | Remove from `# Currently Reading`; add to `# {YEAR} Reads` at the top of that section |
| "I want to read X" | Add to `# Want to read` |
| "I didn't like / gave up on / couldn't finish X" | Move/add to `# Tried to read and did not like it` |

## Steps

1. Parse `$ARGUMENTS` to extract the book title (and author if mentioned) and the intent.
2. Search Books.md for an existing entry matching that title (case-insensitive, partial match ok).
3. If found: remove the existing block from its current section.
4. If **not** found: fetch a cover image using the Python snippet above; construct a new block.
   - If no cover is found, omit the `image:` line rather than leaving it blank.
5. Insert the block into the correct target section per the mapping above.
   - For `# Currently Reading` and `# Want to read`: prepend (add after the section heading).
   - For `# {YEAR} Reads`: prepend within the section (most recent first).
   - For `# Tried to read and did not like it`: append.
6. Write the updated file.
7. Commit with message: `books: <one-line summary of the change>` and push.
