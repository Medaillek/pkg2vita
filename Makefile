IMAGE_NAME := pkg2vita

.PHONY: build run

build:
	docker build -t $(IMAGE_NAME) .

run:
	@ifeq ($(ZIPDIR),)
	$(error Usage: make run ZIPDIR=/path/to/zip/directory)
	@endif
	docker run --rm -v $(ZIPDIR):/zip $(IMAGE_NAME)
