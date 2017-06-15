
bin_dir := bin
obj_dir := obj
dep_dir := dep
git_dir := .git
exc_dirs := $(bin_dir) $(obj_dir) $(dep_dir) $(git_dir)

src := $(wildcard *.c)
header := $(wildcard *.h)
dirs := $(patsubst %/,%,$(wildcard */))
dirs := $(filter-out $(exc_dirs),$(dirs))

ifeq ($(MAKECMDGOALS),)
$(foreach d,$(dirs),$(eval include $(d)/submake.mk))
endif

ifneq ($(filter-out clean,$(MAKECMDGOALS)),)
$(foreach d,$(dirs),$(eval include $(d)/submake.mk))
endif

Iinc := -I.
Iinc += $(patsubst %,-I%,$(dirs))
obj := $(patsubst %.c,$(obj_dir)/%.o,$(notdir $(src)))
dep := $(obj:$(obj_dir)/%.o=$(dep_dir)/%.d)

VPATH += $(dirs)

# $(info $(dirs))
# $(info $(src))
# $(info $(header))
# $(info $(Iinc))
# $(info $(obj))
# $(info $(dep))

.PHONY: all clean 

all: $(bin_dir)/binary

$(bin_dir)/binary: $(obj) | $(bin_dir)
	$(CC) -o $@ $(obj)

$(obj_dir)/%.o:%.c  | $(obj_dir)
	$(CC) -c -o $@ $< $(Iinc) 

$(dep_dir)/%.d:%.c  | $(dep_dir)
	@echo 'building dependency info -> $@'
	@$(CC) -MM -MG $< $(Iinc) | sed -r -e 's|(.*).o:|$(dep_dir)/\1.d $(obj_dir)/\1.o:|' > $@	

$(bin_dir):
	@mkdir $@
$(obj_dir):
	@mkdir $@
$(dep_dir):
	@mkdir $@	

clean:
	rm -rf $(obj_dir) $(dep_dir) $(bin_dir)	
 
ifeq ($(MAKECMDGOALS),)
-include $(obj:$(obj_dir)/%.o=$(dep_dir)/%.d)
endif

ifneq ($(filter-out clean,$(MAKECMDGOALS)),)
-include $(obj:$(obj_dir)/%.o=$(dep_dir)/%.d)
endif