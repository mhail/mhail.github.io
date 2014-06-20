---
layout: page
title: Welcome
tagline: You've Found My Blog
icon: home
---
{% include JB/setup %}

<div class="jumbotron">
  <i class="fa fa-code fa-border fa-5x pull-right"></i>
  <h1>I'm a software developer</h1>
  <p>This blog is full of techno-jargon&#0153;</p>

</div>

<div class="blog-index">  
  {% for post in site.posts limit:3 %}
  {% assign content = post.content %}
  {% if forloop.index != 1 %}
  <hr/>
  {% endif %}
  {% include post_detail.html %}
  {% endfor %}
</div>
