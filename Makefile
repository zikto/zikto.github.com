all:
	jekyll build
	rsync -avr ../slate/build/ ./api
	jekyll serve 

clean:
	rm -rf _site

