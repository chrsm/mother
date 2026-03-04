--- frontmatter ---
title: 'Eval Test'
date: '2026-04-20'
slug: 'eval-test'
---/ frontmatter ---

Testing eval code blocks

simple:

```yue!
21 * 2
```

String generation:

```yue!
items = { 'apple', 'banana', 'cherry' }
table.concat items, ' | '
```

Regular code block (not evaluated):

```yue
this_is_not = 'evaluated'
```
