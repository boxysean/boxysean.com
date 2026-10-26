RUBY   ?= ruby
BUNDLE ?= bundle
SITE_SRC  = jekyll
SITE_DEST = jekyll/_site

# Every tracked file under jekyll/ that is not build output.
SOURCES := $(shell find $(SITE_SRC) -type f \
	-not -path '$(SITE_DEST)/*' \
	-not -path '$(SITE_SRC)/.jekyll-cache/*' \
	-not -path '$(SITE_SRC)/vendor/*')

.PHONY: all install build serve clean deploy deploy-preview

all: build

## Install the gems pinned in Gemfile.lock.
install:
	$(BUNDLE) install

## Build the site into jekyll/_site (the Netlify publish directory).
build: $(SITE_DEST)

$(SITE_DEST): $(SOURCES) Gemfile Gemfile.lock jekyll/_config.yml
	$(BUNDLE) exec jekyll build --source $(SITE_SRC) --destination $(SITE_DEST)

## Local preview on http://localhost:4000 with live reload.
serve:
	$(BUNDLE) exec jekyll serve --source $(SITE_SRC) --destination $(SITE_DEST) --livereload

## Deploy the built site to production on Netlify (needs NETLIFY_AUTH_TOKEN).
deploy: build
	netlify deploy --dir $(SITE_DEST) --prod

## Upload a draft deploy and print its preview URL.
deploy-preview: build
	netlify deploy --dir $(SITE_DEST)

clean:
	rm -rf $(SITE_DEST) $(SITE_SRC)/.jekyll-cache
