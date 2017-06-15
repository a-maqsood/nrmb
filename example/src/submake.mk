header += $(wildcard $(d)/*.h)
src += $(wildcard $(d)/*.c)
inner_dirs := $(dir $(wildcard $(d)/*/))
inner_dirs := $(patsubst %/,%,$(inner_dirs))
inner_dirs := $(filter-out $(dirs),$(inner_dirs))
dirs += $(inner_dirs)

$(foreach d,$(inner_dirs),$(eval include $(d)/submake.mk))