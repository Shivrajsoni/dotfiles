.PHONY: install link brew toolchain update

install: brew link toolchain
	@[ "$$(uname)" = "Darwin" ] && bash scripts/macos-defaults.sh || true

brew:
	brew bundle --file=Brewfile

link:
	bash bootstrap.sh --link-only

toolchain:
	bash scripts/dev-toolchain.sh

update:
	brew upgrade && brew bundle --file=Brewfile
	tmux run-shell '~/.tmux/plugins/tpm/bin/update_plugins all' 2>/dev/null || true
