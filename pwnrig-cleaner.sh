#!/bin/bash

# Script para remover todos os servidores pwnrig
# Compatível com sistemas Unix (Linux, BSD, etc.)
# Autor: Sistema de Remoção de Malware
# Versão: 1.0

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para logging
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se está rodando como root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Este script deve ser executado como root (sudo)"
        exit 1
    fi
}

# Função para remover atributos imutáveis
remove_immutable_attrs() {
    log "Removendo atributos imutáveis dos arquivos pwnrig..."
    
    local files=(
        "/etc/cron.daily/pwnrig"
        "/etc/rc.d/init.d/pwnrig"
        "/etc/systemd/system/pwnrige.service"
        "/etc/cron.hourly/pwnrig"
        "/etc/cron.d/pwnrig"
        "/etc/cron.monthly/pwnrig"
        "/etc/cron.weekly/pwnrig"
        "/root/.bash_profile"
        "/usr/bin/crondr"
        "/usr/bin/initdr"
        "/usr/bin/sysdr"
        "/usr/bin/bprofr"
        "/usr/bin/gsd"
        "/usr/lib/systemd/system/pwnrigl.service"
    )
    
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            if chattr -ia "$file" 2>/dev/null; then
                log_success "Removido atributo imutável de: $file"
            else
                log_warning "Não foi possível remover atributo imutável de: $file"
            fi
        fi
    done
}

# Função para parar serviços
stop_services() {
    log "Parando serviços pwnrig..."
    
    local services=("pwnrige.service" "pwnrigl.service")
    
    for service in "${services[@]}"; do
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            if systemctl stop "$service"; then
                log_success "Serviço parado: $service"
            else
                log_error "Falha ao parar serviço: $service"
            fi
        else
            log "Serviço não estava ativo: $service"
        fi
    done
}

# Função para desabilitar serviços
disable_services() {
    log "Desabilitando serviços pwnrig..."
    
    local services=("pwnrige.service" "pwnrigl.service")
    
    for service in "${services[@]}"; do
        if systemctl is-enabled --quiet "$service" 2>/dev/null; then
            if systemctl disable "$service"; then
                log_success "Serviço desabilitado: $service"
            else
                log_error "Falha ao desabilitar serviço: $service"
            fi
        else
            log "Serviço não estava habilitado: $service"
        fi
    done
}

# Função para remover arquivos
remove_files() {
    log "Removendo arquivos pwnrig..."
    
    local files=(
        "/etc/cron.daily/pwnrig"
        "/etc/rc.d/init.d/pwnrig"
        "/etc/rc.d/rc0.d/K60pwnrig"
        "/etc/rc.d/rc1.d/K60pwnrig"
        "/etc/rc.d/rc2.d/S90pwnrig"
        "/etc/rc.d/rc3.d/S90pwnrig"
        "/etc/rc.d/rc4.d/S90pwnrig"
        "/etc/rc.d/rc5.d/S90pwnrig"
        "/etc/rc.d/rc6.d/K60pwnrig"
        "/etc/systemd/system/pwnrige.service"
        "/etc/cron.hourly/pwnrig"
        "/etc/cron.d/pwnrig"
        "/etc/cron.monthly/pwnrig"
        "/etc/cron.weekly/pwnrig"
        "/usr/bin/crondr"
        "/usr/bin/initdr"
        "/usr/bin/sysdr"
        "/usr/bin/bprofr"
        "/usr/bin/gsd"
        "/etc/systemd/system/multi-user.target.wants/pwnrige.service"
        "/etc/systemd/system/multi-user.target.wants/pwnrigl.service"
        "/usr/lib/systemd/system/pwnrigl.service"
        "/root/.bash_profile"
    )
    
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            if rm -f "$file"; then
                log_success "Arquivo removido: $file"
            else
                log_error "Falha ao remover arquivo: $file"
            fi
        fi
    done
}

# Função para remover chaves SSH suspeitas
remove_ssh_backdoors() {
    log "Removendo chaves SSH suspeitas..."
    
    local ssh_dirs=("/root/.ssh" "/home/*/.ssh")
    
    for dir in $ssh_dirs; do
        if [[ -d "$dir" ]]; then
            if [[ -f "$dir/authorized_keys" ]]; then
                # Fazer backup antes de remover
                cp "$dir/authorized_keys" "$dir/authorized_keys.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
                if rm -f "$dir/authorized_keys"; then
                    log_success "Chave SSH removida: $dir/authorized_keys"
                else
                    log_error "Falha ao remover chave SSH: $dir/authorized_keys"
                fi
            fi
        fi
    done
}

# Função para remover diretórios suspeitos
remove_suspicious_dirs() {
    log "Removendo diretórios suspeitos..."
    
    local dirs=(
        "/usr/local/src/.kthread/"
        "/usr/local/src/.gsd/"
        "/root/.ssh/.gsd/"
        "/tmp/.X12-unix/"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            if rm -rf "$dir"; then
                log_success "Diretório removido: $dir"
            else
                log_error "Falha ao remover diretório: $dir"
            fi
        fi
    done
}

# Função para procurar por processos pwnrig
kill_pwnrig_processes() {
    log "Procurando e matando processos pwnrig..."
    
    # Procurar por processos com nomes suspeitos
    local suspicious_names=("pwnrig" "crondr" "initdr" "sysdr" "bprofr" "gsd")
    
    for name in "${suspicious_names[@]}"; do
        local pids=$(pgrep -f "$name" 2>/dev/null || true)
        if [[ -n "$pids" ]]; then
            for pid in $pids; do
                if kill -9 "$pid" 2>/dev/null; then
                    log_success "Processo morto (PID $pid): $name"
                else
                    log_error "Falha ao matar processo (PID $pid): $name"
                fi
            done
        fi
    done
}

# Função para limpar crontab
clean_crontab() {
    log "Limpando entradas suspeitas do crontab..."
    
    # Backup do crontab atual
    if crontab -l 2>/dev/null > /tmp/crontab_backup.$(date +%Y%m%d_%H%M%S); then
        log "Backup do crontab criado"
    fi
    
    # Remover entradas com pwnrig
    if crontab -l 2>/dev/null | grep -v "pwnrig" | crontab -; then
        log_success "Crontab limpo de entradas pwnrig"
    else
        log_warning "Nenhuma entrada pwnrig encontrada no crontab"
    fi
}

# Função para verificar se a remoção foi bem-sucedida
verify_removal() {
    log "Verificando se a remoção foi bem-sucedida..."
    
    local check_files=(
        "/etc/cron.daily/pwnrig"
        "/etc/systemd/system/pwnrige.service"
        "/usr/bin/crondr"
        "/usr/bin/gsd"
    )
    
    local check_dirs=(
        "/usr/local/src/.kthread/"
        "/usr/local/src/.gsd/"
    )
    
    local found_remaining=false
    
    for file in "${check_files[@]}"; do
        if [[ -f "$file" ]]; then
            log_error "Arquivo ainda existe: $file"
            found_remaining=true
        fi
    done
    
    for dir in "${check_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            log_error "Diretório ainda existe: $dir"
            found_remaining=true
        fi
    done
    
    # Verificar processos
    local pids=$(pgrep -f "pwnrig|crondr|gsd" 2>/dev/null || true)
    if [[ -n "$pids" ]]; then
        log_error "Processos pwnrig ainda ativos: $pids"
        found_remaining=true
    fi
    
    if [[ "$found_remaining" == false ]]; then
        log_success "Verificação concluída: Nenhum resquício de pwnrig encontrado"
    else
        log_warning "Alguns arquivos/processos ainda podem existir"
    fi
}

# Função principal
main() {
    echo "=========================================="
    echo "  REMOVEDOR DE SERVIDORES PWNRIG"
    echo "=========================================="
    echo
    
    check_root
    
    log "Iniciando processo de remoção de servidores pwnrig..."
    
    # Executar todas as etapas de remoção
    remove_immutable_attrs
    stop_services
    disable_services
    kill_pwnrig_processes
    remove_files
    remove_ssh_backdoors
    remove_suspicious_dirs
    clean_crontab
    
    # Recarregar systemd
    if systemctl daemon-reload; then
        log_success "Systemd recarregado"
    fi
    
    # Verificação final
    verify_removal
    
    echo
    log_success "Processo de remoção concluído!"
    log "Recomenda-se reiniciar o sistema para garantir a remoção completa."
    echo
}

# Executar função principal
main "$@" 