cc = elm make
src = src
dist = dist
main = $(src)/Main.elm
output = $(dist)/elm.js
index = index.html

dist : clean install copy
	$(cc) $(main) --output $(output)

run : dist
	open $(dist)/$(index)

clean :
	rm -rf $(dist)
	mkdir $(dist)

copy :
	cp $(src)/$(index) $(dist)/$(index)

install :
	elm package install -y
