#!/bin/bash
###############################################################################
# Instala tuning-host
# Autor: Diego Costa (@diegocostaroot) / Projeto Root (youtube.com/projetoroot)
# Versão: 1.0
# Veja o link: https://wiki.projetoroot.com.br
# 2026
###############################################################################

set -euo pipefail

# URLs dos arquivos
URL_CUSTOM="https://raw.githubusercontent.com/projetoroot/tuning-host/refs/heads/main/99-custom.conf"
URL_HARDENING="https://raw.githubusercontent.com/projetoroot/tuning-host/refs/heads/main/99-hardening.conf"
URL_CHECK="https://raw.githubusercontent.com/projetoroot/tuning-host/refs/heads/main/sysctl-check.sh"

# Destinos
DEST_CUSTOM="/etc/sysctl.d/99-custom.conf"
DEST_HARDENING="/etc/sysctl.d/99-hardening.conf"
DEST_CHECK="/bin/sysctl-check.sh"

# Função para baixar arquivo
download_file() {
    local url="$1"
    local dest="$2"
    echo "Baixando $url para $dest..."
    wget -q -O "$dest" "$url"
}

# Baixar arquivos
download_file "$URL_CUSTOM" "$DEST_CUSTOM"
download_file "$URL_HARDENING" "$DEST_HARDENING"
download_file "$URL_CHECK" "$DEST_CHECK"

# Garantir permissões corretas
chmod 644 "$DEST_CUSTOM" "$DEST_HARDENING"
chmod +x "$DEST_CHECK"

# Aplicar configurações
echo "Aplicando configurações do sysctl..."
sysctl --system

# Verificar configurações
echo "Verificando configurações aplicadas..."
"$DEST_CHECK"

echo "Processo concluído com sucesso."
