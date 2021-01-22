.PHONY: serve
serve:
	docker run --rm --volume="${PWD}/jekyll:/srv/jekyll" -it -p 4000:4000 jekyll/jekyll jekyll s

jekyll/_site:
	docker run --rm --volume="${PWD}/jekyll:/srv/jekyll" -it -p 4000:4000 jekyll/jekyll jekyll build

.PHONY: deploy
deploy: jekyll/_site
	aws s3 sync jekyll/_site/ s3://boxysean.com/
