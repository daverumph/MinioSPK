GOPATH = $(shell pwd -P)/go
GOARCH = arm
GOARM = 7
my_d = $(shell pwd -P)
minio_src := go/src/github.com/minio/minio

.PHONY: build
build: clean init minio_arm_7 pkg_7

.PHONY: clean
clean:
	@rm -rf .git/modules
	@find . -type f -iname "*.tgz" -exec rm -rvf {} \;
	@find . -type f -iname "*.spk" -exec rm -rvf {} \;
	@rm -rf go minio*linux*

.PHONY: init
init:
	git submodule update --init
	cd $(minio_src) && \
		last_release=$$(git tag | sort -r | gawk '/RELEASE/{print$$1; exit;}') && \
	       	git checkout --force -b working ${last_release}

last_release := $(shell cd $(minio_src) && git tag | sort -r | gawk '/RELEASE/{print$$1; exit;}')
date_release := $(shell echo $(last_release) | awk -F'T' '{gsub("RELEASE-", "", $$1); gsub("-",".", $$1); print$$1}')
pkg_version := $(subst RELEASE.,,$(date_release))

.PHONY: info
info:
	@echo "$(last_release) $(pkg_version)"

.PHONY: minio_arm_%
minio_arm_%:
	@echo "Working on $(last_release)"
	cd $(minio_src) && env \
	    CGO_ENABLED=0 \
	    GOOS="linux" \
	    GOARCH=arm \
	    GOARM=$*\
	    go build -tags kqeue \
	    	--ldflags '$(shell cd $(minio_src); go run buildscripts/gen-ldflags.go)' \
		-o $(my_d)/minio-$(pkg_version)-linux-arm-$*

.PHONY: pkg_%
pkg_%:
	sed -e "s/version=.*/version=\"$(pkg_version)\"/g" \
		2_create_project/INFO-e > 2_create_project/INFO
	mkdir -p 1_create_package/minio
	cp minio-$(pkg_version)-*$* 1_create_package/minio/minio
	cd 1_create_package && \
		tar cvfhz ../2_create_project/package.tgz *
	cd 2_create_project && \
		tar cvfz ../minio-$(pkg_version)-arm-7.spk --exclude=INFO.in *
	rm -f package.tgz
