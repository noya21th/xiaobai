"""
你的第一个爬虫 — 小白陪你写的示例代码
Your First Scraper — Example code, built with xiaobai by your side

这段代码会抓取一个网页的所有标题。
别怕看不懂，每一行都有注释。
"""

import requests          # 帮你访问网页的工具，就像让程序替你打开浏览器
from bs4 import BeautifulSoup  # 帮你从网页里挑出想要内容的工具，就像一双筷子

# 你想抓哪个网页？把网址放这里
url = "https://news.ycombinator.com"

# 让程序去访问这个网址（就像你在浏览器里输入网址按回车）
response = requests.get(url)

# 把网页内容交给"筷子"，让它帮你挑东西
soup = BeautifulSoup(response.text, "html.parser")

# 找到所有的标题（class="titleline" 是这个网站标题的标记）
titles = soup.find_all("span", class_="titleline")

# 一条一条打印出来
print(f"\n(=^・ω・^=) 抓到了 {len(titles)} 条内容：\n")

for i, title in enumerate(titles, 1):
    link = title.find("a")
    if link:
        print(f"  {i}. {link.text}")

print(f"\n看吧，就这么简单。\n")
