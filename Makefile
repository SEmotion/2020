# Configuration

SHELL = bash

INFRASTRUCTURE = $(shell which pandoc || echo /usr/local/bin/pandoc)
DIRECTORIES = output

HTML_TEMPLATE = website/template.html

YEAR = 2019
USERNAME = $(shell git config --get user.name)
EMAIL = $(shell git config --get user.email)

# Default Target (must appear before rules for output files)

all:

# Output Files and Their Dependencies

OUTPUTS = \
	.htaccess \
	index.html \
	call.html \
	organization.html \
	program.html \
	keynote.html \
	invited_talk.html \
	past.html \
	index.css \
	montreal.jpeg \
	attendees.jpeg \
	bonita.png \
	davide.png \
	giuseppe.png \
	maital.png \
	robert.png \
	SEmotion19.pdf \

output/index.html:	website/index.md
output/call.html:	website/call.md
output/organization.html:	website/organization.md
output/program.html:	website/program.md
output/keynote.html:	website/keynote.md
output/invited_talk.html:	website/invited_talk.md
output/past.html:	website/past.md
SEmotion19.pdf:	website/SEmotion19.pdf

# Targets

.PHONY:	all deploy clean

all:	$(OUTPUTS:%=output/%)

deploy:	all
	(cd output; rm -rf .clone .git)
	(cd output; git clone -q "git@github.com:SEmotion/$(YEAR).git" .clone)
	(cd output; mv .clone/.git ./)
	(cd output; rm -rf .clone)
	(cd output; git config --local user.name "$(USERNAME)")
	(cd output; git config --local user.email "$(EMAIL)")
	(cd output; git add .)
	(cd output; git commit -m "Published snapshot as of $$(date +'%Y-%m-%d')." || true)
	(cd output; git push)
	(cd output; rm -rf .git)

clean:
	-rm -rf output/.git
	-rm -r $(DIRECTORIES)

# Acircularity Rules

$(HTML_TEMPLATE):
	true

# Infrastructural Rules

$(INFRASTRUCTURE):
	@echo 'This Makefile depends on PanDoc, which was not found; please install it.'
	false

$(DIRECTORIES):
	mkdir -p "$@"

# Other Rules

output/.htaccess:	website/.htaccess | $(DIRECTORIES)
	cp website/.htaccess "$@"

output/%.html:	$(INFRASTRUCTURE) $(HTML_TEMPLATE) | $(DIRECTORIES)
	pandoc --from markdown+fancy_lists+multiline_tables --to html5 --template $(HTML_TEMPLATE) --metadata lang=en --metadata title=ignored --variable page-$(@:output/%.html=%):"selected" --output "$@" $(filter %.md,$^)

output/%.css:	website/%.css | $(DIRECTORIES)
	cp $(@:output/%.css=website/%.css) "$@"

output/%.png:	website/%.png | $(DIRECTORIES)
	cp $(@:output/%.png=website/%.png) "$@"

output/%.jpeg:	website/%.jpeg | $(DIRECTORIES)
	cp $(@:output/%.jpeg=website/%.jpeg) "$@"

output/%.pdf:	website/%.pdf | $(DIRECTORIES)
	cp $(@:output/%.pdf=website/%.pdf) "$@"
