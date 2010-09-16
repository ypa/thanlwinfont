# Copyright 2010 Keith Stribley http://www.thanlwinsoft.org/
#
# This Font Software is licensed under the SIL Open Font License, Version 1.1.
# This license is available with a FAQ at:http://scripts.sil.org/OFL
#
svg/%.svg : xslt/%.xslt xslt/param.xslt xslt/path.xslt blank.svg
	xsltproc -o $@ $< blank.svg
#	eog $@ &

svg/u1039_%.svg : xslt/%.xslt xslt/generateMedial.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o $(subst xslt/,tmp/u1039_, $<)  --stringparam base $(subst .xslt,,$(subst xslt/,,$<)) xslt/generateMedial.xslt blank.svg
	xsltproc -o $@  $(subst xslt/,tmp/u1039_, $<) blank.svg

svg/u1039_%_u102f.svg : xslt/%.xslt xslt/generateMedialu102f.xslt Makefile xslt/u102f_tall.xslt xslt/param.xslt
	mkdir -p tmp
	xsltproc -o $(subst .xslt,_u102f.xslt,$(subst xslt/,tmp/u1039_, $<))  --stringparam base $(subst .xslt,,$(subst xslt/,,$<)) xslt/generateMedialu102f.xslt blank.svg
	xsltproc -o $@  $(subst .xslt,_u102f.xslt,$(subst xslt/,tmp/u1039_, $<)) blank.svg

svg/u1039_%_u102d_u102f.svg : xslt/%.xslt xslt/generateMedialu102d_u102f.xslt Makefile xslt/u102f_tall.xslt xslt/u102d.xslt xslt/param.xslt
	mkdir -p tmp
	xsltproc -o $(subst .xslt,_u102d_u102f.xslt,$(subst xslt/,tmp/u1039_, $<))  --stringparam base $(subst .xslt,,$(subst xslt/,,$<)) xslt/generateMedialu102d_u102f.xslt blank.svg
	xsltproc -o $@  $(subst .xslt,_u102d_u102f.xslt,$(subst xslt/,tmp/u1039_, $<)) blank.svg

svg/u1039_%_u1030.svg : xslt/%.xslt xslt/generateMedialu1030.xslt Makefile xslt/u1030_tall.xslt xslt/param.xslt
	mkdir -p tmp
	xsltproc -o $(subst .xslt,_u1030.xslt,$(subst xslt/,tmp/u1039_, $<))  --stringparam base $(subst .xslt,,$(subst xslt/,,$<)) xslt/generateMedialu1030.xslt blank.svg
	xsltproc -o $@  $(subst .xslt,_u1030.xslt,$(subst xslt/,tmp/u1039_, $<)) blank.svg

svg/%_u1031.svg : xslt/%.xslt xslt/u1031.xslt xslt/eVowelCons.xslt Makefile xslt/param.xslt 
	mkdir -p tmp
	xsltproc -o $(subst .xslt,_u1031.xslt,$(subst xslt/,tmp/, $<))  --stringparam base $(subst .xslt,,$(subst xslt/,,$<)) xslt/eVowelCons.xslt blank.svg
	xsltproc -o $@  $(subst .xslt,_u1031.xslt,$(subst xslt/,tmp/, $<)) blank.svg


tests=xslt/corners.xslt

narrowCons:=u1001 u1002 u1004 u1005 u1007 u100e u1012 u1013 u1015 u1016 u1017 u1019 u101d
wideCons:=u1000 u1003 u1006 u100f u1010 u1011 u1018 u101a u101c u101e u101f u1021
otherCons:=u1008 u1009 u100a u100b u100c u100d u1014 u101b u1020
medialCons:= $(wideCons) $(narrowCons)
rotatedMedialCons:=u100b u100c u100d
tallCons:=u1008 u100b u100c u100d u1020
allCons:=$(wideCons) $(narrowCons) $(otherCons)
takesMedialEVowel:=$(wideCons) $(narrowCons)
takesYayit:=$(wideCons) $(narrowCons) u1014
takesKinzi:=u1000 u1001 u1002 u1003 u1018 u101c u101e
kinziVowel:=u102d u102e u1036
yapinVariants:=u103b u103b_u103d u103b_u103e u103b_u103d_u103e
afterMedials:=$(yapinVariants) u103d u103e u103d_u103e
lowerVowels:=u102f u1030

upperVowel:=u102d u102e u1032

font: thanlwin.sfd

thanlwin.sfd : svg $(wildcard python/*.py) $(wildcard svg/*.svg)
	python/thanlwinfont.py xslt/param.xslt "ThanLwin" thanlwin

svg: $(subst xslt,svg,$(wildcard xslt/u*.xslt) $(tests)) medials ereorder yayit yapin kinzi misc tallConsVowel

define rotatedMedial
svg/u1039_$(1).svg : xslt/$(1).xslt xslt/generateRotatedMedial.xslt Makefile xslt/param.xslt
	xsltproc -o tmp/u1039_$(1).xslt --stringparam base $(1) xslt/generateRotatedMedial.xslt blank.svg
	xsltproc -o $$@  tmp/u1039_$(1).xslt blank.svg
endef

$(eval $(call rotatedMedial,u100c))

define tallMedial
svg/u1039_$(1).svg : xslt/$(1).xslt xslt/generateTallMedial.xslt Makefile xslt/param.xslt
	xsltproc -o tmp/u1039_$(1).xslt --stringparam base $(1) xslt/generateTallMedial.xslt blank.svg
	xsltproc -o $$@  tmp/u1039_$(1).xslt blank.svg
endef

$(eval $(call tallMedial,u100b))

$(eval $(call tallMedial,u100d))

medials : $(patsubst %, svg/u1039_%.svg, $(medialCons) $(rotatedMedialCons)) $(patsubst %, svg/u1039_%_u102f.svg, $(medialCons)) $(patsubst %, svg/u1039_%_u102d_u102f.svg, $(medialCons)) $(patsubst %, svg/u1039_%_u1030.svg, $(medialCons)) narrowwidestack


ereorder:: $(patsubst %, svg/%_u1031.svg, $(allCons) u1029)

# $(patsubst %, svg/%_u103c_u1031.svg, $(wideCons) $(narrowCons)) $(patsubst %, svg/%_u103c_u1031_u102c.svg, $(wideCons) $(narrowCons)) $(patsubst %, svg/%_u103c_u103d_u1031.svg, $(wideCons) $(narrowCons)) $(patsubst %, svg/%_u103c_u103d_u1031_u102c.svg, $(wideCons) $(narrowCons)) $(patsubst %, svg/%_u103c_u103e_u1031.svg, $(wideCons) $(narrowCons)) $(patsubst %, svg/%_u103c_u103e_u1031_u102c.svg, $(wideCons) $(narrowCons)) $(patsubst %, svg/%_u103b_u1031.svg, $(takesMedialEVowel)) $(patsubst %, svg/%_u103b_u103d_u1031.svg, $(takesMedialEVowel) u1014 u100a u101b) $(patsubst %, svg/%_u103b_u103e_u1031.svg, $(takesMedialEVowel)) $(patsubst %, svg/%_u103b_u103d_u103e_u1031.svg, $(takesMedialEVowel)) $(patsubst %, svg/%_u103d_u1031.svg, $(takesMedialEVowel) u1014 u100a u101b) $(patsubst %, svg/%_u103e_u1031.svg, $(takesMedialEVowel) u1014 u100a u101b) $(patsubst %, svg/%_u103d_u103e_u1031.svg, $(takesMedialEVowel) u1014 u100a u101b) svg/u1005_u1039_u1006_u1031.svg svg/u1014_u1039_u1010_u1031.svg svg/u1014_u1039_u1012_u1031.svg svg/u1014_u1039_u1013_u1031.svg svg/u1017_u1039_u1017_u1031.svg svg/u1019_u1039_u1019_u1031.svg svg/u100b_u1039_u100c_u1031.svg

define eVowelYayit
svg/$(1)_u103c_u1031.svg : xslt/$(1).xslt xslt/u1031.xslt xslt/$(2).xslt xslt/eVowelYayitCons.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_u1031.xslt --stringparam yayit $(2) --stringparam base $(1)  xslt/eVowelYayitCons.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_u1031.xslt blank.svg
	
svg/$(1)_u103c_u1031_u102c.svg : xslt/$(1).xslt xslt/u1031.xslt xslt/$(2).xslt xslt/eVowelYayitCons.xslt Makefile xslt/param.xslt xslt/u102c.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_u1031_u102c.xslt --stringparam yayit $(2) --stringparam base $(1) --stringparam aVowel u102c xslt/eVowelYayitCons.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_u1031_u102c.xslt blank.svg
	
ereorder::svg/$(1)_u103c_u1031.svg svg/$(1)_u103c_u1031_u102c.svg
endef

$(foreach cons,$(wideCons),$(eval $(call eVowelYayit,$(cons),u103c_wide)))

$(foreach cons,$(narrowCons),$(eval $(call eVowelYayit,$(cons),u103c_narrow)))

define eVowelYayitWasway
svg/$(1)_u103c_u103d_u1031.svg : xslt/$(1).xslt xslt/u1031.xslt xslt/$(2).xslt xslt/eVowelYayitCons.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_u103d_u1031.xslt --stringparam yayit $(2) --stringparam base $(1)  xslt/eVowelYayitCons.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_u103d_u1031.xslt blank.svg
	
svg/$(1)_u103c_u103d_u1031_u102c.svg : xslt/$(1).xslt xslt/u1031.xslt xslt/$(2).xslt xslt/eVowelYayitCons.xslt Makefile xslt/param.xslt xslt/u102c.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_u103d_u1031_u102c.xslt --stringparam yayit $(2) --stringparam base $(1) --stringparam aVowel u102c xslt/eVowelYayitCons.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_u103d_u1031_u102c.xslt blank.svg

ereorder :: svg/$(1)_u103c_u103d_u1031.svg svg/$(1)_u103c_u103d_u1031_u102c.svg
endef

$(foreach cons,$(wideCons),$(eval $(call eVowelYayitWasway,$(cons),u103c_wide_u103d)))

$(foreach cons,$(narrowCons),$(eval $(call eVowelYayitWasway,$(cons),u103c_narrow_u103d)))

define eVowelYayitHato
svg/$(1)_u103c_u103e_u1031.svg : xslt/$(1).xslt xslt/u1031.xslt xslt/$(2).xslt xslt/eVowelYayitCons.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_u103e_u1031.xslt --stringparam yayit $(2) --stringparam base $(1)  xslt/eVowelYayitCons.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_u103e_u1031.xslt blank.svg

svg/$(1)_u103c_u103e_u1031_u102c.svg : xslt/$(1).xslt xslt/u1031.xslt xslt/$(2).xslt xslt/eVowelYayitCons.xslt Makefile xslt/param.xslt xslt/u102c.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_u103e_u1031_u102c.xslt --stringparam yayit $(2) --stringparam base $(1) --stringparam aVowel u102c xslt/eVowelYayitCons.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_u103e_u1031_u102c.xslt blank.svg

ereorder :: svg/$(1)_u103c_u103e_u1031.svg svg/$(1)_u103c_u103e_u1031_u102c.svg
endef

$(foreach cons,$(wideCons),$(eval $(call eVowelYayitHato,$(cons),u103c_wide_u103e)))

$(foreach cons,$(narrowCons),$(eval $(call eVowelYayitHato,$(cons),u103c_narrow_u103e)))

define eVowelConsMedial
svg/$(1)_$(2)_u1031.svg : xslt/$(1).xslt xslt/u1031.xslt xslt/$(2).xslt xslt/eVowelConsMedial.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_$(2)_u1031.xslt --stringparam medial $(2) --stringparam base $(1)  xslt/eVowelConsMedial.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_$(2)_u1031.xslt blank.svg

ereorder :: svg/$(1)_$(2)_u1031.svg
endef

$(foreach medial,$(afterMedials),$(foreach cons,$(takesMedialEVowel),$(eval $(call eVowelConsMedial,$(cons),$(medial)))))

define eStack
svg/$(1)_u1039_$(3)_u1031.svg : xslt/$(2).xslt xslt/u1031.xslt xslt/$(3).xslt xslt/eStack.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u1039_$(3)_u1031.xslt --stringparam lowerCons $(3) --stringparam upperCons $(1) --stringparam upperConsTemplate $(2) xslt/eStack.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u1039_$(3)_u1031.xslt blank.svg

svg/$(1)_u1039_$(3)_u1031_u102c.svg : xslt/$(2).xslt xslt/u1031.xslt xslt/$(3).xslt xslt/eStack.xslt Makefile xslt/param.xslt xslt/u102c.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u1039_$(3)_u1031.xslt --stringparam lowerCons $(3) --stringparam upperCons $(1) --stringparam upperConsTemplate $(2) --stringparam aVowel u102c xslt/eStack.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u1039_$(3)_u1031.xslt blank.svg

ereorder :: svg/$(1)_u1039_$(3)_u1031.svg svg/$(1)_u1039_$(3)_u1031_u102c.svg
endef

$(eval $(call eStack,u1005,u1005,u1006))
$(eval $(call eStack,u1012,u1012,u1012))
$(eval $(call eStack,u1012,u1012,u1013))
$(eval $(call eStack,u1014,u1014_alt,u1010))
$(eval $(call eStack,u1014,u1014_alt,u1012))
$(eval $(call eStack,u1014,u1014_alt,u1013))
$(eval $(call eStack,u1017,u1017,u1017))
$(eval $(call eStack,u1019,u1019,u1019))

define yayitCons
svg/$(1)_u103c.svg : xslt/$(1).xslt xslt/$(2).xslt xslt/yayitCons.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c.xslt --stringparam yayit $(2) --stringparam base $(1)  xslt/yayitCons.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c.xslt blank.svg
yayit:: svg/$(1)_u103c.svg
endef

$(foreach cons,$(wideCons),$(eval $(call yayitCons,$(cons),u103c_wide)))

$(foreach cons,$(narrowCons),$(eval $(call yayitCons,$(cons),u103c_narrow)))


define yayitConsUpperVowel
svg/$(1)_u103c_$(3).svg : xslt/$(1).xslt xslt/$(2).xslt xslt/$(3).xslt xslt/yayitConsUpperVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_$(3).xslt --stringparam yayit $(2) --stringparam base $(1) --stringparam upperVowel $(3) xslt/yayitConsUpperVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_$(3).xslt blank.svg
yayit :: svg/$(1)_u103c_$(3).svg
endef

$(foreach vowel,$(upperVowel) u102c,$(foreach cons,$(wideCons),$(eval $(call yayitConsUpperVowel,$(cons),u103c_wide_upper,$(vowel)))))


$(foreach vowel,$(upperVowel) u102c,$(foreach cons,$(narrowCons),$(eval $(call yayitConsUpperVowel,$(cons),u103c_narrow_upper,$(vowel)))))

define yayitConsMedial
svg/$(1)_u103c_$(2).svg : xslt/$(1).xslt xslt/$(3).xslt xslt/yayitCons.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_$(2).xslt --stringparam yayit $(3) --stringparam base $(1)  xslt/yayitCons.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_$(2).xslt blank.svg
yayit :: svg/$(1)_u103c_$(2).svg
endef

$(foreach cons,$(wideCons),$(eval $(call yayitConsMedial,$(cons),u103d,u103c_wide_u103d)))

$(foreach cons,$(narrowCons),$(eval $(call yayitConsMedial,$(cons),u103d,u103c_narrow_u103d)))

$(foreach cons,$(wideCons),$(eval $(call yayitConsMedial,$(cons),u103e,u103c_wide_u103e)))

$(foreach cons,$(narrowCons),$(eval $(call yayitConsMedial,$(cons),u103e,u103c_narrow_u103e)))

$(foreach cons,$(wideCons),$(eval $(call yayitConsMedial,$(cons),u102f,u103c_wide_u102f)))

$(foreach cons,$(narrowCons),$(eval $(call yayitConsMedial,$(cons),u102f,u103c_narrow_u102f)))

$(eval $(call yayitConsMedial,u1019,u103d_u103e,u103c_narrow_u103d_u103e))

define yayitConsUpperVowelMedial
svg/$(1)_u103c_$(3)_$(4).svg : xslt/$(1).xslt xslt/$(2).xslt xslt/$(4).xslt xslt/yayitConsUpperVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_$(3)_$(4).xslt --stringparam yayit $(2) --stringparam base $(1) --stringparam upperVowel $(4) xslt/yayitConsUpperVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_$(3)_$(4).xslt blank.svg

yayit :: svg/$(1)_u103c_$(3)_$(4).svg
endef

$(foreach vowel,$(upperVowel) u102c,$(foreach cons,$(wideCons),$(eval $(call yayitConsUpperVowelMedial,$(cons),u103c_wide_upper_u103d,u103d,$(vowel)))))

$(foreach vowel,$(upperVowel) u102c,$(foreach cons,$(narrowCons),$(eval $(call yayitConsUpperVowelMedial,$(cons),u103c_narrow_upper_u103d,u103d,$(vowel)))))

$(foreach vowel,$(upperVowel) u102c,$(foreach cons,$(wideCons),$(eval $(call yayitConsUpperVowelMedial,$(cons),u103c_wide_upper_u103e,u103e,$(vowel)))))

$(foreach vowel,$(upperVowel) u102c,$(foreach cons,$(narrowCons),$(eval $(call yayitConsUpperVowelMedial,$(cons),u103c_narrow_upper_u103e,u103e,$(vowel)))))

$(eval $(call yayitConsUpperVowelMedial,u1019,u103d_u103e,u103c_narrow_u103d_u103e,u102c))

define yayitConsOVowel
svg/$(1)_u103c_u102d_u102f.svg : xslt/$(1).xslt xslt/$(2).xslt xslt/u102d.xslt xslt/yayitConsUpperVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_u102d_u102f.xslt --stringparam yayit $(2) --stringparam base $(1) --stringparam upperVowel u102d xslt/yayitConsUpperVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_u102d_u102f.xslt blank.svg

yayit :: svg/$(1)_u103c_u102d_u102f.svg
endef

$(foreach cons,$(wideCons),$(eval $(call yayitConsOVowel,$(cons),u103c_wide_upper_u102f)))

$(foreach cons,$(narrowCons),$(eval $(call yayitConsOVowel,$(cons),u103c_narrow_upper_u102f)))

define yayitConsTheTheTinAugamyit
svg/$(1)_u103c_u102f_u1036_u1037.svg : xslt/$(1).xslt xslt/$(2).xslt xslt/u1036.xslt xslt/u1037.xslt xslt/yayitConsUpperLowerVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_u102f_u1036_u1037.xslt --stringparam yayit $(2) --stringparam base $(1) --stringparam upperVowel u1036 --stringparam lowerVowel u1037 xslt/yayitConsUpperLowerVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_u102f_u1036_u1037.xslt blank.svg

yayit :: svg/$(1)_u103c_u102f_u1036_u1037.svg
endef

$(foreach cons,$(wideCons),$(eval $(call yayitConsTheTheTinAugamyit,$(cons),u103c_wide_upper_u102f)))

$(foreach cons,$(narrowCons),$(eval $(call yayitConsTheTheTinAugamyit,$(cons),u103c_narrow_upper_u102f)))

define yayitConsUuVowel
svg/$(1)_u103c_u1030.svg : xslt/$(1).xslt xslt/$(2).xslt xslt/u1030_tall.xslt xslt/yayitConsLowerVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_u1030.xslt --stringparam yayit $(2) --stringparam base $(1) --stringparam lowerVowel u1030_tall xslt/yayitConsLowerVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_u1030.xslt blank.svg

yayit :: svg/$(1)_u103c_u1030.svg
endef

$(foreach cons,$(wideCons),$(eval $(call yayitConsUuVowel,$(cons),u103c_wide)))

$(foreach cons,$(narrowCons),$(eval $(call yayitConsUuVowel,$(cons),u103c_narrow)))

define yayitConsMedialUuVowel
svg/$(1)_u103c_${3}_${4}.svg : xslt/$(1).xslt xslt/$(2).xslt xslt/${4}_tall.xslt xslt/yayitConsLowerVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_${3}_${4}.xslt --stringparam yayit $(2) --stringparam base $(1) --stringparam lowerVowel ${4}_tall xslt/yayitConsLowerVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_${3}_${4}.xslt blank.svg

yayit :: svg/$(1)_u103c_${3}_${4}.svg
endef

$(foreach cons,$(wideCons),$(eval $(call yayitConsMedialUuVowel,$(cons),u103c_wide_u103d,u103d,u102f)))

$(foreach cons,$(narrowCons),$(eval $(call yayitConsMedialUuVowel,$(cons),u103c_narrow_u103d,u103d,u102f)))

$(foreach cons,$(wideCons),$(eval $(call yayitConsMedialUuVowel,$(cons),u103c_wide_u103e,u103e,u102f)))

$(foreach cons,$(narrowCons),$(eval $(call yayitConsMedialUuVowel,$(cons),u103c_narrow_u103e,u103e,u102f)))

$(foreach cons,$(wideCons),$(eval $(call yayitConsMedialUuVowel,$(cons),u103c_wide_u103d,u103d,u1030)))

$(foreach cons,$(narrowCons),$(eval $(call yayitConsMedialUuVowel,$(cons),u103c_narrow_u103d,u103d,u1030)))

$(foreach cons,$(wideCons),$(eval $(call yayitConsMedialUuVowel,$(cons),u103c_wide_u103e,u103e,u1030)))

$(foreach cons,$(narrowCons),$(eval $(call yayitConsMedialUuVowel,$(cons),u103c_narrow_u103e,u103e,u1030)))


define yayitConsHatoOVowel
svg/$(1)_u103c_u103e_u102d_u102f.svg : xslt/$(1).xslt xslt/$(2).xslt xslt/u102d.xslt xslt/u102f_tall.xslt xslt/yayitConsUpperLowerVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103c_u103e_u102d_u102f.xslt --stringparam yayit $(2) --stringparam base $(1) --stringparam upperVowel u102d --stringparam lowerVowel u102f_tall xslt/yayitConsUpperLowerVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_u103c_u103e_u102d_u102f.xslt blank.svg

yayit :: svg/$(1)_u103c_u103e_u102d_u102f.svg
endef

$(foreach cons,$(wideCons),$(eval $(call yayitConsHatoOVowel,$(cons),u103c_wide_upper_u103e)))

$(foreach cons,$(narrowCons),$(eval $(call yayitConsHatoOVowel,$(cons),u103c_narrow_upper_u103e)))

kinzi: $(patsubst %, svg/u1004_u103a_u1039_%_u1031.svg, $(takesKinzi)) $(patsubst %, svg/u1004_u103a_u1039_%.svg, $(takesKinzi)) $(patsubst %, svg/u1004_u103a_u1039_%_u102d.svg, $(takesKinzi)) $(patsubst %, svg/u1004_u103a_u1039_%_u102e.svg, $(takesKinzi)) $(patsubst %, svg/u1004_u103a_u1039_%_u1036.svg, $(takesKinzi)) $(patsubst %, svg/u1004_u103a_u1039_%_u103b_u1031.svg, $(takesKinzi))

define consKinzi
svg/u1004_u103a_u1039_$(1).svg : xslt/$(1).xslt xslt/consKinzi.xslt Makefile xslt/param.xslt xslt/u1004_u103a_u1039.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1004_u103a_u1039_$(1).xslt --stringparam base $(1)  xslt/consKinzi.xslt blank.svg
	xsltproc -o $$@  tmp/u1004_u103a_u1039_$(1).xslt blank.svg
endef

$(foreach cons,$(takesKinzi),$(eval $(call consKinzi,$(cons))))

define consKinziVowel
svg/u1004_u103a_u1039_$(1)_$(2).svg : xslt/$(1).xslt xslt/$(2).xslt xslt/consKinziVowel.xslt Makefile xslt/param.xslt xslt/u1004_u103a_u1039.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1004_u103a_u1039_$(1)_$(2).xslt --stringparam base $(1) --stringparam vowel $(2) xslt/consKinziVowel.xslt blank.svg
	xsltproc -o $$@  tmp/u1004_u103a_u1039_$(1)_$(2).xslt blank.svg
endef

$(foreach vowel,$(kinziVowel),$(foreach cons,$(takesKinzi),$(eval $(call consKinziVowel,$(cons),$(vowel)))))

define eVowelConsKinzi
svg/u1004_u103a_u1039_$(1)_u1031.svg : xslt/$(1).xslt xslt/u1031.xslt xslt/eVowelConsKinzi.xslt Makefile xslt/param.xslt  xslt/u1004_u103a_u1039.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1004_u103a_u1039_$(1)_u1031.xslt --stringparam base $(1)  xslt/eVowelConsKinzi.xslt blank.svg
	xsltproc -o $$@  tmp/u1004_u103a_u1039_$(1)_u1031.xslt blank.svg
endef

$(foreach cons,$(takesKinzi),$(eval $(call eVowelConsKinzi,$(cons))))

define eVowelConsKinziMedial
svg/u1004_u103a_u1039_$(1)_$(2)_u1031.svg : xslt/$(1).xslt xslt/u1031.xslt xslt/$(2).xslt xslt/eVowelConsKinziMedial.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1004_u103a_u1039_$(1)_$(2)_u1031.xslt --stringparam medial $(2) --stringparam base $(1)  xslt/eVowelConsKinziMedial.xslt blank.svg
	xsltproc -o $$@  tmp/u1004_u103a_u1039_$(1)_$(2)_u1031.xslt blank.svg
endef

$(foreach cons,$(takesKinzi),$(eval $(call eVowelConsKinziMedial,$(cons),u103b)))

yapin: svg/u103b_u102d_u102f.svg svg/u103b_u102f.svg svg/u103b_u1030.svg svg/u103b_u103d_u102d_u102f.svg svg/u103b_u103d_u102f.svg svg/u103b_u103d_u1030.svg svg/u103b_u103e_u102d_u102f.svg svg/u103b_u103e_u102f.svg svg/u103b_u103e_u1030.svg  svg/u103b_u103d_u103e_u102d_u102f.svg svg/u103b_u103d_u103e_u102f.svg svg/u103b_u103d_u103e_u1030.svg svg/u103b_u102f_u1036.svg svg/u103b_u103d_u102f_u1036.svg svg/u103b_u103e_u102f_u1036.svg svg/u103b_u103d_u103e_u102f_u1036.svg svg/u103b_u1036.svg svg/u103b_u102f_u1036.svg svg/u103b_u103e_u1036.svg svg/u103b_u103d_u103e_u1036.svg svg/u103b_u1036_u1037.svg svg/u103b_u102f_u1036_u1037.svg svg/u103b_u103e_u1036_u1037.svg svg/u103b_u103d_u103e_u1036_u1037.svg svg/u103b_u102f_u1036_u1037.svg svg/u103b_u103d_u102f_u1036_u1037.svg svg/u103b_u103e_u102f_u1036_u1037.svg svg/u103b_u103d_u103e_u102f_u1036_u1037.svg

define yapinVowel
svg/$(1)_$(2).svg : xslt/$(1).xslt xslt/$(2)_tall.xslt xslt/yapinVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_$(2).xslt --stringparam yapin $(1) --stringparam vowel $(2) --stringparam vowelTemplate $(2)_tall xslt/yapinVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_$(2).xslt blank.svg
endef

$(foreach yapin,$(yapinVariants),$(eval $(call yapinVowel,$(yapin),u102f)))

$(foreach yapin,$(yapinVariants),$(eval $(call yapinVowel,$(yapin),u1030)))

define yapinVowels
svg/$(1)_$(2)_$(3).svg : xslt/$(1).xslt xslt/$(2).xslt xslt/$(3)_tall.xslt xslt/yapinVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_$(2)_$(3).xslt --stringparam yapin $(1) --stringparam upperVowel $(2) --stringparam vowel $(3) --stringparam vowelTemplate $(3)_tall xslt/yapinVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_$(2)_$(3).xslt blank.svg
endef

$(foreach yapin,$(yapinVariants),$(eval $(call yapinVowels,$(yapin),u102d,u102f)))

define yapinThethetin
svg/$(1)_$(2).svg : xslt/$(1).xslt xslt/$(2).xslt xslt/yapinVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_$(2).xslt --stringparam yapin $(1) --stringparam upperVowel $(2) xslt/yapinVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_$(2).xslt blank.svg

svg/$(1)_$(2)_u1037.svg : xslt/$(1).xslt xslt/$(2).xslt xslt/yapinVowel.xslt Makefile xslt/param.xslt xslt/u1037.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_$(2)_$(3)_u1037.xslt --stringparam yapin $(1) --stringparam upperVowel $(2) --stringparam augamyit u1037 xslt/yapinVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_$(2)_$(3)_u1037.xslt blank.svg
endef

$(foreach yapin,$(yapinVariants),$(eval $(call yapinThethetin,$(yapin),u1036)))

define yapinThethetinVowel
svg/$(1)_$(3)_$(2).svg : xslt/$(1).xslt xslt/$(2).xslt xslt/$(3)_tall.xslt xslt/yapinVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_$(2)_$(3).xslt --stringparam yapin $(1) --stringparam upperVowel $(2) --stringparam vowel $(3) --stringparam vowelTemplate $(3)_tall xslt/yapinVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_$(2)_$(3).xslt blank.svg

svg/$(1)_$(3)_$(2)_u1037.svg : xslt/$(1).xslt xslt/$(2).xslt xslt/$(3)_tall.xslt xslt/yapinVowel.xslt Makefile xslt/param.xslt  xslt/u1037.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_$(2)_$(3)_u1037.xslt --stringparam yapin $(1) --stringparam upperVowel $(2) --stringparam vowel $(3) --stringparam vowelTemplate $(3)_tall --stringparam augamyit u1037 xslt/yapinVowel.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_$(2)_$(3)_u1037.xslt blank.svg
endef

$(foreach yapin,$(yapinVariants),$(eval $(call yapinThethetinVowel,$(yapin),u1036,u102f)))

# narrow above wide stack

define narrowWideStack

svg/$(1)_u1039_$(3).svg : xslt/$(2).xslt xslt/$(4).xslt xslt/narrowWideStack.xslt xslt/param.xslt Makefile
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u1039_$(3).xslt --stringparam upper $(1) --stringparam upperTemplate $(2) --stringparam lower $(3) --stringparam lowerTemplate $(4) xslt/narrowWideStack.xslt blank.svg
	xsltproc -o $$@ tmp/$(1)_u1039_$(3).xslt blank.svg

svg/$(1)_u1039_$(3)_u102f.svg : xslt/$(2).xslt xslt/$(4).xslt xslt/narrowWideStack.xslt xslt/param.xslt Makefile xslt/u102f_tall.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u1039_$(3)_u102f.xslt --stringparam upper $(1) --stringparam upperTemplate $(2) --stringparam lower $(3) --stringparam lowerTemplate $(4) --stringparam tallVowel u102f_tall xslt/narrowWideStack.xslt blank.svg
	xsltproc -o $$@ tmp/$(1)_u1039_$(3)_u102f.xslt blank.svg

svg/$(1)_u1039_$(3)_u1030.svg : xslt/$(2).xslt xslt/$(4).xslt xslt/narrowWideStack.xslt xslt/param.xslt Makefile xslt/u1030_tall.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u1039_$(3)_u1030.xslt --stringparam upper $(1) --stringparam upperTemplate $(2) --stringparam lower $(3) --stringparam lowerTemplate $(4) --stringparam tallVowel u1030_tall xslt/narrowWideStack.xslt blank.svg
	xsltproc -o $$@ tmp/$(1)_u1039_$(3)_u1030.xslt blank.svg

svg/$(1)_u1039_$(3)_u102c.svg : xslt/$(2).xslt xslt/$(4).xslt xslt/narrowWideStack.xslt xslt/param.xslt Makefile xslt/u102c.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u1039_$(3)_u102c.xslt --stringparam upper $(1) --stringparam upperTemplate $(2) --stringparam lower $(3) --stringparam lowerTemplate $(4) --stringparam upperVowel u102c xslt/narrowWideStack.xslt blank.svg
	xsltproc -o $$@ tmp/$(1)_u1039_$(3)_u102c.xslt blank.svg

svg/$(1)_u1039_$(3)_u102d.svg : xslt/$(2).xslt xslt/$(4).xslt xslt/narrowWideStack.xslt xslt/param.xslt Makefile xslt/u102d.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u1039_$(3)_u102d.xslt --stringparam upper $(1) --stringparam upperTemplate $(2) --stringparam lower $(3) --stringparam lowerTemplate $(4) --stringparam upperVowel u102d xslt/narrowWideStack.xslt blank.svg
	xsltproc -o $$@ tmp/$(1)_u1039_$(3)_u102d.xslt blank.svg

svg/$(1)_u1039_$(3)_u102e.svg : xslt/$(2).xslt xslt/$(4).xslt xslt/narrowWideStack.xslt xslt/param.xslt Makefile xslt/u102e.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u1039_$(3)_u102e.xslt --stringparam upper $(1) --stringparam upperTemplate $(2) --stringparam lower $(3) --stringparam lowerTemplate $(4) --stringparam upperVowel u102e xslt/narrowWideStack.xslt blank.svg
	xsltproc -o $$@ tmp/$(1)_u1039_$(3)_u102e.xslt blank.svg


svg/$(1)_u1039_$(3)_u102d_u102f.svg : xslt/$(2).xslt xslt/$(4).xslt xslt/narrowWideStack.xslt xslt/param.xslt Makefile xslt/u102f_tall.xslt xslt/u102d.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u1039_$(3)_u102d_u102f.xslt --stringparam upper $(1) --stringparam upperTemplate $(2) --stringparam lower $(3) --stringparam lowerTemplate $(4) --stringparam upperVowel u102d --stringparam tallVowel u102f_tall xslt/narrowWideStack.xslt blank.svg
	xsltproc -o $$@ tmp/$(1)_u1039_$(3)_u102d_u102f.xslt blank.svg
	
narrowwidestack :: svg/$(1)_u1039_$(3).svg svg/$(1)_u1039_$(3)_u102c.svg svg/$(1)_u1039_$(3)_u102d.svg svg/$(1)_u1039_$(3)_u102e.svg svg/$(1)_u1039_$(3)_u102f.svg svg/$(1)_u1039_$(3)_u1030.svg svg/$(1)_u1039_$(3)_u102d_u102f.svg
endef

$(foreach narrow,$(narrowCons),$(foreach wide,$(wideCons),$(eval $(call narrowWideStack,$(narrow),$(narrow),$(wide),$(wide)))))

# Special cases

svg/u1039_u1014.svg : xslt/u1014_alt.xslt xslt/generateMedial.xslt Makefile
	mkdir -p tmp
	xsltproc -o $(subst xslt/,tmp/u1039_, $<)  --stringparam base u1014 --stringparam baseTemplate u1014_alt xslt/generateMedial.xslt blank.svg
	xsltproc -o $@  $(subst xslt/,tmp/u1039_, $<) blank.svg

svg/u1039_u1014_u102f.svg : xslt/u1014_alt.xslt xslt/generateMedialu102f.xslt Makefile  xslt/u102f_tall.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1039_u1014_u102f.xslt  --stringparam base u1014 --stringparam baseTemplate u1014_alt xslt/generateMedialu102f.xslt blank.svg
	xsltproc -o $@  tmp/u1039_u1014_u102f.xslt blank.svg

svg/u1039_u1014_u102d_u102f.svg : xslt/u1014_alt.xslt xslt/generateMedialu102d_u102f.xslt xslt/u102d.xslt xslt/u102f_tall.xslt Makefile
	mkdir -p tmp
	xsltproc -o tmp/u1039_u1014_u102d_u102f.xslt  --stringparam base u1014 --stringparam baseTemplate u1014_alt xslt/generateMedialu102d_u102f.xslt blank.svg
	xsltproc -o $@  tmp/u1039_u1014_u102d_u102f.xslt blank.svg

svg/u1039_u1014_u1030.svg : xslt/u1014_alt.xslt xslt/generateMedialu1030.xslt Makefile xslt/u1030_tall.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1039_u1014_u1030.xslt --stringparam base u1014 --stringparam baseTemplate u1014_alt xslt/generateMedialu1030.xslt blank.svg
	xsltproc -o $@  tmp/u1039_u1014_u1030.xslt blank.svg

yayit :: svg/u1014_u103c.svg svg/u1014_u103c_u103d.svg svg/u1014_u103c_u103e.svg svg/u1014_u103c_u102f.svg svg/u1014_u103c_u103d_u102f.svg svg/u1014_u103c_u103e_u102f.svg svg/u1014_u103c_u103d_u1030.svg svg/u1014_u103c_u103e_u1030.svg svg/u1014_u103c_u102d_u102f.svg svg/u1014_u103c_u1030.svg svg/u1014_u103c_u103e_u102d_u102f.svg

svg/u1014_u103c.svg : xslt/u1014_alt.xslt xslt/u103c_narrow.xslt xslt/yayitCons.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c.xslt --stringparam yayit u103c_narrow --stringparam base u1014 --stringparam baseTemplate u1014_alt  xslt/yayitCons.xslt blank.svg
	xsltproc -o $@  tmp/u1014_u103c.xslt blank.svg

svg/u1014_u103c_u103d.svg : xslt/u1014_alt.xslt xslt/u103c_narrow_u103d.xslt xslt/yayitCons.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c_u103d.xslt --stringparam yayit u103c_narrow_u103d --stringparam base u1014 --stringparam baseTemplate u1014_alt  xslt/yayitCons.xslt blank.svg
	xsltproc -o $@  tmp/u1014_u103c_u103d.xslt blank.svg

svg/u1014_u103c_u103e.svg : xslt/u1014_alt.xslt xslt/u103c_narrow_u103e.xslt xslt/yayitCons.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c_u103e.xslt --stringparam yayit u103c_narrow_u103e --stringparam base u1014 --stringparam baseTemplate u1014_alt  xslt/yayitCons.xslt blank.svg
	xsltproc -o $@  tmp/u1014_u103c_u103e.xslt blank.svg

svg/u1014_u103c_u102f.svg : xslt/u1014_alt.xslt xslt/u103c_narrow_u102f.xslt xslt/yayitCons.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c_u102f.xslt --stringparam yayit u103c_narrow_u102f --stringparam base u1014 --stringparam baseTemplate u1014_alt  xslt/yayitCons.xslt blank.svg
	xsltproc -o $@  tmp/u1014_u103c_u102f.xslt blank.svg

svg/u1014_u103c_u103d_u102f.svg : xslt/u1014_alt.xslt xslt/u103c_narrow_u103d.xslt xslt/yayitConsLowerVowel.xslt Makefile xslt/param.xslt xslt/u102f_tall.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c_u103d_u102f.xslt --stringparam yayit u103c_narrow_u103d --stringparam base u1014 --stringparam baseTemplate u1014_alt  --stringparam lowerVowel u102f_tall xslt/yayitConsLowerVowel.xslt blank.svg
	xsltproc -o $@  tmp/u1014_u103c_u103d_u102f.xslt blank.svg

svg/u1014_u103c_u103e_u102f.svg : xslt/u1014_alt.xslt xslt/u103c_narrow_u103e.xslt xslt/yayitConsLowerVowel.xslt Makefile xslt/param.xslt xslt/u102f_tall.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c_u103e_u102f.xslt --stringparam yayit u103c_narrow_u103e --stringparam base u1014 --stringparam baseTemplate u1014_alt --stringparam lowerVowel u102f_tall xslt/yayitConsLowerVowel.xslt blank.svg
	xsltproc -o $@  tmp/u1014_u103c_u103e_u102f.xslt blank.svg

svg/u1014_u103c_u103d_u1030.svg : xslt/u1014_alt.xslt xslt/u103c_narrow_u103d.xslt xslt/yayitConsLowerVowel.xslt Makefile xslt/param.xslt xslt/u1030_tall.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c_u103d_u1030.xslt --stringparam yayit u103c_narrow_u103d --stringparam base u1014 --stringparam baseTemplate u1014_alt  --stringparam lowerVowel u1030_tall xslt/yayitConsLowerVowel.xslt blank.svg
	xsltproc -o $@  tmp/u1014_u103c_u103d_u1030.xslt blank.svg

svg/u1014_u103c_u103e_u1030.svg : xslt/u1014_alt.xslt xslt/u103c_narrow_u103e.xslt xslt/yayitConsLowerVowel.xslt Makefile xslt/param.xslt xslt/u1030_tall.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c_u103e_u1030.xslt --stringparam yayit u103c_narrow_u103e --stringparam base u1014 --stringparam baseTemplate u1014_alt --stringparam lowerVowel u1030_tall xslt/yayitConsLowerVowel.xslt blank.svg
	xsltproc -o $@  tmp/u1014_u103c_u103e_u1030.xslt blank.svg

define yayitNaUpperVowel
svg/u1014_u103c_$(1).svg : xslt/u1014_alt.xslt xslt/u103c_narrow_upper.xslt xslt/$(1).xslt xslt/yayitConsUpperVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c_$(1).xslt --stringparam yayit u103c_narrow_upper --stringparam base u1014_alt --stringparam upperVowel $(1) xslt/yayitConsUpperVowel.xslt blank.svg
	xsltproc -o $$@  tmp/u1014_u103c_$(1).xslt blank.svg

yayit :: svg/u1014_u103c_$(1).svg
endef

$(foreach vowel,$(upperVowel),$(eval $(call yayitNaUpperVowel,$(vowel))))

define yayitNaMedialUpperVowel
svg/u1014_u103c_$(1)_$(2).svg : xslt/u1014_alt.xslt xslt/u103c_narrow_upper.xslt xslt/$(1).xslt xslt/$(2).xslt xslt/yayitConsUpperVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c_$(1)_$(2).xslt --stringparam yayit u103c_narrow_upper_$(1) --stringparam base u1014_alt --stringparam upperVowel $(2) xslt/yayitConsUpperVowel.xslt blank.svg
	xsltproc -o $$@  tmp/u1014_u103c_$(1)_$(2).xslt blank.svg

yayit :: svg/u1014_u103c_$(1)_$(2).svg
endef

$(foreach vowel,$(upperVowel),$(eval $(call yayitNaMedialUpperVowel,u103d,$(vowel))))

$(foreach vowel,$(upperVowel),$(eval $(call yayitNaMedialUpperVowel,u103e,$(vowel))))

svg/u1014_u103c_u102d_u102f.svg : xslt/u1014_alt.xslt xslt/u103c_narrow_upper_u102f.xslt xslt/u102d.xslt xslt/yayitConsUpperVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c_u102d_u102f.xslt --stringparam yayit u103c_narrow_upper_u102f --stringparam base u1014_alt --stringparam upperVowel u102d xslt/yayitConsUpperVowel.xslt blank.svg
	xsltproc -o $@  tmp/u1014_u103c_u102d_u102f.xslt blank.svg
	
svg/u1014_u103c_u1030.svg : xslt/u1014_alt.xslt xslt/u103c_narrow_u103e.xslt xslt/u1030_tall.xslt xslt/yayitConsLowerVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c_u1030.xslt --stringparam yayit u103c_narrow --stringparam base u1014 --stringparam baseTemplate u1014_alt --stringparam lowerVowel u1030_tall xslt/yayitConsLowerVowel.xslt blank.svg
	xsltproc -o $@  tmp/u1014_u103c_u1030.xslt blank.svg

svg/u1014_u103c_u103e_u102d_u102f.svg : xslt/u1014_alt.xslt xslt/u103c_narrow_upper_u103e.xslt xslt/u102d.xslt xslt/u102f_tall.xslt xslt/yayitConsUpperLowerVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u103c_u103e_u102d_u102f.xslt --stringparam yayit u103c_narrow_upper_u103e --stringparam base u1014 --stringparam baseTemplate u1014_alt --stringparam upperVowel u102d --stringparam lowerVowel u102f_tall xslt/yayitConsUpperLowerVowel.xslt blank.svg
	xsltproc -o $@  tmp/u1014_u103c_u103e_u102d_u102f.xslt blank.svg

define eVowelAltConsMedial
svg/$(1)_$(2)_u1031.svg : xslt/$(1)_alt.xslt xslt/u1031.xslt xslt/$(2).xslt xslt/eVowelConsMedial.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_$(2)_u1031.xslt --stringparam medial $(2) --stringparam base $(1) --stringparam baseTemplate $(1)_alt xslt/eVowelConsMedial.xslt blank.svg
	xsltproc -o $$@  tmp/$(1)_$(2)_u1031.xslt blank.svg

ereorder :: svg/$(1)_$(2)_u1031.svg
endef

$(foreach cons,u100a u1014 u101b, $(foreach medial,$(afterMedials),$(eval $(call eVowelAltConsMedial,$(cons),$(medial)))))

misc: svg/u1014_u103b.svg svg/u1014_u103d.svg svg/u1014_u103e.svg svg/u1014_u103b_u103d.svg svg/u1014_u103b_u103e.svg svg/u1014_u103b_u103d_u103e.svg svg/u1014_u103d_u103e.svg svg/u1014_u103d_u1031.svg svg/u1014_u103e_u1031.svg svg/u1014_u103b_u103d_u1031.svg svg/u1014_u103b_u103e_u1031.svg svg/u1014_u103b_u103d_u103e_u1031.svg svg/u1014_u103d_u103e_u1031.svg svg/u1014_u102f.svg svg/u1014_u102d_u102f.svg svg/u1014_u103e_u102d_u102f.svg svg/u1014_u1030.svg svg/u100a_u103b.svg svg/u100a_u103d.svg svg/u100a_u103e.svg svg/u100a_u103b_u103d.svg svg/u100a_u103b_u103e.svg svg/u100a_u103b_u103d_u103e.svg svg/u100a_u103d_u103e.svg svg/u100a_u102f.svg svg/u100a_u102d_u102f.svg svg/u100a_u103e_u102d_u102f.svg svg/u100a_u1030.svg svg/u101b_u102f.svg svg/u101b_u102d_u102f.svg svg/u101b_u1030.svg svg/u1014_u103e_u102f.svg svg/u1014_u103e_u1030.svg svg/u100a_u103e_u102f.svg svg/u100a_u103e_u1030.svg svg/u101b_u103e_u102f.svg svg/u101b_u103e_u1030.svg svg/u1014_u103b_u102f.svg svg/u1014_u103b_u1030.svg svg/u101b_u103b_u102f.svg svg/u101b_u103b_u1030.svg svg/u100a_u103b_u102f.svg svg/u100a_u103b_u1030.svg

define nyanaLowerVowel
svg/$(1)_$(3).svg : xslt/$(2).xslt xslt/$(3).xslt xslt/nyanaLowerVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_$(3).xslt --stringparam cons $(1) --stringparam consTemplate $(2) --stringparam lowerVowel $(3) xslt/nyanaLowerVowel.xslt blank.svg
	xsltproc -o $$@ tmp/$(1)_$(3).xslt blank.svg
endef

$(foreach vowel,$(afterMedials) $(lowerVowels) u103e_u102f u103e_u1030,$(eval $(call nyanaLowerVowel,u1014,u1014_alt,$(vowel))))

$(foreach vowel,$(afterMedials) $(lowerVowels) u103e_u102f u103e_u1030,$(eval $(call nyanaLowerVowel,u100a,u100a_alt,$(vowel))))

$(foreach vowel,$(lowerVowels) u103e_u102f u103e_u1030,$(eval $(call nyanaLowerVowel,u101b,u101b_alt,$(vowel))))

define nyanaHatoUpperLowerVowel
svg/$(1)_u103e_u102d_u102f.svg : xslt/$(2).xslt xslt/$(3).xslt xslt/nyanaUpperLowerVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u103e_u102d_u102f.xslt --stringparam cons $(1) --stringparam consTemplate $(2) --stringparam lowerVowel $(3) --stringparam upperVowel u102d xslt/nyanaUpperLowerVowel.xslt blank.svg
	xsltproc -o $$@ tmp/$(1)_u103e_u102d_u102f.xslt blank.svg
endef

$(eval $(call nyanaHatoUpperLowerVowel,u1014,u1014_alt,u103e_u102f))
$(eval $(call nyanaHatoUpperLowerVowel,u100a,u100a_alt,u103e_u102f))
$(eval $(call nyanaHatoUpperLowerVowel,u101b,u101b_alt,u103e_u102f))

define nyanaMedialTallVowel
svg/$(1)_$(3)_$(4).svg : xslt/$(2).xslt xslt/$(3).xslt xslt/$(4)_tall.xslt xslt/nyanaMedialTallVowel.xslt Makefile xslt/param.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_$(3)_$(4).xslt --stringparam cons $(1) --stringparam consTemplate $(2) --stringparam medial $(3) --stringparam tallVowel $(4)_tall xslt/nyanaMedialTallVowel.xslt blank.svg
	xsltproc -o $$@ tmp/$(1)_$(3)_$(4).xslt blank.svg
endef

$(eval $(call nyanaMedialTallVowel,u1014,u1014_alt,u103b,u102f))
$(eval $(call nyanaMedialTallVowel,u100a,u100a_alt,u103b,u102f))
$(eval $(call nyanaMedialTallVowel,u101b,u101b_alt,u103b,u102f))

$(eval $(call nyanaMedialTallVowel,u1014,u1014_alt,u103b,u1030))
$(eval $(call nyanaMedialTallVowel,u100a,u100a_alt,u103b,u1030))
$(eval $(call nyanaMedialTallVowel,u101b,u101b_alt,u103b,u1030))


svg/u1014_u102d_u102f.svg : xslt/u1014_alt.xslt xslt/u102d.xslt xslt/u102f.xslt
	mkdir -p tmp
	xsltproc -o tmp/u1014_u102d_u102f.xslt --stringparam cons u1014 --stringparam consTemplate u1014_alt --stringparam upperVowel u102d --stringparam lowerVowel u102f xslt/nyanaUpperLowerVowel.xslt blank.svg
	xsltproc -o $@ tmp/u1014_u102d_u102f.xslt blank.svg

svg/u100a_u102d_u102f.svg : xslt/u100a_alt.xslt xslt/u102d.xslt xslt/u102f.xslt
	mkdir -p tmp
	xsltproc -o tmp/u100a_u102d_u102f.xslt --stringparam cons u100a --stringparam consTemplate u100a_alt --stringparam upperVowel u102d --stringparam lowerVowel u102f xslt/nyanaUpperLowerVowel.xslt blank.svg
	xsltproc -o $@ tmp/u100a_u102d_u102f.xslt blank.svg

svg/u101b_u102d_u102f.svg : xslt/u101b_alt.xslt xslt/u102d.xslt xslt/u102f.xslt
	mkdir -p tmp
	xsltproc -o tmp/u101b_u102d_u102f.xslt --stringparam cons u101b --stringparam consTemplate u101b_alt --stringparam upperVowel u102d --stringparam lowerVowel u102f xslt/nyanaUpperLowerVowel.xslt blank.svg
	xsltproc -o $@ tmp/u101b_u102d_u102f.xslt blank.svg

tallConsVowel: $(patsubst %,svg/%_u102f.svg,$(tallCons)) $(patsubst %,svg/%_u1030.svg,$(tallCons)) $(patsubst %,svg/%_u102d_u102f.svg,$(tallCons))

define tallConsUVowel
svg/$(1)_$(2).svg : xslt/$(1).xslt xslt/$(2)_tall.xslt Makefile xslt/param.xslt xslt/tallConsUVowel.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_$(2).xslt --stringparam cons $(1) --stringparam uVowel $(2)_tall xslt/tallConsUVowel.xslt blank.svg
	xsltproc -o $$@ tmp/$(1)_$(2).xslt blank.svg
endef

$(foreach cons,$(tallCons),$(eval $(call tallConsUVowel,$(cons),u102f)))
$(foreach cons,$(tallCons),$(eval $(call tallConsUVowel,$(cons),u1030)))

define tallConsOVowel
svg/$(1)_u102d_$(2).svg : xslt/$(1).xslt xslt/$(2)_tall.xslt Makefile xslt/param.xslt xslt/tallConsOVowel.xslt
	mkdir -p tmp
	xsltproc -o tmp/$(1)_u102d_$(2).xslt --stringparam cons $(1) --stringparam iVowel u102d --stringparam uVowel $(2)_tall xslt/tallConsOVowel.xslt blank.svg
	xsltproc -o $$@ tmp/$(1)_u102d_$(2).xslt blank.svg
endef

$(foreach cons,$(tallCons),$(eval $(call tallConsOVowel,$(cons),u102f)))


# extra dependencies

svg/u1008.svg :: xslt/u103b.xslt

svg/u1029.svg :: xslt/u101e.xslt xslt/u103c_wide.xslt

svg/u102a.svg :: xslt/u101e.xslt xslt/u103c_wide.xslt xslt/u1031.xslt xslt/u102c.xslt xslt/u103a.xslt

svg/u103d.svg :: xslt/u101d.xslt

svg/u1039.svg :: xslt/u25cc.xslt

svg/u102d_u1036.svg :: xslt/u102d.xslt xslt/u1036.xslt

svg/u1009_u102c.svg :: xslt/u102c.xslt xslt/u1009.xslt

svg/u1009_u103e.svg :: xslt/u1009.xslt xslt/u103e_small.xslt

svg/u1009_u103e_u102c.svg :: xslt/u102c.xslt xslt/u1009.xslt xslt/u103e_small.xslt

svg/u1009_u1039_u1007.svg :: xslt/u1025.xslt xslt/u1007.xslt

svg/u1009_u1039_u1007_u102f.svg :: xslt/u1025.xslt xslt/u1007.xslt xslt/u102f_tall.xslt

svg/u1009_u1039_u1007_u102d_u102f.svg :: xslt/u1025.xslt xslt/u1007.xslt xslt/u102f_tall.xslt xslt/u102d.xslt

svg/u1009_u103a.svg :: xslt/u1025.xslt xslt/u103a.xslt

svg/u1009_u1037_u103a.svg :: xslt/u1025.xslt xslt/u103a.xslt xslt/u1037.xslt

svg/u100d_u1039_u100e.svg :: xslt/u100d.xslt xslt/u100e.xslt

svg/u1014_u1039_u1010.svg :: xslt/u1014_alt.xslt xslt/u1010.xslt
svg/u1014_u1039_u1011.svg :: xslt/u1014_alt.xslt xslt/u1011.xslt

svg/u1014_u1039_u1012.svg :: xslt/u1014_alt.xslt xslt/u1012.xslt

svg/u1014_u1039_u1013.svg :: xslt/u1014_alt.xslt xslt/u1013.xslt

svg/u1014_u1039_u1014.svg :: xslt/u1014_alt.xslt

svg/u1014_u1039_u1012_u1030.svg :: xslt/u1014_alt.xslt xslt/u1012.xslt xslt/u1030.xslt

svg/u1014_u1039_u1013_u1030.svg :: xslt/u1014_alt.xslt xslt/u1013.xslt xslt/u1030.xslt

svg/u1014_u1039_u1010_u102f.svg :: xslt/u1014_alt.xslt xslt/u1010.xslt xslt/u102f_tall.xslt

svg/u1014_u1039_u1012_u102f.svg :: xslt/u1014_alt.xslt xslt/u1012.xslt xslt/u102f_tall.xslt

svg/u1014_u1039_u1013_u102f.svg :: xslt/u1014_alt.xslt xslt/u1013.xslt xslt/u102f_tall.xslt

svg/u1014_u1039_u1010_u102d_u102f.svg :: xslt/u1014_alt.xslt xslt/u1010.xslt xslt/u102f_tall.xslt xslt/u102d.xslt

svg/u1014_u1039_u1012_u102d_u102f.svg :: xslt/u1014_alt.xslt xslt/u1012.xslt xslt/u102f_tall.xslt xslt/u102d.xslt

svg/u1014_u1039_u1013_u102d_u102f.svg :: xslt/u1014_alt.xslt xslt/u1013.xslt xslt/u102f_tall.xslt xslt/u102d.xslt


clean:
	rm svg/*.svg
	rm -rf tmp


