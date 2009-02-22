PYTHON = python
ZIP = zip -r

LANG = ko

AFFIX = $(LANG).aff
DICT = $(LANG).dic

DICT_SOURCES = dict-$(LANG).xml

CLEANFILES = $(AFFIX) $(DICT)

DISTDIR = dist

PACKAGE = hunspell-dict-ko
VERSION = $(shell $(PYTHON) -c 'import config;print(config.version)')
RELEASETAG = HEAD

SRC_DISTNAME = hunspell-dict-ko-$(VERSION)
SRC_DISTFILE = $(DISTDIR)/$(SRC_DISTNAME).tar.gz
BIN_DISTNAME = ko-aff-dic-$(VERSION)
BIN_DISTFILE = $(DISTDIR)/$(BIN_DISTNAME).zip
BIN_DISTCONTENT = LICENSE LICENSE.GPL LICENSE.LGPL LICENSE.MPL $(AFFIX) $(DICT)

all: $(AFFIX) $(DICT)

$(AFFIX): make-aff.py config.py suffix.py suffixdata.py
	$(PYTHON) make-aff.py > $(AFFIX) || (rm -f $@; false)

$(DICT): $(DICT_SOURCES) make-dic.py config.py  suffix.py suffixdata.py
	$(PYTHON) make-dic.py $< > $@ || (rm -f $@; false)

distdir:
	if ! [ -d $(DISTDIR) ]; then mkdir $(DISTDIR); fi

clean: 
	rm -f $(CLEANFILES)
	rm -f $(DISTDIR)

dist:: distdir $(BIN_DISTCONTENT)
	git archive --format=tar --prefix=$(SRC_DISTNAME)/ $(RELEASETAG) | gzip -9 -c > $(SRC_DISTFILE)
	rm -f $(BIN_DISTFILE)
	mkdir -p $(BIN_DISTNAME)
	install -m644 $(BIN_DISTCONTENT) $(BIN_DISTNAME)/
	$(ZIP) $(BIN_DISTFILE) $(BIN_DISTNAME)
	rm -rf $(BIN_DISTNAME)

.PHONY: all clean dist distdir
