#!/bin/bash

echo "Validação de sysctl - tuning e hardening"
echo "Host: $(hostname)"
echo "Data: $(date)"
echo

FAIL=0

check() {
    local key="$1"
    local expected="$2"

    current=$(sysctl -n "$key" 2>/dev/null)

    if [ "$current" = "$expected" ]; then
        printf "[ OK ] %-45s = %s\n" "$key" "$current"
    else
        printf "[FAIL] %-45s esperado: %s | atual: %s\n" "$key" "$expected" "${current:-N/A}"
        FAIL=1
    fi
}

echo "== Kernel hardening =="
check fs.protected_hardlinks 1
check fs.protected_symlinks 1
check fs.protected_fifos 1
check fs.protected_regular 1
check kernel.dmesg_restrict 1
check kernel.kptr_restrict 2
check fs.suid_dumpable 0
check kernel.yama.ptrace_scope 1
check kernel.randomize_va_space 2
check vm.mmap_min_addr 65536

echo
echo "== Rede IPv4 =="
check net.ipv4.conf.all.rp_filter 1
check net.ipv4.conf.default.rp_filter 1
check net.ipv4.conf.all.accept_redirects 0
check net.ipv4.conf.default.accept_redirects 0
check net.ipv4.conf.all.send_redirects 0
check net.ipv4.conf.default.send_redirects 0
check net.ipv4.conf.all.accept_source_route 0
check net.ipv4.conf.default.accept_source_route 0
check net.ipv4.tcp_syncookies 1
check net.ipv4.icmp_echo_ignore_broadcasts 1
check net.ipv4.icmp_ignore_bogus_error_responses 1
check net.ipv4.conf.all.log_martians 1
check net.ipv4.conf.default.log_martians 1
check net.ipv4.tcp_rfc1337 1
check net.ipv4.tcp_timestamps 1

echo
echo "== Rede IPv6 =="
check net.ipv6.conf.all.accept_redirects 0
check net.ipv6.conf.default.accept_redirects 0
check net.ipv6.conf.all.accept_ra 0
check net.ipv6.conf.default.accept_ra 0

echo
echo "== Tuning essencial =="
check fs.file-max 1048576
check vm.swappiness 1
check net.core.somaxconn 65535
check net.ipv4.tcp_fin_timeout 10
check net.ipv4.tcp_tw_reuse 1
check net.ipv4.tcp_slow_start_after_idle 0

echo
if [ $FAIL -eq 0 ]; then
    echo "Resultado final: TODOS OS PARÂMETROS ESTÃO CORRETOS"
    exit 0
else
    echo "Resultado final: EXISTEM PARÂMETROS FORA DO PADRÃO"
    exit 1
fi
