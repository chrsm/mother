mother
======

`mother` is a static site generator written in [YueScript][1].


## Features

- yue-based templates with a functional html dsl
- yue frontmatter
- markdown content with extensions (strikethrough, codeblocks, definition lists, etc.)
- eval code blocks (`yue!`) - execute YueScript during build and insert the result
- posts and static pages with configurable permalinks


## Markdown

content files use markdown, powered by [lunamark][2]. 

these lunamark extensions are enabled by default:
- smart typography conversion (quotes, dashes, ellipses)
- `~~strikethrough~~`
- fenced code blocks with language hints
- definition lists
- footnotes
- superscript (`x^2^`) and subscript (`H~2~O`)


## Eval Blocks

you can execute YueScript during the build and insert the result into your content
using `yue!` code blocks:

~~~markdown
The answer is:

```yue!
21 * 2
```
~~~

this renders in the result as: `The answer is: 42`

the return value of the last expression is converted to a string and inserted. 
_ERRORS_ in eval blocks will fail the build.

regular `yue` code blocks (without `!`) render as normal syntax-highlighted code.


### Use cases

Generate content dynamically:

~~~markdown
```yue!
items = { 'one', 'two', 'three' }
"<ul>#{ table.concat ["<li>#{i}</li>" for i in *items], '' }</ul>"
```
~~~

Or compute values:

~~~markdown
Build date: ```yue!
os.date "%Y-%m-%d"
```
~~~

you have access to whatever libs you have locally, so go ham.


## Example


### Config (.mother.yue)

```moonscript
export default {
  base_url: 'https://example.com'
  title: 'My Site'
  description: 'A blog'
  language_code: 'en'

  menu: {
    { name: 'About', url: '/about/' }
    { name: 'Posts', url: '/' }
  }

  content_dir: 'content/posts'
  template_dir: 'templates'
  output_dir: 'out'
  permalinks: '/:year/:month/:day/:slug/'

  pages_dir: 'content/pages'
  pages_permalink: '/:slug/'
}
```


### Templates

`base.yue`
```moonscript
export default (opts, content_fn) ->
  text '<!DOCTYPE html>\n'
  html { lang: opts.site.language_code or 'en' }, ->
    head ->
      meta { charset: 'utf-8' }
      meta { name: 'viewport', content: 'width=device-width, initial-scale=1.0' }
      if opts.site.description
        meta { name: 'description', content: opts.site.description }
      title opts.page_title or opts.site.title
      link { rel: 'stylesheet', href: '/styles.css' }

    body ->
      nav ->
        h1 ->
          a { href: '/' }, opts.site.title
        ul ->
          for item in *(opts.site.menu or {})
            li ->
              a { href: item.url }, item.name

      content_fn!
```

`index.yue`
```moonscript
base = import_template 'base'

base { site: data.site, page_title: data.site.title }, ->
  section { id: 'content' }, ->
    ul { class: 'posts' }, ->
      for post in *data.posts
        li ->
          h2 ->
            a { href: post.permalink }, post.meta.title
          div { class: 'date' }, post.meta.date
```

`post.yue`
```moonscript
base = import_template 'base'

base { site: data.site, page_title: data.post.meta.title }, ->
  article ->
    h1 data.post.meta.title
    div { class: 'date' }, data.post.meta.date
    div { class: 'content' }, ->
      text data.post.body

    nav { class: 'post-nav' }, ->
      if data.prev_post
        a { href: data.prev_post.permalink }, "< #{data.prev_post.meta.title}"
      if data.next_post
        a { href: data.next_post.permalink }, "#{data.next_post.meta.title} >"
```

`page.yue`
```moonscript
base = import_template 'base'

base { site: data.site, page_title: data.page.meta.title }, ->
  article ->
    h1 data.page.meta.title
    div { class: 'content' }, ->
      text data.page.body
```

### Content

`content/posts/hello_world.md`
```markdown
--- frontmatter ---
title: 'Hello World'
date: '2024-01-10'
slug: 'hello-world'
---/ frontmatter ---

wowza **first post**

- this
- is
- a markdown
- LIST
```

`content/pages/about.md`
```markdown
--- frontmatter ---
title: 'About'
slug: 'about'
---/ frontmatter ---

# About Me

idk man
```


[1]: https://yuescript.org
[2]: https://github.com/jgm/lunamark
