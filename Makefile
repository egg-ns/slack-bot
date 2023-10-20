VERSION := 1.0.dev$(shell date +'%y%m%d%H%M')
PKGNAME := obsapi
# FIXME
LICENSE := ISC
VENDOR=
URL=
RELEASE := 1
USER := obs
ARCH := amd64
DESC := One Bizlink Operation System Backend API Server
MAINTAINER := BOSCO Technologies, Inc.
FPM_IMAGE_TAG :=  fpm:rpm
PIPENV_IMAGE_TAG := pipenv
FPM := docker run --rm -it -v "${PWD}:/tmp/fpm" -w /tmp/fpm $(FPM_IMAGE_TAG)
PIPENV := docker run --rm -it -v "${PWD}:/tmp/pipenv" -w /tmp/pipenv $(PIPENV_IMAGE_TAG)

FPM_OPTS=-s dir -v $(VERSION) -n $(PKGNAME) \
	--license "$(LICENSE)" \
	--vendor "$(VENDOR)" \
	--maintainer "$(MAINTAINER)" \
	--architecture $(ARCH) \
	--url "$(URL)" \
	--description  "$(DESC)" \
	--config-files etc/sysconfig/obsapi \
	--config-files etc/nginx/conf.d/obsapi.conf \
	--config-files etc/obsapi/logging.cfg \
	-d "python36 > 0" \
	-d "nginx > 0" \
	--verbose

RPM_OPTS =--rpm-user $(USER) \
	--before-install packaging/scripts/preinstall.rpm \
	--after-install packaging/scripts/postinstall.rpm

skel/%/usr/lib/systemd/system/obsapi.service: packaging/systemd/obsapi.service
	mkdir -p "$(dir $@)"
	cp packaging/systemd/obsapi.service "$@"

skel/%/usr/lib/systemd/system/obsapi.socket: packaging/systemd/obsapi.socket
	mkdir -p "$(dir $@)"
	cp packaging/systemd/obsapi.socket "$@"

skel/%/usr/lib/systemd/system/obsworker.service: packaging/systemd/obsworker.service
	mkdir -p "$(dir $@)"
	cp packaging/systemd/obsworker.service "$@"

skel/%/usr/lib/obsapi/app: $(shell find app -type f | sed 's/ /\\ /g')
	mkdir -p "$(dir $@)"
	rsync -ar --exclude='__pycache__' --exclude='*.pyc' app "$(dir $@)"

skel/%/usr/lib/obsapi/requeirements.txt: Pipfile Pipfile.lock
	mkdir -p "$(dir $@)"
	$(PIPENV) lock -r >| "$@"

skel/%/etc/sysconfig/obsapi: packaging/etc/sysconfig/obsapi
	mkdir -p "$(dir $@)"
	cp packaging/etc/sysconfig/obsapi "$@"

skel/%/etc/nginx/conf.d/obsapi.conf: packaging/etc/nginx/conf.d/obsapi.conf
	mkdir -p "$(dir $@)"
	cp packaging/etc/nginx/conf.d/obsapi.conf "$@"

skel/%/etc/obsapi/logging.cfg: packaging/etc/obsapi/logging.cfg
	mkdir -p "$(dir $@)"
	cp packaging/etc/obsapi/logging.cfg "$@"

.PHONY: centos8
centos8: skel/centos8/usr/lib/systemd/system/obsapi.service
centos8: skel/centos8/usr/lib/systemd/system/obsapi.socket
centos8: skel/centos8/usr/lib/systemd/system/obsworker.service
centos8: skel/centos8/usr/lib/obsapi/app
centos8: skel/centos8/usr/lib/obsapi/requeirements.txt
centos8: skel/centos8/etc/sysconfig/obsapi
centos8: skel/centos8/etc/nginx/conf.d/obsapi.conf
centos8: skel/centos8/etc/obsapi/logging.cfg
	$(FPM) \
		-t rpm ${RPM_OPTS} \
		--iteration ${RELEASE} \
		-C skel/centos8 \
		${FPM_OPTS}

.PHONY: clean
clean:
	rm -rf skel