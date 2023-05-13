.PHONY: default
default:

programs := \
blake3 \
sha256 \
sha256-blake3

run := $(addsuffix .run,$(programs))
hash := $(addsuffix .hash,$(programs))
prove := $(addsuffix .prove,$(programs))
verify := $(addsuffix .verify,$(programs))

.PHONY: $(run) $(hash) $(prove) $(verify)

$(run): %.run:
	miden run \
		--assembly $*/$*.masm \
		--input $*/$*.in \
		--output $*/$*.out \
	;

$(hash): %.hash:
	miden compile \
		--assembly $*/$*.masm \
	| tail -n 1 | awk '{print $$NF}' \
	> $*/$*.hash

$(prove): %.prove: | %.hash
	miden prove \
		--assembly $*/$*.masm \
		--input $*/$*.in \
		--output $*/$*.out \
		--proof $*/$*.proof \
	;

$(verify): %.verify:
	miden verify \
		--program-hash $(shell cat $*/$*.hash) \
		--input $*/$*.in \
		--output $*/$*.out \
		--proof $*/$*.proof \
	;

.PHONY: readme
readme: | sha256-blake3.run
	present --in-place README.md

.PHONY: clean
clean:
	rm -rf ./*/*.hash ./*/*.out ./*/*.proof