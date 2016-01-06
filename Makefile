# for 64bit centos + 32bit free kdb only (tested only on centos 7)
KXVER:=3

# change below to where you put your downloaded and unzipped python2.7 dir
PYTHON32_SRC_DIR:=/var/tmp/Python32/Python-2.7.7
QBITS:=l32
PYQ_SRC_DIR:=$(PWD)

install/pyq:
	mkdir -p $@

install/bin:
	mkdir -p $@

install/pyq/py.so: src/pyq/py.c|install/pyq
	gcc -o $@ -shared -fPIC -m32 -DKXVER=$(KXVER) $<

install/pyq/_k$(KXVER).so: src/pyq/_k.c
	gcc -o $@ -shared -fPIC -m32 -DQVER=$(KXVER) -DKXVER=$(KXVER) -I$(PYTHON32_SRC_DIR)/Include -I$(PYTHON32_SRC_DIR) $<

install/bin/pyq:src/pyq.c|install/bin
	gcc -o $@ -DQBITS="\"$(QBITS)\"" -DPYQ_SRC_DIR="\"$(PYQ_SRC_DIR)\"" -DPYTHON32_SRC_DIR="\"$(PYTHON32_SRC_DIR)\"" -m32 $<

libs: install/pyq/py.so install/pyq/_k$(KXVER).so

bins: install/bin/pyq

scripts:|install/pyq
	cp src/pyq/*.py install/pyq/
	cp src/pyq/*.q install/pyq/

all:libs bins scripts
