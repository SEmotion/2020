# SEmotion Website

Website for the Workshop on Emotion Awareness in Software Engineering

# Prerequisites

Before building the site from Markdown, make sure that you have installed
[GNU make](https://www.gnu.org/software/make/) and
[Pandoc](http://pandoc.org/installing.html).  You can check your installs by
running the commands `make --version` (or possibly `gmake --version`) and
`pandoc --version` on the command line.

# Building

At the command line, `cd` into the repository's root directory and run GNU make
(depending on your installation, the command with either be `make` or `gmake`).

# Deploying

If you have SSH access to the server, the makefile can deploy the website
automatically.  First, open the Makefile and set the variables `USERNAME`,
`HOSTNAME`, `HOME_DIRECTORY`, and `PUBLISHED_DIRECTORY` to match the server.

Then, if you have an SSH key at `~/.ssh/id_rsa.pub` on your local machine, you
can add that key as trusted by running `make authorization` (or `gmake
authorization`) and entering the server account's password twice.  Otherwise you
will have to enter the password every time you want to deploy.

To deploy the site, simply run `make deploy`.
