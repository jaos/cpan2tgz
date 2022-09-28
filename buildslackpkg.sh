#!/bin/sh

DESTINATION=$PWD/pkg
VERSION=`grep VERSION cpan2tgz | awk '{print $4}'|cut -f2 -d\'`
PKGNAME=cpan2tgz

perl Makefile.PL
make
chown -R root:root .
find . -perm 777 -exec chmod 755 {} \;
find . -perm 555 -exec chmod 755 {} \;
find . -perm 444 -exec chmod 644 {} \;
find . -perm 666 -exec chmod 644 {} \;
find . -perm 664 -exec chmod 644 {} \;

make install DESTDIR=$DESTINATION

if [ ! -d "$DESTINATION" ]; then
	echo Failed to install to $DESTINATION
	exit
fi

(cd $DESTINATION && mkdir -p ./usr/doc/${PKGNAME}-${VERSION} )
find . -type f -iregex '.*readme.*' -o -iregex '.*change.*' -o -iregex '.*todo.*' -o -iregex '.*license.*' -o -iregex '.*copying.*' -o -iregex '.*install.*' -o -iregex '.*\.txt' -o -iregex '.*\.html' |xargs -r -iZ cp Z $DESTINATION/usr/doc/${PKGNAME}-${VERSION}

(
	cd $DESTINATION;
	find . | xargs file | grep 'executable' | grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null
	find . | xargs file | grep 'shared object' | grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null
	find ./usr/share/man/ -name '*.3' -exec gzip -9 {} \; 2> /dev/null
	find ./usr/share/man/ -name '*.1' -exec gzip -9 {} \; 2> /dev/null
	if [ -d ./usr/share/man ]; then
		mv ./usr/share/man ./usr
	fi
	if [ -d ./usr/bin ]; then
	  chown -R $(stat --format "%u:%g" /usr/sbin) ./usr/bin
		chmod 755 ./usr/bin/*
	fi
	chmod 644 ./usr/man/man?/*
	rmdir ./usr/share
	mkdir install

	PERLLOCALPOD=`find . -name perllocal.pod`
  if [ -n "$PERLLOCALPOD" ]; then
	  cat >./install/doinst.sh <<EOF
#!/bin/sh
cat >> ${PERLLOCALPOD/.\\//} <<PLP
EOF
	  cat $PERLLOCALPOD >>install/doinst.sh
	  echo "PLP" >>install/doinst.sh
	  rm $PERLLOCALPOD
  fi

	echo "perl" > ./install/slack-required

	cat >./install/slack-desc <<EOF
# HOW TO EDIT THIS FILE:
# The "handy ruler" below makes it easier to edit a package description.  Line
# up the first '|' above the ':' following the base package name, and the '|'
# on the right side marks the last column you can put a character in.  You must
# make exactly 11 lines for the formatting to be correct.  It's also
# customary to leave one space after the ':'.

          |-----handy-ruler------------------------------------------------------|
${PKGNAME}: ${PKGNAME} - create Slackware packages from CPAN Perl modules
${PKGNAME}:
${PKGNAME}: Packaged by cpan2tgz
${PKGNAME}:
${PKGNAME}: cpan2tgz by Jason Woodward <woodwardj at jaos dot org>
${PKGNAME}:
${PKGNAME}:
${PKGNAME}:
${PKGNAME}:
${PKGNAME}: https://software.jaos.org/
${PKGNAME}:
EOF
	makepkg -l y -c n ../${PKGNAME}-${VERSION}-noarch-1.txz
)

make distclean
rm -r $DESTINATION

