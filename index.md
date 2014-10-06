---
layout: page
title: Welcome
tagline:
icon: home
---
{% include JB/setup %}

<div class="jumbotron">
  <i class="fa fa-code fa-border fa-5x pull-right"></i>
  <h1>Random bits of logic</h1>
  <p>WARNING: This blog is full of techno-jargon&#0153;</p>

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
