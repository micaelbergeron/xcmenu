# xcmenu - lightweight clipboard manager for X
# See LICENSE file for copyright and license details.

include config.mk

SRC = xcmenu.c
OBJ = ${SRC:.c=.o}

all: options xcmenu

options:
	@echo xcmenu build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC $<
	@${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	@echo creating $@ from config.def.h
	@cp config.def.h $@

xcmenu: ${OBJ}
	@echo CC -o $@
	@${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f xcmenu ${OBJ} xcmenu-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p xcmenu-${VERSION}

	@cp -R LICENSE Makefile README config.def.h config.mk \
		${SRC} get_targets.py xcmenu-${VERSION}
	@tar -cf xcmenu-${VERSION}.tar xcmenu-${VERSION}
	@gzip xcmenu-${VERSION}.tar
	@rm -rf xcmenu-${VERSION}

install: all
	@echo installing executable file to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f xcmenu xcmenuctrl ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/xcmenu
	@chmod 755 ${DESTDIR}${PREFIX}/bin/xcmenuctrl

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/xcmenu
	@rm -f ${DESTDIR}${PREFIX}/bin/xcmenuctrl

.PHONY: all options clean dist install uninstall
