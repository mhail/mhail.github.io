---
layout: page
title: Welcome
tagline: You've Found My Blog
---
{% include JB/setup %}

<div class="jumbotron">
  <i class="fa fa-code fa-border fa-5x pull-right"></i>
  <h1>I'm a software developer</h1>
  <p>This blog is full of techno-jargon&#0153;</p>

</div>

## New Posts

<div class="blog-index">  
  {% for post in site.posts %}
  {% assign content = post.content %}
  {% include post_detail.html %}
  {% endfor %}
</div>
