# 🛡️ PwnRig Cleaner

Ferramenta de segurança para **detecção e remoção completa do malware minerador PwnRig** em sistemas Linux.

O **PwnRig Cleaner** é um script automatizado que identifica e remove processos, serviços persistentes, cronjobs e arquivos associados ao **malware de mineração de criptomoedas PwnRig/XMRig**, frequentemente utilizado em ataques a servidores comprometidos.

O objetivo do projeto é **restaurar a integridade do sistema**, eliminando mecanismos de persistência utilizados por mineradores maliciosos.

---

# ⚠️ Sobre o PwnRig

O **PwnRig** é um tipo de **malware minerador de criptomoedas** que utiliza recursos do servidor comprometido para mineração, geralmente da moeda **Monero (XMR)**.

Ele costuma se instalar utilizando mecanismos de persistência como:

* serviços `systemd`
* tarefas `cron`
* processos disfarçados
* arquivos ocultos
* scripts de inicialização

Esses mineradores podem consumir **CPU e memória excessivamente**, degradando o desempenho do servidor.

---

# 🚀 Funcionalidades

O script realiza diversas verificações e ações de limpeza:

* 🔍 Detecção de processos suspeitos
* ❌ Finalização de processos maliciosos
* 🧹 Remoção de serviços `systemd`
* 🧹 Remoção de cronjobs persistentes
* 🧹 Exclusão de arquivos maliciosos
* 🔒 Verificação de diretórios suspeitos
* ⚙️ Limpeza automática de artefatos comuns de mineradores

---

# 📦 Estrutura do Projeto

```text
pwnrig-cleaner/
│
├── pwnrig-cleaner.sh
└── README.md
```

---

# 🖥️ Sistemas Suportados

Distribuições Linux baseadas em:

* Ubuntu
* Debian
* CentOS
* Rocky Linux
* AlmaLinux
* Fedora
* Arch Linux

---

# ⚙️ Requisitos

* Linux
* Permissões **root**
* Bash

---

# 📥 Instalação

Clone o repositório:

```bash
git clone https://github.com/SEU-USUARIO/pwnrig-cleaner.git
cd pwnrig-cleaner
```

Dê permissão de execução ao script:

```bash
chmod +x pwnrig-cleaner.sh
```

---

# ▶️ Uso

Execute o script como **root**:

```bash
sudo ./pwnrig-cleaner.sh
```

O script irá automaticamente:

1. Identificar processos suspeitos
2. Encerrar os processos maliciosos
3. Remover serviços persistentes
4. Limpar cronjobs infectados
5. Apagar arquivos associados ao malware

---

# 🔎 Exemplos de Indicadores de Comprometimento (IOC)

Alguns sinais comuns de infecção por mineradores:

* CPU constantemente em **100%**
* Processos suspeitos como:

```
kdevtmpfsi
pwnrig
xmrig
kinsing
```

* Conexões para pools de mineração
* Serviços ocultos no `systemd`
* Cronjobs desconhecidos

---

# 🧪 Verificação Manual

Após executar a ferramenta, recomenda-se verificar manualmente:

### Processos ativos

```bash
ps aux | grep -E "xmrig|pwnrig|kdevtmpfsi"
```

### Serviços suspeitos

```bash
systemctl list-units --type=service
```

### Cronjobs

```bash
crontab -l
```

---

# 🔐 Boas Práticas de Segurança

Para evitar reinfecção:

* Atualizar o sistema regularmente
* Desativar login SSH por senha
* Utilizar **chaves SSH**
* Instalar **Fail2Ban**
* Utilizar firewall (`ufw` ou `iptables`)
* Monitorar processos com ferramentas como:

```
htop
top
netstat
ss
```

---

# 📈 Casos de Uso

Esta ferramenta pode ser utilizada para:

* Limpeza de servidores comprometidos
* Auditoria de segurança em VPS
* Hardening de sistemas Linux
* Investigação de malware
* Ambientes DevOps e SOC

---

# 🤝 Contribuição

Contribuições são bem-vindas!

1. Faça um fork do projeto
2. Crie uma branch

```bash
git checkout -b minha-feature
```

3. Commit suas alterações

```bash
git commit -m "feat: nova melhoria"
```

4. Faça push

```bash
git push origin minha-feature
```

5. Abra um Pull Request.

---

# 📜 Licença

Este projeto está licenciado sob a **MIT License**.

---

# 👨‍💻 Autor

**Wellinghton Fernando Armoa Pimenta**

* Bacharelado em Ciência da Computação — UFMT
* Segurança de Redes
* Infraestrutura Linux
* DevOps e Automação
* Segurança de Sistemas
