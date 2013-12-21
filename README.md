Description
===========

This is a script to see which pages on your wiki are not accessible
by means of following links. If you cannot get to it by clicking links
(starting from the Main Page), it shows up on the list.

Prereqs
=======
    npm install nodemw
    npm install coffee

Setup
=====
Simply rename the config file so it doesn't end in .dist, and customize it
to fit your specific setup. You will probably have to enable the MediaWiki
API on your wiki's backend.

Usage
=====
    coffee checkNav.coffee

Sample output
=============

```
The following pages are not linked to from the main page:
---------------------------------------------------------
3D Asset Standards
Camera Matching
Correspondence with Tony
JNGISL Village Area Camera Match Approvals
JNGISL village area Camera Match Approval Form
Programming Resources
Project Vision
Standards and Asset Pipeline
```

It's slow
=========

It can be slow; the bottleneck is in the data fetching though, not
the processing. It has to make n requests, where n is the number of pages on
the wiki. Our wiki is 135 pages and I timed this at running 41 seconds on a
Raspberry Pi.

Dude, CoffeeScript?
===================
I know, I know, I'm sorry. I just wanted to write it and be done with it.
CoffeeScript may have lame scoping, but it sure is terse compared to JS.
