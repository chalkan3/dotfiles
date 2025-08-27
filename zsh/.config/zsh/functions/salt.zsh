# SaltStack related functions and aliases

# Function to apply Salt states locally
salt-apply-local() {
  log_info "Applying Salt states locally..."
  sudo salt-call --local --config-dir="~/dotfiles/salt" state.apply
  if [ $? -eq 0 ]; then
    log_success "Salt states applied successfully!"
  else
    log_error "Salt state application failed! Check the output above."
  fi
}

# Function to test Salt states locally (dry-run)
salt-test-local() {
  log_info "Testing Salt states locally (dry-run)..."
  sudo salt-call --local --config-dir="~/dotfiles/salt" state.apply test=True
  if [ $? -eq 0 ]; then
    log_success "Salt states test completed successfully!"
  else
    log_warn "Salt state test indicated changes or failures. Review the output."
  fi
}

# Function to run Salt highstate locally
salt-highstate-local() {
  log_info "Running Salt highstate locally..."
  sudo salt-call --local --config-dir="~/dotfiles/salt" state.highstate
  if [ $? -eq 0 ]; then
    log_success "Salt highstate completed successfully!"
  else
    log_error "Salt highstate failed! Check the output above."
  fi
}

# Function to restart salt-minion service
salt-minion-restart() {
  log_info "Restarting salt-minion service..."
  sudo systemctl restart salt-minion.service
  if [ $? -eq 0 ]; then
    log_success "salt-minion service restarted!"
  else
    log_error "Failed to restart salt-minion service."
  fi
}

# Function to restart salt-master service (if applicable)
salt-master-restart() {
  log_info "Restarting salt-master service..."
  sudo systemctl restart salt-master.service
  if [ $? -eq 0 ]; then
    log_success "salt-master service restarted!"
  else
    log_error "Failed to restart salt-master service. (Is salt-master installed and running?)"
  fi
}

# Aliases for common Salt commands
alias scl='salt-call'
alias scll='salt-call --local'
alias sclt='salt-call --local test=True'
alias sclh='salt-call --local state.highstate'

# Aliases for custom functions
alias s-apply='salt-apply-local'
alias s-test='salt-test-local'
alias s-high='salt-highstate-local'
alias s-min-res='salt-minion-restart'
alias s-mas-res='salt-master-restart'
