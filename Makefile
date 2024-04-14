# See LICENSE file for copyright and license details
# slstatus - suckless status monitor
.POSIX:

include config.mk

REQ = util
COM =\
	components/battery\
	components/cat\
	components/cpu\
	components/datetime\
	components/disk\
	components/entropy\
	components/hostname\
	components/ip\
	components/kernel_release\
	components/load_avg\
	components/netspeeds\
	components/num_files\
	components/ram\
	components/run_command\
	components/swap\
	components/temperature\
	components/uptime\
	components/user\
	components/volume\
	components/wifi

all: slstatus

$(COM:=.o): config.mk $(REQ:=.h) slstatus.h
slstatus.o: slstatus.c slstatus.h config.h config.mk $(REQ:=.h)

.c.o:
	$(CC) -o $@ -c $(CPPFLAGS) $(CFLAGS) $< -fPIC

config.h:
	cp config.def.h $@

slstatus: slstatus.o $(COM:=.o) $(REQ:=.o)
	$(CC) -shared -o libslstatus.so $(LDFLAGS) $(COM:=.o) $(REQ:=.o) slstatus.o $(LDLIBS)

clean:
	rm -f libslstatus.so slstatus.o $(COM:=.o) $(REQ:=.o) slstatus-${VERSION}.tar.gz

dist:
	rm -rf "slstatus-$(VERSION)"
	mkdir -p "slstatus-$(VERSION)/components"
	cp -R LICENSE Makefile README config.mk config.def.h \
	      arg.h slstatus.h slstatus.c $(REQ:=.c) $(REQ:=.h) \
	      slstatus.1 "slstatus-$(VERSION)"
	cp -R $(COM:=.c) "slstatus-$(VERSION)/components"
	tar -cf - "slstatus-$(VERSION)" | gzip -c > "slstatus-$(VERSION).tar.gz"
	rm -rf "slstatus-$(VERSION)"

install: all
	mkdir -p "$(DESTDIR)$(PREFIX)/lib"
	cp -f libslstatus.so "$(DESTDIR)$(PREFIX)/lib"

uninstall:
	rm -f "$(DESTDIR)$(PREFIX)/bin/slstatus"

install-to-arch: PKGBUILD
	makepkg -i --asdeps
