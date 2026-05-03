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
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/platforms/alpine/upgrade.sh)"
```

#### RESET

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/platforms/alpine/reset.sh)"
```

#### CONFIGURE-NFS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/platforms/alpine/configure-nfs.sh)"
```

#### CONFIGURE-TAILSCALE

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/platforms/alpine/configure-tailscale.sh)"
```

### PROXMOX

#### ENABLE GPU PASSTHROUGH

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/platforms/proxmox/enable_gpu_passthrough.sh)"
```

#### ENABLE TAILSCALE

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/platforms/proxmox/enable_tailscale.sh)"
```

## STACKS

### CORE

#### DOCKHAND

##### INSTALL

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/dockhand/install.sh)"
```

##### UNINSTALL

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/dockhand/uninstall.sh)"
```

#### DOCKTAIL

##### INSTALL

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/docktail/install.sh)"
```

##### UNINSTALL

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/docktail/uninstall.sh)"
```

#### ID

##### INSTALL

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/id/install.sh)"
```

##### UNINSTALL

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/stacks/core/id/uninstall.sh)"
```
