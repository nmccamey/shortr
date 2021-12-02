> Context: Imagine that It's the summer of 2006. Twitter launched just a few months ago, and "tweeting" has
> become all the rage.

> You: You're a CS undergrad at Stanford University, and you love to tweet all day long with your friends, especially
> when you're in class. One thing you find that you're doing a lot is sharing a lot of URLs. Cool blogs you've read and
> links to funny cat pictures. But URLs are long and don't leave much room for anything else in your tweet. One
> day, you go to paste a Google Maps URL or New York Times article into a tweet, and BAM! You're already over
> the 140 character limit. You think: "there's got to be a better way."

> Your big idea: You decide to architect and build the world's first URL shortening service. This is going to be your
> big start-up idea. You're going to be rich, or at least internet-famous. You have your laptop, $100 (for cloud
> hosting, and for GoDaddy to register a domain) and a free weekend. "That's all an entrepreneur needs these
> days," you think.


## Overview
Given the calls to 2006, I decided to try to name this something that would fit the time. I came up with shortr, only to
discover that shorter is a URL shotening service. I'll stick with the name for now. 

This project is written in Perl (5.32) and uses the Mojolicious web framework. I chose Mojo because it is relatively
easy to get projects going. I also like that you do not need to install a lot of extra dependencies / modules.

The project consists of a single web server. At the moment, the docker will run the morbo command, which should only be
used for development. For dev/stage/prod, we should consider putting several docker instances behind a load balancer
and set up auto-scaling. 

When the application is started, users can visit L<http://localhost:3001/>. This page allows them to type in a URL 
that they need shortened. Once the form is submitted, the shortened URL is returned to the user. This is a simple 
page and it just sends a POST request to the server to get the shortened URL. The shortened URLs currently return as 
http://localhost:3001/[token]. The webserver handles these requests and sends a redirect to the browser. In the event
of an error, a 404 page is shown.

## Installation
In order to run this application, you need to have docker and docker-compose available. There are only two docker
containers - 1 for the app and 1 for the database. For most users running this locally, installing Docker Desktop 
has everything you need.

After you clone the repository:
- Run `docker-compose build` from the root directory to build the containers.
- Run `docker-compose up` to start the containers. If you add a `-d`, this will put your process in the background.
  Otherwise, this will run in the foreground and will output logs to the terminal
- To initialize the database run: `docker exec -i shortr-mysqldb-1 mysql -ppassword < 01-url-schema.sql`
    - NOTE that your mysql docker container might be named something different depending on your version.
      If this fails, locate the correct container name by doing `docker ps`
    - The database is setup to persist after the docker container restarts so only run this command if 
      you wish to remove any data currently in the database. 
    - This SQL file will create the database and tables. There is not any seed data currently
- After this, it should be up and running
