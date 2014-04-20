---
layout: page
title: Welcome
tagline: You've Found My Blog
---
{% include JB/setup %}

<div class="jumbotron">
  <h1>I'm a software developer</h1>
  <p>This blog is full of techno-jargon&#0153;</p>
</div>

## New Posts

<div class="blog-index">  
  {% assign post = site.posts.first %}
  {% assign content = post.content %}
  {% include post_detail.html %}
</div>
