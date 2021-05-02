---
date: 2021-04-25 00:00
---

#  How I built my website - 2021 Version

I finally got around to building my website. It serves as a contact card to the world, and a place where I can blog about tech, music and personal rants.
It will (maybe?) eventually include my app portfolio, but that is not a priority at the moment.

> All the code to my website is **open source** and can be found on <a href="https://github.com/TheInkedEngineer/portfolio" target="_blank">github</a>

## Alternatives

I used to write my articles on `Medium` but it's safe to say they done fucked up so bad, no one likes that platform anymore. 
Their paywall is awful, and no one actually gets to read what you want to share easily.

The top alternatives where:

1. **<a href="https://world.hey.com" target="_blank">world.hey.com</a>** 
\
\
  A great solution if you're a less technical person, or all you're looking for is a blog to write down your ideas. It's super lightweight and a post is as easy as sending an email. 
  \
  \
  I did evaluate this option since I do own a `hey.com` email account, but there where two main problems: 
    - I wanted my landing page, and I might want to add a portfolio later. So hosting my blog there would've let to people leaving my website when reading an article. Or even worse, not knowing about it if I just share the URL of the article.
    - Lack of analytics.


2. **<a href="https://www.gatsbyjs.com" target="_blank">GatsbyJS</a>**
\
\
Gatsby sounded like a viable solution. I read great things about it online, and it covered the issues I had with *world.hey.com*, but for those who don't know,
<a href="http://www.ihatejavascript.com" target="_blank">I hate Javascript</a>.

\

## Technologies to build my website

I did not want to deal with HTML and Javascript. I'm not a big fan. I can manage, but if I can do without, I'd be happy. \
This is where John Sundell's <a href="https://github.com/JohnSundell/Publish" target="_blank">Publish</a>, <a href="https://github.com/JohnSundell/Plot" target="_blank">Plot</a>, and <a href="https://github.com/JohnSundell/Ink" target="_blank">Ink</a>,
comes into play.
By using these 3 open-source frameworks I was able to create my website using only Swift and plain old CSS. 
That meant less duplicate code, less typos, faster load times (it's a static website) and easier to evolve.

The website is powered by a theme. Publish comes with a default `.foundation` theme but it is super easy to replace and create your own, which I did.
Once you create it, publishing a new article is super easy, you just add a *Markdown* file in the *Content* folder under the right section, build and voilà your full website code can be found it the `Output` folder alongside an `RSS` feed, and a `sitemap`.

Analytics is powered by <a href="https://plausible.io/" target="_blank">Plausible</a>.  It's a privacy focused open-source saas analytics. It provides anonymous analytics that would help me better the blog without jeopardizing people's privacy. 

\

## Deploying

I host my website on DigitalOcean. Once I run the project, and the static website is generated, I run a small script I wrote, that pushes the changes to my server instantly. 

To learn more on how this is done checkout <a href="../deploy-a-website-using-git/" target="_blank">this article</a> I wrote.
