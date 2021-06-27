## Docker-ayes

Write a Dockerfile to run Litecoin 0.18.1 in a container. It should somehow verify the checksum 
of the downloaded release (there's no need to build the project), run as a normal user, and when run without any 
modifiers (i.e. docker run somerepo/litecoin:0.18.1) should run the daemon, and print its output to the console.

## My Comments

I initially based my implementation on https://github.com/uphold/docker-litecoin-core
but found too many vulnerabilities (of which many were High Severity) when running `docker scan` 
```
Package manager:   deb
Project name:      docker-image|uphold/litecoin-core
Docker image:      uphold/litecoin-core:latest
Platform:          linux/amd64

Tested 124 dependencies for known vulnerabilities, found 87 vulnerabilities
```
so I decided to try a new implementation based on `alpine:latest`. 
It looked promising at first since the base image had shown no vulnerabilities after an initial scan.

The problem arose when running the compiled version of litecoind:
```
Error loading shared library libgcc_s.so.1: No such file or directory (needed by /usr/local/bin/litecoind)
        libc.so.6 => /lib64/ld-linux-x86-64.so.2 (0x7f9cdfd92000)
Error loading shared library ld-linux-x86-64.so.2: No such file or directory (needed by /usr/local/bin/litecoind)
```
Even after installing `libgcc` and `gcompat`, I was still getting errors:
```
Error relocating /usr/local/bin/litecoind: malloc_info: symbol not found
```

I then realized that the maintainers of `docker-litecoin-core` once created a pull request to move the base image to `alpine` instead of `debian` but that was [abandoned](https://github.com/uphold/docker-litecoin-core/pull/1#issuecomment-351739539).

So, I figured that if I wanted to make it work on Alpine, I would have to compile it myself...wait, wait, wait... not so fast, there is an [open issue](https://github.com/litecoin-project/litecoin/issues/407) on the Litecoin project's GitHub page with a proposed solution but that wouldn't be release 0.18.1 🤔

A different approach would be to change the base image from `stable` to `testing` which, considering Debian's reputation, is still quite stable. That gives us "only" 36 vulnerabilities of which 2 are High Severity.
```
✗ High severity vulnerability found in glibc/libc-bin
  Description: Use After Free
  Info: https://snyk.io/vuln/SNYK-DEBIAN11-GLIBC-1296898
  Introduced through: glibc/libc-bin@2.31-12, meta-common-packages@meta
  From: glibc/libc-bin@2.31-12
  From: meta-common-packages@meta > glibc/libc6@2.31-12

✗ High severity vulnerability found in curl/libcurl4
  Description: Missing Initialization of Resource
  Info: https://snyk.io/vuln/SNYK-DEBIAN11-CURL-1296884
  Introduced through: curl@7.74.0-1.2
  From: curl@7.74.0-1.2 > curl/libcurl4@7.74.0-1.2
  From: curl@7.74.0-1.2
  Image layer: 'RUN /bin/sh -c useradd -r litecoin   && apt-get update -y   && apt-get install -y curl gnupg   && apt-get clean   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* '  
```
According to the Advisories above, none of the packages have fixes so far. Luckily, the glibc vulnerability seems to be a false-positive. 

According to the MITRE CVE [database](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-33574) and the glibc project's [bug tracker](https://sourceware.org/bugzilla/show_bug.cgi?id=27896#c1), this bug was introduced in version 2.32 and we are using version 2.31-12.

Oops! another [comment](https://sourceware.org/bugzilla/show_bug.cgi?id=27896#c2) in the same bug report states that previous versions are in fact affected 🙁.

The good news: it was fixed in 2.34. The bad news: the official distribution packages aren't up-to-date. We will need to leave this for now...

Moving on... to quickly fix curl's vulnerability we could just remove it after using it, this way we can safely ignore that warning (Snyk's scans will still trigger the alert based on the image layer information).

I had to add one of the developer's PGP keys to the repo because `pgp.mit.edu` was timing out frequently and breaking the builds. Also added comments to `docker-entrypoint.sh`