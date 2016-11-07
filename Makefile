cc = elm make
src = src
dist = dist
public = public
main = $(src)/Main.elm
output = $(dist)/elm.js
index = index.html

build : install clean copy
	$(cc) $(main) --output $(output)

run : dist
	open $(dist)/$(index)

clean :
	rm -rf $(dist)
	mkdir $(dist)

copy :
	cp -R $(public)/* $(dist)

install :
	elm package install -y
