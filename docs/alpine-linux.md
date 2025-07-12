# GARAGELAB.launchpad

## ALPINE LINUX

### PRE-REQUISITE

```bash
doas apk add -U bash curl --quiet
```

### INSTALL

#### BASE

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/install-base.sh | bash
```

### CONFIGURE

#### NFS

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/configure-nfs.sh | bash
```

#### TAILSCALE

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/configure-tailscale.sh | bash
```

### UPGRADE

#### BASE

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/upgrade-base.sh | bash
```
