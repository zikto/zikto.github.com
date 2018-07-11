all:
	jekyll build
	mkdir -p _site/api
	rsync -avr ../slate/build/ _site/api/
	jekyll serve 

clean:
	rm -rf _site

