<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8" />
<meta name="author" content="{{ site.meta.author.name }}" />
<meta name="keywords" content="{{ page.tags | join: ',' }}" />
<title>{{ site.name }}{% if page.title %} / {{ page.title }}{% endif %}</title>
<link href="http://{{ site.host }}/feed.xml" rel="alternate" title="{{ site.name }}" type="application/atom+xml" />
<link rel="stylesheet" type="text/css" href="/assets/css/site.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/code/github.css" />
{% for style in page.styles %}<link rel="stylesheet" type="text/css" href="{{ style }}" />
{% endfor %}
</head>

<body>

{% for item in site.posts %}
{{item.id}} <br />
{% endfor %}


<br/>
<br/>
<br/>

{{ site.posts[0].content }}
<h1>间隔sssssssssssssssssssssssssssssssssssssssssssss</h1>
{{ site.posts[1].content }}




TEST <br/>

{{ site.name }} <br/>
{{ site.source }} <br/>
<br/>
<br/>

layout:{{ site.posts[0].layout }} <br/>
title:{{ site.posts[0].title }} <br/>
category:{{ site.posts[0].category }} <br/>
url/:{{ site.posts[0].url }} <br/>
date:{{ site.posts[0].date }} <br/>
id:{{ site.posts[0].id }} <br/>
categories:{{ site.posts[0].categories }} <br/>
next:{{ site.posts[0].next }} <br/>
previous: not display <br/>
tags:{{ site.posts[0].tags }}



<br/>
<br/>
<br/>
1<br/>

{{ site.posts[0].content }}

2<br/>
{{ site.posts[0].html }}<br/>
<br/>
3<br/>
<br/>

{% for style in site.posts[1] %}
<br/>index: {{forloop.index}} <br/>
{{style}}
{% endfor %}

{{}}<br/>
{{}}<br/>
{{}}<br/>
{{}}<br/>

<br/>
<br/>
<br/>
<br/>


{% for style in site %}
{{style}} <br/>
{% endfor %}

TEST

</body>

</html>

