
VIRTUALENV=virtualenv2

TESTS:=couette_flow_2d euler_vortex_2d
BACKENDS:=OpenMP CUDA OpenCL
SERIAL:=serial parallel
PRECISION:=dp sp



TESTDIR=Tests

CASE_TARGETS=$(foreach t,$(TESTS),$(foreach s,$(SERIAL),$(foreach p,$(PRECISION),$(foreach b,$(BACKENDS),__flags/create-$(t)-$(b)-$(s)-$(p)))))
RUN_TARGETS=$(foreach t,$(TESTS),$(foreach s,$(SERIAL),$(foreach p,$(PRECISION),$(foreach b,$(BACKENDS),__flags/run-$(t)-$(b)-$(s)-$(p)))))
POST_TARGETS=$(foreach t,$(TESTS),$(foreach s,$(SERIAL),$(foreach p,$(PRECISION),$(foreach b,$(BACKENDS),__flags/post-$(t)-$(b)-$(s)-$(p)))))


MAKEFILE=$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
ROOT=$(dir $(shell readlink -f $(MAKEFILE)))
TESTSDIR=$(ROOT)/../Tests


.PHONY:all
all:



.PHONY:installRoot
installRoot:__flags/installRoot

__flags/installRoot:
	echo "'begin-install-virtualenv': '$$(date +%Y-%m-%d_%H:%M:%S)'," >>$(PWD)/__log
	$(VIRTUALENV) installRoot
	mkdir -p __flags
	touch $@
	echo "'end-install-virtualenv': '$$(date +%Y-%m-%d_%H:%M:%S)'," >>$(PWD)/__log



.PHONY:install
install:__flags/install


__flags/install:__flags/installRoot
	( \
		echo "'begin-install-pyfr': '$$(date +%Y-%m-%d_%H:%M:%S)'," >>$(PWD)/__log ;\
		source installRoot/bin/activate	;\
		cd PyFR				;\
		python2 setup.py install	;\
		echo "'end-install-pyfr': '$$(date +%Y-%m-%d_%H:%M:%S)'" >>$(PWD)/__log ;\
		echo "'begin-install-packages': '$$(date +%Y-%m-%d_%H:%M:%S)'," >>$(PWD)/__log  ;\
		pip install pycuda		;\
		pip install pyopencl		;\
		easy_install scons		;\
		echo $(PWD)/installRoot/lib/python2.7/site-packages/scons-2.3.4-py2.7.egg/scons-2.3.4 >> $(PWD)/installRoot/lib/python2.7/site-packages/scons.pth ;\
		echo "'end-install-packages': '$$(date +%Y-%m-%d_%H:%M:%S)'," >>$(PWD)/__log ;\
	)
	touch $@

.PHONY:createCases
createCases:__flags/createCases
__flags/createCases:__flags/install
	( \
		echo "'begin-create-cases': '$$(date +%Y-%m-%d_%H:%M:%S)'," >>$(PWD)/__log ;\
		source installRoot/bin/activate	;\
		make $(CASE_TARGETS)		;\
		echo "'end-create-cases': '$$(date +%Y-%m-%d_%H:%M:%S)'," >>$(PWD)/__log ;\
	)
	touch $@


__flags/create-%:
	(\
		source installRoot/bin/activate	;\
		t=$$(basename $@ | cut -d '-' -f 2 ) 	;\
		b=$$(basename $@ | cut -d '-' -f 3 ) 	;\
		s=$$(basename $@ | cut -d '-' -f 4 ) 	;\
		p=$$(basename $@ | cut -d '-' -f 5 ) 	;\
		mkdir -p $(TESTDIR)/$$t/$$b/$$s/$$p		;\
		cp $(TESTSDIR)/$$t/$$t.msh $(TESTDIR)/$$t/$$b/$$s/$$p/			;\
		$(ROOT)/getIni $$t $$b $$s $$p  1>$(TESTDIR)/$$t/$$b/$$s/$$p/$$t.ini	;\
		$(ROOT)/getRun $$t $$b $$s $$p	1>$(TESTDIR)/$$t/$$b/$$s/$$p/run	;\
		chmod +x $(TESTDIR)/$$t/$$b/$$s/$$p/run					;\
		ln -s $(ROOT)/SConstruct.PostProcess $(TESTDIR)/$$t/$$b/$$s/$$p/SConstruct		;\
		$(ROOT)/getPostProcess $$t $$b $$s $$p	1>$(TESTDIR)/$$t/$$b/$$s/$$p/postProcess	;\
		chmod +x $(TESTDIR)/$$t/$$b/$$s/$$p/postProcess	;\
	)
	touch $@


.PHONY:loadRuns
loadRuns:__flags/createCases
	(\
		echo "'begin-load-jobs': '$$(date +%Y-%m-%d_%H:%M:%S)'," >>$(PWD)/__log ;\
		source installRoot/bin/activate	;\
		make $(RUN_TARGETS)	&& make $(POST_TARGETS)	;\
		echo "'end-load-jobs': '$$(date +%Y-%m-%d_%H:%M:%S)'," >>$(PWD)/__log ;\
	)
	touch $@


__flags/run-%:
	(\
		source installRoot/bin/activate		;\
		t=$$(basename $@ | cut -d '-' -f 2 ) 	;\
		b=$$(basename $@ | cut -d '-' -f 3 ) 	;\
		s=$$(basename $@ | cut -d '-' -f 4 ) 	;\
		p=$$(basename $@ | cut -d '-' -f 5 ) 	;\
		ts $(TESTDIR)/$$t/$$b/$$s/$$p/run $(PWD)/$@;\
	)


__flags/post-%:
	(\
		source installRoot/bin/activate		;\
		t=$$(basename $@ | cut -d '-' -f 2 ) 	;\
		b=$$(basename $@ | cut -d '-' -f 3 ) 	;\
		s=$$(basename $@ | cut -d '-' -f 4 ) 	;\
		p=$$(basename $@ | cut -d '-' -f 5 ) 	;\
		ts $(TESTDIR)/$$t/$$b/$$s/$$p/postProcess $(PWD)/$@;\
	)


.PHONY:scheduleReportSend
scheduleReportSend:loadRuns
	ts ./prepareAndSendReport

