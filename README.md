# 🖥️ Tuning e Hardening Linux Bare Metal

💡 **Objetivo:** melhorar desempenho, rede e segurança de servidores Linux físicos.  
* Ajustar parâmetros do kernel para servidores
* Reduzir superfície de ataque
* Manter compatibilidade com auditorias técnicas
* Fornecer mecanismo simples de validação

---

## ⚡ Compatibilidade

Este conjunto de ajustes é compatível com **Linux kernel 5.4 ou superior** e foi testado nos seguintes sistemas:

```diff
+ 🐧 Debian 11, 12, 13
+ 🐧 Ubuntu 20.04 LTS, 22.04 LTS, 24.04 LTS
+ 🖥️ Proxmox VE 7, 8, 9
+ 🐧 Rocky Linux 8, 9
+ 🐧 AlmaLinux 8, 9
+ 🐧 RHEL 8, 9
```

> Pode ser aplicado em **hosts físicos** ou ambientes **virtualizados**, mantendo compatibilidade com auditorias e estabilidade.

---

## 🛡️ Mini-Dashboard de Ajustes

### 🟢 Kernel Linux
```diff
+ Proteções de symlink/hardlink
+ Restrição de dmesg
+ ptrace limitado
+ ASLR forçado
- Ferramentas de debug podem ser impactadas
```

### 🟢 Filesystem
```diff
+ fs.file-max elevado
+ Core dumps setuid desativados
- Atenção à capacidade real do host
```

### 🟢 Memória
```diff
+ Swappiness baixo
+ mmap mínimo elevado
- Swap ainda necessária para estabilidade extrema
```

### 🟢 Scheduler
```diff
+ Autogroup desativado
+ Ajuste de migration cost
- Pode reduzir responsividade em sessões interativas
```

### 🟢 Rede IPv4
```diff
+ rp_filter ativado
+ Redirects e source routing desativados
+ Log de pacotes inválidos
- Não interfere no tráfego das VMs
```

### 🟢 Stack TCP
```diff
+ SYN cookies ativados
+ Redução de retries
+ Timeout controlado
- Host não deve ser usado como servidor de aplicação
```

### 🟢 ARP / Neighbor Cache
```diff
+ Limites elevados de gc_thresh
+ Intervalos menores
- Ajustar conforme número de VMs
```

### 🟢 IPv6
```diff
+ RA e redirects desativados
- Não afeta IPv6 interno das VMs
```

### 🟢 Virtualização
```diff
+ Kernel hardening padrão + KVM intacto
- Não substitui atualizações de segurança
```

---

## ⚙️ Estrutura do Projeto

```diff
📁 /etc/sysctl/99-custom.conf        + Ajustes de desempenho
📁 /etc/sysctl/99-hardening.conf     + Ajustes de segurança
📄 /bin/sysctl-check.sh              + Script de validação
```

> O prefixo `99-` garante que os ajustes sejam aplicados **por último**, sobrescrevendo arquivos genéricos ou da distribuição.

---

## ⚠️ Alertas e Rollback

```diff
- Teste sempre em ambiente controlado antes de produção
- Rollback: desfaça alterações com `sysctl --system` e restaure backups
+ Mitigações de Meltdown e Spectre permanecem ativas
+ Nenhum parâmetro depreciado é usado
+ Hardening aplicado sem impacto relevante de desempenho
```

---

✅ **Recomendação final:** Após aplicar os ajustes, **reinicie o equipamento** para efetivar todas as modificações.

---

✨ **Visual rápido:**  

- 🟢 Perfis ativos  
- 🎯 Efeitos principais  
- ⚠️ Alertas de rollback  
- Blocos `diff` simulam **cores verdes (+) e vermelhas (-)**  
- Cada bloco representa um **perfil isolado**, facilitando leitura e entendimento rápido do estado do host

---

⚠️ **Instalação / Install**

Script de instalação 

Installation script 

As instruções devem ser executadas como root, pois usuários comuns não têm acesso aos arquivos.

Instructions be performed as 'root', as normal users do not have access to the files.

wget https://raw.githubusercontent.com/projetoroot/tuning-host/refs/heads/main/install.sh

bash install.sh
