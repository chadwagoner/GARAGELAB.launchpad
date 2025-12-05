# GARAGELAB.launchpad

## ALPINE LINUX

### PRE-REQUISITE

```bash
brew install macpine
```

### LOCAL DEV

#### BUILD

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/local-build.sh | bash
```

#### DESTROY

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/alpine-linux/local-destroy.sh | bash
```

### INSTALL

#### PRE-REQUISITE

```bash
doas apk add -U bash curl --quiet
```

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

## FEDORA

### INSTALL

#### BASE

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/fedora/install-base.sh | bash
```

## CORE - SERVICES

### BESZEL

#### INSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/beszel/install.sh | bash
```

#### UNINSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/beszel/uninstall.sh | bash
```

### HOMARR

#### INSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/homarr/install.sh | bash
```

#### UNINSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/homarr/uninstall.sh | bash
```

### KOMODO

#### INSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/komodo/install.sh | bash
```

#### UNINSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/komodo/uninstall.sh | bash
```

### POCKET-ID

#### INSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/id/install.sh | bash
```

#### UNINSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/id/uninstall.sh | bash
```

### TSBRIDGE

#### INSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/tsbridge/install.sh | bash
```

#### UNINSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-services/tsbridge/uninstall.sh | bash
```

## CORE - AGENTS

### BESZEL-AGENT

#### INSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-agents/beszel-agent/install.sh | bash
```

#### UNINSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-agents/beszel-agent/uninstall.sh | bash
```

### KOMODO-AGENT

#### INSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-agents/komodo-agent/install.sh | bash
```

#### UNINSTALL

```bash
curl -sL -H 'Cache-Control: no-cache, no-store' https://raw.githubusercontent.com/chadwagoner/GARAGELAB.launchpad/main/core-agents/komodo-agent/uninstall.sh | bash
```
