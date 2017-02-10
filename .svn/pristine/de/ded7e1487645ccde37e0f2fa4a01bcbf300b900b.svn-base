PPLIB=../../PPLib

ifeq ($(PLATFORM),simulator)
CC=$(PLATFORM)-apple-darwin-gcc
AR=$(PLATFORM)-apple-darwin-ar
CFLAGS=-DTARGET_IPHONE_SIMULATOR
else
CC=arm-apple-darwin-gcc
AR=arm-apple-darwin-ar
endif

#CFLAGS+=-Wall -Werror -O7
CFLAGS+=-I$(PPLIB)/include

LDFLAGS=-lobjc -framework CoreFoundation \
        -framework Foundation -framework UIKit -framework QuartzCore \
        -framework CoreGraphics -framework OpenGLES \
		-framework MediaPlayer -framework AudioToolbox
LDFLAGS+=-lstdc++.6 -lgcc_s.1 -liconv.2 -lz -lxml2.2
LDFLAGS+=-L$(PPLIB)/lib


ifeq ($(PLATFORM),simulator)
APP=$(PPLIB)/simulator/libshow.a
else
APP=$(PPLIB)/lib/libshow.a
endif

APPOBJ=FileViewController.o

all: $(APP)

$(APP): $(APPOBJ)
#	$(CC) $(LDFLAGS) -o $@ $^
	$(AR) r $@ $^

%.o:	%.mm
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o:	%.cpp
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

%.o:	%.m
	$(CC) -c $(CFLAGS) -std=c99 $(CPPFLAGS) $< -o $@

%.o:	%.c
	$(CC) -c $(CFLAGS) -std=c99 $(CPPFLAGS) $< -o $@

clean:
	rm -f *.o

