---
layout: page
title: Welcome
tagline: You've Found My Blog
---
{% include JB/setup %}

Im a software developer, this blog is really techie.
If your not in to that sort of thing click here for [cats](http://cat-bounce.com).

<div class="blog-index">  
  {% assign post = site.posts.first %}
  {% assign content = post.content %}
  {% include post_detail.html %}
</div>
