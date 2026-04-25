# GARAGELAB.launchpad

## PLATFORMS

### ALPINE-LINUX

#### PRE-REQUISITE

```bash
doas apk add -U bash curl --quiet
```

#### INSTALL

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/platforms/alpine/install.sh)"
```

#### UPGRADE

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/upgrade.sh)"
```

#### RESET

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/reset.sh)"
```

#### CONFIGURE-NFS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/configure-nfs.sh)"
```

#### CONFIGURE-TAILSCALE

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/configure-tailscale.sh)"
```
