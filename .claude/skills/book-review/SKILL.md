---
name: book-review
description: Guide user through creating detailed reviews of books from their reading list
compatibility: opencode
metadata:
  workflow: interactive
  output: markdown
---

## What I do

I help you create comprehensive book reviews through an interactive process:

1. **Select a book** from your "Currently Reading" or current year "Reads" sections in Books.md
2. **Extract the exact title** as it appears in Books.md
3. **Guide you through review questions** one at a time
4. **Build the review** using the book-review-template.md
5. **Save to a file** named after the book title in the project root

## When to use me

Use this skill when you want to write a structured review of a book you've read or are currently
reading. I'll ask thoughtful questions to help you articulate your impressions, analysis, and
reflections.

## Workflow

### Step 1: Book Selection

Parse Books.md to find books under:
- `# Currently Reading`
- `# {CURRENT_YEAR} Reads` (use the current year)

Present a numbered list with title and author. Ask user to select by number.

### Step 2: File Preparation

Extract the exact `title:` field from the selected book block.

Generate filename:
- Use the EXACT title value from the book block
- Append `.md` extension
- Example: If title is "Red Rising", filename is "Red Rising.md"
- Example: If title is "The Hitchhiker's Guide to the Galaxy: A Trilogy in Five Parts", 
  filename is "The Hitchhiker's Guide to the Galaxy: A Trilogy in Five Parts.md"

Check if file exists in project root:
- If exists: read current content to preserve existing sections
- If not: load template from `book-review-template.md` in this skill directory

### Step 3: Guided Review Questions

Ask these questions ONE AT A TIME, allowing user to respond before proceeding:

1. **First Impression**: What were your initial thoughts when you started this book?
2. **Writing Style**: How would you describe the author's writing style?
3. **Core Ideas**: What are the main themes or ideas the book explores?
4. **What You Enjoyed**: What aspects did you find most engaging or valuable?
5. **Disappointments**: Were there any elements that fell short? (Optional, skip if none)
6. **Overall Rating**: On a scale of 1-5, how would you rate this book?
7. **Rating Justification**: Why did you give it this rating?
8. **Target Audience**: Who would benefit most from reading this book?
9. **Personal Reflection**: How has this book influenced your thinking or perspective?
10. **Key Takeaways**: What are the most important lessons or insights you gained?
11. **Memorable Quotes**: Any passages that stood out? (Optional)
12. **Additional Thoughts**: Any other observations or comparisons? (Optional)

### Step 4: Build Review

Replace placeholders in template:
- `{BOOK_BLOCK}` → the complete book block from Books.md (including ```book markers, title, author, and image)
- `{CURRENT_DATE}` → today's date in YYYY-MM-DD format
- `{RATING}` → numerical rating
- Fill each section with user's responses

Preserve any existing content not covered by the questions.

### Step 5: Save

Write the complete review to the generated filename in the project root.
Confirm to user that review has been saved.

## Additional Sections to Consider

You may suggest these optional sections based on the book type:

**For Fiction:**
- Pacing & Structure
- Character Development
- Emotional Impact

**For Non-Fiction:**
- Practical Application
- Evidence & Research Quality
- Accessibility

**Universal:**
- Rereadability
- Comparative Analysis (similar works)

## Important Notes

- Always use the EXACT title from Books.md (including special characters, series info)
- Use today's date in YYYY-MM-DD format
- Ask questions one at a time, wait for response
- Keep user's voice and phrasing intact—only fix obvious typos
- If updating existing review, preserve all existing content
- Template location: `book-review-template.md` in this skill's directory
