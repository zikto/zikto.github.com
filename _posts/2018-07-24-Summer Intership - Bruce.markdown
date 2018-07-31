---
layout: post
title:  "Bruce's Summer Internship"
date:   2018-07-28 16:38:34 +0900
post_author : Bruce
categories: blog 
---
### Bruce's Summer Internship

안녕하세요, 
UC Berkeley에서 Computer science와 수학을 전공하고 있는 김승유라고 합니다. 
이번 여름에는 직토/인슈어리움의 개발자 팀에서 인턴을 하게 되었는데,
한국에서의 인턴은 복사와 커피 내리기만 하게 될 것이라는 제 주변 많은 사람들의 우려와는 달랐습니다. 
이 글은 직토에서 짧고도 긴 두달을 함께한 저의 이야기입니다.

Hi, my name is Bruce. 
I am a second year student at UC Berkeley majoring in computer science and mathematics. This summer, I worked as a software developer intern at Zikto. It’s not very uncommon to hear a discouraging testimony by a summer intern, especially by a student who just finished his first year of college. But If I expected to do the three C’s of stereotypical Korean interns - Copy, Coffee, and Cleaning - I was wrong. This is my experience at Zikto, during the long and short summer internship.

## Learning Collaborative Work
At Zikto, it mattered that everyone stayed on the same page. All members- CEOs, developers, designers, marketing team, and interns - had to share the same vision, mindset and values. For me, it started with reading the white papers. On the first day of work I was asked to read through not only Zikto’s white paper but also our competing companies’ documents. That week, I was exposed to the blockchain-based insurance protocol that was under development at Zikto. I joined a technical meeting after three days of review, where I shared my thoughts and questions regarding the white papers I had read. Throughout my time at Zikto, I frequently participated in development meetings. In it, I shared my progress and plans with all other developers, who often offered helpful advice. Sometimes we discussed our key policies, such as the methods for coordinating various interest groups participating in the Insureum protocol. I was given no less attention or opportunity than the rest of the developers in these meetings. Some of my most memorable moments in Zikto might be from these heated debates.

Using Phabricator was another big part of work collaboration at Zikto. Developers at Zikto are strong believers of work documentation, and they actively make use of the task management tool. Everyone shared their progresses on current tasks, results from resolved tasks, and the problems they encountered. I, too, contributed by sharing my projects, learnings, and tips on which pitfalls to avoid. In addition, I participated in the built-in “sprints,” a work-time management system. By logging the amount of time spent on a task, the developers attempt to measure and approximate the resources they need in completing their work. Each people knew how to portion their time, and transparently showed their work.

![Phabricator1]({{ site.url }}/img/phabricator1.png)
![Phabricator2]({{ site.url }}/img/phabricator2.png)

I found the task management tool useful. I could easily search for the error message I encountered, and portion my project into sizable units. Though not perfect, I practiced making approximations on the amount of time I will spend on a task. Through Phabricator, I even got the chance to follow along with the experiments that were being done by our core blockchain engineers. In fact, Phabricator is proving to be useful even as I write this blog post. Zikto values the work that lasts, and I learned the skills required of a professional developer while collaborating with rest of the team.

The second week into working at Zikto, I learned to use Git. To my shame, I had rarely used Git prior to coming to Zikto - all my projects in school were simple enough, and I wasn’t required to collaborate on a project with someone else for the most of the time. But in order to record my progress on my project, pull from previously existing repositories, and make sure I have a safe working “snapshot” to return to, using git was unavoidable.

At Zikto, I was never asked to know something superficially, even Git. Even though using git can be as simple as staging and committing most of the time, I learned to do more. Starting with the data structure, I had to form a clear image about Git’s inner mechanism. At the end of second week, I was able to to navigate through multiple branches, manage conflicts on merging/rebasing/pushing to remote repositories, and stash the working files. I wonder how long it would have taken me to realize the immense freedom that Git offers to programmers and its power in collaborative work had I not worked at Zikto.


## Projects at Zikto:  Growing Beyond a Coder

At school, my major CS projects were server-side programming with Python. Interestingly enough, I took part in front-end tasks at Zikto. Having had little to no understanding in languages and methods such as JavaScript, HTML, and CSS, I spent a lot of time lost in the new territory. After two months of struggle, however, JavaScript became a huge potential playground for me to experiment and fiddle with.

My projects at Zikto were targeted on a pilot project dealing with a parametric insurance. Parametric insurances work on a simple logic that makes a payment upon triggering of a conditional event. For instance, an insurance on natural disaster may promise to compensate the policyholders on occurance of an earthquake with magnitude greater than 7. At Zikto, we first experimented with a travel insurance on the Etherium network, which detail I cannot share at this time.By integrating Ethereum smart contract and insureum protocol into some of pre-existing insurances that dealt with simple conditions, we hoped to gain a better understanding of the smart contract's inner mechanisms.

My first task was gathering real-time public data from government-provided API into local MongoDB database using NodeJS. Though simple, it proved to be a challenging task because I had no background in asynchronous programming required by Javascript. It took a while to accept the fact that I cannot expect call-back functions to execute in order, until I learned about the Javascript event loop. Soon after, I was able to use event emitters to control the function flow. I also had little experience with MongoDB, a popular NoSQL database, but using it was not a big problem after I got a grasp in NodeJS.

Then, I worked on defining the front structure for the dashboard using Vue. In this page, I had to receive a date from the client and display the list of flights on the date to choose. I realized that CSS would not be something I could quickly make use of without experience. But sending simple events between html and javascript was something I could do after a day of looking into Vue, and I made the most basic components of the dashboard. I also wrote a JavaScript code that builds a database containing the list of flights on a specific date, and made it available using ExpressJS API. In building the database, I attempted to use the ES6 Promise and Async/Await coding style to define the control flow. A Promise object returning a "Promise" was not intuitive at all, but once I understood that it is no different from callback functions, I could make sense of it. Async/Await made things even better: Async programming that looks synchronous gave me much better control and confidence in using JavaScript.

### 채용공고
직토와 함께하실 개발자 분들을 찾고 있습니다.

career at zikto.com 으로 지원해주세요. 

[채용공고 바로가기](https://zikto.github.io/career/2018/07/24/%EC%B1%84%EC%9A%A9%EA%B3%B5%EA%B3%A0.html)
