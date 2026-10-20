.PHONY: install link brew update

install:            ## full setup
	bash bootstrap.sh

link:               ## re-symlink configs only (safe to re-run)
	bash bootstrap.sh --link-only

brew:
	brew bundle --file=Brewfile

update:
	brew update && brew upgrade && brew bundle --file=Brewfile
	-~/.tmux/plugins/tpm/bin/update_plugins all
