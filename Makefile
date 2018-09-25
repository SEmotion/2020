# Configuration

SHELL = bash

INFRASTRUCTURE = $(shell which pandoc || echo /usr/local/bin/pandoc)
DIRECTORIES = output

HTML_TEMPLATE = website/template.html

USERNAME = semotion
HOSTNAME = cse.unl.edu
HOME_DIRECTORY = /home/grad/Classes/$(USERNAME)
PUBLISHED_DIRECTORY = $(HOME_DIRECTORY)/public_html

# Default Target (must appear before rules for output files)

all:

# Output Files and Their Dependencies

OUTPUTS = \
	.htaccess \
	index.html \
	call.html \
	organization.html \
	program.html \
	past.html \
	index.css \
	bonita.png \
	davide.png \
	giuseppe.png \

output/index.html:	website/index.md
output/call.html:	website/call.md
output/organization.html:	website/organization.md
output/program.html:	website/program.md
output/past.html:	website/past.md

# Targets

.PHONY:	all authorization deploy clean

all:	$(OUTPUTS:%=output/%)

authorization:	~/.ssh/id_rsa.pub
	scp ~/.ssh/id_rsa.pub "$(USERNAME)@$(HOSTNAME):$(HOME_DIRECTORY)/.ssh/$$(hostname)"
	ssh $(USERNAME)@$(HOSTNAME) "cat $(HOME_DIRECTORY)/.ssh/$$(hostname) >> $(HOME_DIRECTORY)/.ssh/authorized_keys; rm $(HOME_DIRECTORY)/.ssh/$$(hostname)"

deploy:	all
	(cd output; rsync -rptv . '$(USERNAME)@$(HOSTNAME):$(PUBLISHED_DIRECTORY)')
	ssh $(USERNAME)@$(HOSTNAME) 'chmod 755 $(PUBLISHED_DIRECTORY)'

clean:
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
