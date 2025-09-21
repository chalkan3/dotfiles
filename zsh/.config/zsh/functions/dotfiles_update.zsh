# Dotfiles update and management functions

# Function to check for dotfiles updates and apply them
dotfiles-check-update() {
  log_step "Checking for Dotfiles Updates"
  local dotfiles_dir="${HOME}/dotfiles"

  if [ ! -d "$dotfiles_dir" ]; then
    log_error "Dotfiles directory not found at $dotfiles_dir. Please run the install.sh script first."
    return 1
  fi

  cd "$dotfiles_dir" || log_error "Failed to change directory to $dotfiles_dir."

  log_info "Fetching latest changes from remote..."
  git fetch || log_error "Failed to fetch updates from Git remote."

  local local_hash=$(git rev-parse @)
  local remote_hash=$(git rev-parse @{u})
  local base_hash=$(git merge-base @ @{u})

  if [ "$local_hash" = "$remote_hash" ]; then
    log_success "Your dotfiles are already up-to-date! 🦥"
  elif [ "$local_hash" = "$base_hash" ]; then
    log_warn "Updates available! Pulling changes..."
    git pull || log_error "Failed to pull dotfiles updates."
    log_success "Dotfiles updated! Now applying Salt states to reflect changes..."
    salt-apply-local # Call the salt function to re-apply states
    log_success "Dotfiles and system configuration updated successfully!"
  else
    log_warn "Your dotfiles have local changes. Please commit or stash them before updating."
    git status --short
  fi
  cd -
}

# Alias for the update function
alias dotup='dotfiles-check-update'
