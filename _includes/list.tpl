{% include header.tpl %}

{% for post in list limit 10 %}
<article{% if forloop.index == 1 %} data-loaded="1"{% endif %}>
	<span class="datetime">{{ post.date | date: "%Y-%m-%d" }}</span>
	<a href="{{ post.url }}" style="font-size:120%;">{{ post.title }}</a>
	[<a href="/category/{{ post.category }}" class="category">{{ site.custom.category[post.category] }}</a>]
	<div class="article-content">
	{% if forloop.index == 1 and preview %}
		{{ post.content }}
	{% endif %}
	</div>
</article>
{% endfor %}

{% if list == null %}
<article class="empty">
	<p>该分类下还没有文章</p>
</article>
{% endif %}