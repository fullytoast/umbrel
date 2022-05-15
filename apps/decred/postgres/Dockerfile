#based on PostgreSQL Alpine Dockerfile with modifications for fullystaked environment
FROM 	alpine:3.14

#PostgreSQL environment variables
ENV 	LANG en_US.utf8
ENV 	PG_MAJOR 13
ENV 	PG_VERSION 13.3
ENV 	PG_SHA256 3cd9454fa8c7a6255b6743b767700925ead1b9ab0d7a0f9dcb1151010f8eb4a1
ENV 	PG_HOME /storage/postgresql
ENV 	PG_DATA $PG_HOME/data

#create & setup postgres user and storage
RUN 	set -eux; \
		addgroup -g 70 -S postgres; \
		adduser -u 70 -S -D -G postgres -H -h $PG_HOME -s /bin/sh postgres; \
		mkdir -p $PG_HOME; \
		chown -R postgres:postgres $PG_HOME; \
		mkdir $PG_DATA; \ 
		chown -R postgres:postgres $PG_DATA; \
		chmod 777 $PG_DATA

#install postgresql
RUN set -eux; \
	\
	wget -O postgresql.tar.bz2 "https://ftp.postgresql.org/pub/source/v$PG_VERSION/postgresql-$PG_VERSION.tar.bz2"; \
	echo "$PG_SHA256 *postgresql.tar.bz2" | sha256sum -c -; \
	mkdir -p /usr/src/postgresql; \
	tar \
		--extract \
		--file postgresql.tar.bz2 \
		--directory /usr/src/postgresql \
		--strip-components 1 \
	; \
	rm postgresql.tar.bz2; \
	\
	apk add --no-cache --virtual .build-deps \
		bison \
		coreutils \
		dpkg-dev dpkg \
		flex \
		gcc \
		libc-dev \
		libedit-dev \
		libxml2-dev \
		libxslt-dev \
		linux-headers \
		llvm11-dev clang g++ \
		make \
		openssl-dev \
		perl-utils \
		perl-ipc-run \
		util-linux-dev \
		zlib-dev \
		icu-dev \
	; \
	\
	cd /usr/src/postgresql; \
	awk '$1 == "#define" && $2 == "DEFAULT_PGSOCKET_DIR" && $3 == "\"/tmp\"" { $3 = "\"/var/run/postgresql\""; print; next } { print }' src/include/pg_config_manual.h > src/include/pg_config_manual.h.new; \
	grep '/var/run/postgresql' src/include/pg_config_manual.h.new; \
	mv src/include/pg_config_manual.h.new src/include/pg_config_manual.h; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	wget -O config/config.guess 'https://git.savannah.gnu.org/cgit/config.git/plain/config.guess?id=7d3d27baf8107b630586c962c057e22149653deb'; \
	wget -O config/config.sub 'https://git.savannah.gnu.org/cgit/config.git/plain/config.sub?id=7d3d27baf8107b630586c962c057e22149653deb'; \
	./configure \
		--build="$gnuArch" \
		--enable-integer-datetimes \
		--enable-thread-safety \
		--enable-tap-tests \
		--disable-rpath \
		--with-uuid=e2fs \
		--with-gnu-ld \
		--with-pgport=5432 \
		--with-system-tzdata=/usr/share/zoneinfo \
		--prefix=/usr/local \
		--with-includes=/usr/local/include \
		--with-libraries=/usr/local/lib \
		--with-openssl \
		--with-libxml \
		--with-libxslt \
		--with-icu \
		--with-llvm \
	; \
	make -j "$(nproc)" world; \
	make install-world; \
	make -C contrib install; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache --virtual .postgresql-rundeps \
		$runDeps \
		bash \
		su-exec \
		tzdata \
	; \
	apk del --no-network .build-deps; \
	cd /; \
	rm -rf \
		/usr/src/postgresql \
		/usr/local/share/doc \
		/usr/local/share/man \
	; \
	\
	postgres --version

# make the sample config easier to munge (and "correct by default")
#RUN set -eux; \
#	cp -v /usr/local/share/postgresql/postgresql.conf.sample /usr/local/share/postgresql/postgresql.conf.sample.orig; \
#	sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/local/share/postgresql/postgresql.conf.sample; \
#	grep -F "listen_addresses = '*'" /usr/local/share/postgresql/postgresql.conf.sample

#from default install, what does this do?
RUN mkdir -p /var/run/postgresql && chown -R postgres:postgres /var/run/postgresql && chmod 2777 /var/run/postgresql

#copy start script and change ownership to postgres
COPY 	./start-postgresql.sh /start-postgresql.sh
RUN 	chown postgres:postgres /start-postgresql.sh && \
		chmod u+x /start-postgresql.sh && \
		chmod g+x /start-postgresql.sh

#copy config file to /config for loading?

#switch to user postgres
USER 	postgres