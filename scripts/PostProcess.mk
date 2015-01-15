


SOLNS=$(wildcard $(TEST)*.pyfrs)
VTUS=$(SOLNS:.pyfrs=$vtu)


MAKEFILE=$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
ROOT=$(dir $(shell readlink -f $(MAKEFILE)))
TESTSDIR=$(ROOT)/../Tests
PLOTTERS=$(subst plot-,,$(notdir $(wildcard $(TESTSDIR)/$(TEST)/postProcessScripts/plot-*)))


PNGS=$(foreach p,$(PLOTTERS),$(foreach s,$(basename $(SOLNS)),$(p)-$(s).png))

.PHONY:all
all:$(PNGS)
	

%.vtu:%.pyfrs
	(\
		source $(WD)/installRoot/bin/activate	;\
		pyfr-postp convert $(TEST).pyfrm $< $@ 		;\
	)

.SECONDEXPANSION:
%.png:
	#$$(lastword $$(subst -, ,$$(basename $$@))).vtu $(TESTSDIR)/$(TEST)/postProcessScripts/plot-$$(firstword $$(subst -, ,$$(basename $$@)))
	echo $@ $(lastword $(subst -, ,$(basename $@))).vtu $(TESTSDIR)/$(TEST)/postProcessScripts/plot-$(firstword $(subst -, ,$(basename $@)))
	#$(word 2,$^) -i $(word 1,$^) -o $@
