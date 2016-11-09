cc = elm make
src = src
dist = dist
public = public
entry = $(src)/App.elm
output = $(dist)/elm.js
index = index.html

build : install clean copy
	$(cc) $(entry) --output $(output)

clean :
	rm -rf $(dist)
	mkdir $(dist)

copy :
	cp -R $(public)/* $(dist)

install :
	elm package install -y
