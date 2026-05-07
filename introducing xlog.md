# Introducing XLog: A Static Site Generator Built for Knowledge Bases

After years of trying different tools for my personal wiki, I built XLog - a static site generator specifically designed for knowledge bases, digital gardens, and personal wikis. Here's why it exists and what makes it different.

## The Problem

Most static site generators (Hugo, Jekyll, 11ty) are built for blogs and marketing sites. They're great at what they do, but they're not optimized for interconnected knowledge bases.

Cloud tools (Notion, Obsidian Publish) solve the knowledge base problem but lock you into their platforms. Your notes become dependent on their infrastructure, their pricing, their features.

I wanted something that combined the best of both worlds:
- **Local-first** like static generators (your data, your files)
- **Knowledge-base features** like cloud tools (backlinks, search, organization)

## What is XLog?

XLog is a fast, Git-native framework for building knowledge bases. It's written in Go and designed specifically for interconnected note-taking, not general websites.

**Key features:**

1. **Automatic Backlinks** - Mention a page name (`[[Page Name]]`) and XLog creates bidirectional links automatically. No manual link management.

2. **Desktop Editor Workflow** - Use Vim, VS Code, Emacs, or any text editor. Edit markdown locally with live preview in your browser.

3. **Git-Native** - Everything is markdown files in folders. Full version control, sync with Git, no database.

4. **37 Built-In Extensions** - Hashtags, search, todos, photos, and more. Knowledge-base features out of the box.

5. **Live Preview** - Save in your editor, instantly see changes in browser. No build step during writing.

## How It Works

### 1. Install (30 seconds)

```bash
go install github.com/emad-elsaid/xlog/cmd/xlog@latest
```

### 2. Create Your First Note

```bash
mkdir my-wiki
cd my-wiki
echo "# Welcome to My Wiki" > index.md
xlog
```

### 3. Open Browser

Visit http://localhost:3000 and see your note rendered.

### 4. Edit

Click "Edit" - opens the markdown file in your configured text editor. Make changes, save, and the browser updates instantly.

That's it. No complex configuration, no theme setup, no build process.

## Why Desktop Editors?

XLog intentionally doesn't include a browser-based editor. Instead, you edit in Vim, VS Code, Emacs, or whatever you prefer.

**Why?**

- **Editor freedom** - Use the tools you already know
- **Powerful editing** - Vim macros, VS Code extensions, Emacs org-mode
- **Offline-first** - Edit without internet
- **Git integration** - Built into your editor

The "Edit" button in XLog opens your desktop editor. You're editing local markdown files, just with a live preview in your browser.

## Automatic Backlinks in Action

This is XLog's killer feature. Write naturally and connections emerge:

```markdown
# Machine Learning Notes

I'm learning about [[Neural Networks]] and [[Decision Trees]].

Both relate to [[Supervised Learning]].
```

XLog automatically:
1. Creates clickable links to those pages
2. Shows on "Neural Networks" that this page links to it
3. Builds a knowledge graph of relationships

No manual link creation. No broken links when you rename files. Just write and connect.

## Digital Gardens, Not Blogs

XLog is optimized for digital gardens - interconnected, evolving notes rather than chronological blog posts.

**Good for:**
- Personal wikis
- Research notes with bidirectional links
- Digital gardens (learning in public)
- Technical documentation
- Zettelkasten-style note-taking

**Not good for:**
- Marketing websites
- E-commerce
- Multi-author publications
- Complex themes and layouts

If you're building an interconnected knowledge base, XLog is perfect. If you need a general website, use Hugo or Jekyll.

## Comparison

| Feature        | XLog              | Hugo/Jekyll    | Obsidian            | Notion             |
|----------------|-------------------|----------------|---------------------|--------------------|
| **Editing**    | Desktop editor    | Desktop editor | Desktop app         | Browser            |
| **Backlinks**  | Automatic         | Manual         | Automatic           | Manual             |
| **Storage**    | Local markdown    | Local markdown | Local markdown      | Cloud              |
| **Deployment** | Static HTML       | Static HTML    | Paid publish        | Cloud only         |
| **Speed**      | Fast (Go)         | Fast           | N/A                 | Depends on network |
| **Cost**       | Free, open-source | Free           | Free (publish paid) | Freemium           |

XLog sits between pure static generators (Hugo) and cloud tools (Notion), offering knowledge-base features with full data ownership.

## Who It's For

XLog is for developers and technical users who:

- ✅ Prefer markdown over proprietary formats
- ✅ Want Git version control for notes
- ✅ Need automatic backlinks and hashtags
- ✅ Like using their own text editor
- ✅ Value local-first, no vendor lock-in

XLog is **not** for users who:

- ❌ Need real-time browser collaboration
- ❌ Want WYSIWYG editing
- ❌ Require complex themes and CMS features
- ❌ Prefer all-in-one browser tools

## Real-World Usage

I use XLog for:

- **Personal wiki** - 2000+ interconnected notes on programming, books, ideas
- **Project documentation** - Technical docs with automatic backlinks
- **Learning journal** - Daily notes linked to concepts

The XLog documentation itself is built with XLog. Every page is interconnected, concepts link naturally, and the knowledge graph reveals relationships I didn't consciously create.

## Getting Started

**Documentation:**
- [Installation](https://github.com/emad-elsaid/xlog/blob/master/docs/Installation.md)
- [Workflow Guide](https://github.com/emad-elsaid/xlog/blob/master/docs/Workflow.md)
- [Backlinks](https://github.com/emad-elsaid/xlog/blob/master/docs/Backlinks.md)
- [Why XLog?](https://github.com/emad-elsaid/xlog/blob/master/docs/Why-XLog.md)

**Repository:**
- GitHub: https://github.com/emad-elsaid/xlog
- Stars welcome! ⭐

**Quick start:**

```bash
go install github.com/emad-elsaid/xlog/cmd/xlog@latest
mkdir my-notes && cd my-notes
echo "# Hello World" > index.md
xlog
```

Visit http://localhost:3000 and start building your knowledge base.

## The Philosophy

XLog is built on three principles:

1. **Filesystem-based** - Your notes are portable markdown files, not locked in a database
2. **Git-native** - Version control is part of the workflow, not an afterthought
3. **Editor-agnostic** - Use the tools you want, not what we force on you

I built XLog because I wanted a knowledge base tool that respects these principles while providing automatic backlinks and live preview. If you share these values, give XLog a try.

## Feedback Welcome

XLog is actively developed and open to feedback. If you try it:

- Open issues on GitHub for bugs or feature requests
- Star the repo if you find it useful
- Share your knowledge base experiences

I'm building XLog for people who value local-first, Git-native knowledge management. If that's you, welcome!

---

**Links:**
- GitHub: https://github.com/emad-elsaid/xlog
- Documentation: https://github.com/emad-elsaid/xlog/tree/master/docs
- Demo: https://xlog.emadelsaid.com (this documentation is built with XLog)

