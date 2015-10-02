all: doc test

doc: doc/manual.six

doc/manual.six: makedoc.g maketest.g ListOfDocFiles.g \
		PackageInfo.g \
		doc/HomalgToCAS.bib doc/*.xml doc/*.css \
		gap/*.gd gap/*.gi
	        gap makedoc.g

clean:
	(cd doc ; ./clean)

test:	doc
	gap maketest.g

archive: test
	(mkdir -p ../tar; cd ..; tar czvf tar/HomalgToCAS.tar.gz --exclude ".DS_Store" --exclude "*~" HomalgToCAS/doc/*.* HomalgToCAS/doc/clean HomalgToCAS/gap/*.{gi,gd} HomalgToCAS/{CHANGES,PackageInfo.g,README,VERSION,init.g,read.g,makedoc.g,makefile,maketest.g,ListOfDocFiles.g})

WEBPOS=public_html
WEBPOS_FINAL=~/Sites/homalg-project/HomalgToCAS

towww: archive
	echo '<?xml version="1.0" encoding="UTF-8"?>' >${WEBPOS}.version
	echo '<mixer>' >>${WEBPOS}.version
	cat VERSION >>${WEBPOS}.version
	echo '</mixer>' >>${WEBPOS}.version
	cp PackageInfo.g ${WEBPOS}
	cp README ${WEBPOS}/README.HomalgToCAS
	cp doc/manual.pdf ${WEBPOS}/HomalgToCAS.pdf
	cp doc/*.{css,html} ${WEBPOS}
	rm -f ${WEBPOS}/*.tar.gz
	mv ../tar/HomalgToCAS.tar.gz ${WEBPOS}/HomalgToCAS-`cat VERSION`.tar.gz
	rm -f ${WEBPOS_FINAL}/*.tar.gz
	cp ${WEBPOS}/* ${WEBPOS_FINAL}
	ln -s HomalgToCAS-`cat VERSION`.tar.gz ${WEBPOS_FINAL}/HomalgToCAS.tar.gz
