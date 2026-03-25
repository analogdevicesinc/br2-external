BUILDROOT_VERSION ?= 2026.02
BUILDROOT_URL ?= https://github.com/buildroot/buildroot.git
BUILDROOT_DIR ?= $(CURDIR)/buildroot

BR2_EXTERNAL := $(CURDIR)
BUILDROOT_PATCHES := $(sort $(wildcard $(CURDIR)/patches/buildroot/*.patch))

# Targets handled locally, not forwarded to buildroot
buildroot: ## Clone and patch buildroot
	@if [ ! -d $(BUILDROOT_DIR)/.git ]; then \
		echo "Cloning buildroot $(BUILDROOT_VERSION)..."; \
		git clone --depth 1 --branch $(BUILDROOT_VERSION) \
			$(BUILDROOT_URL) $(BUILDROOT_DIR); \
	fi
	$(MAKE) buildroot-patch

buildroot-patch: ## Apply patches to buildroot
	@for p in $(BUILDROOT_PATCHES); do \
		if git -C $(BUILDROOT_DIR) apply --check "$$p" 2>/dev/null; then \
			echo "Applying $$(basename $$p)..."; \
			git -C $(BUILDROOT_DIR) apply "$$p" || exit 1; \
		else \
			echo "Skipping $$(basename $$p) (already applied or conflicts)"; \
		fi; \
	done

buildroot-clean: ## Remove the buildroot directory
	rm -rf $(BUILDROOT_DIR)

# Everything else is forwarded to buildroot
.DEFAULT_GOAL := help

# This is the forwarding rule: any target not defined above
# gets passed through to buildroot's Makefile
.DEFAULT:
	@test -d $(BUILDROOT_DIR) || { echo "Run 'make buildroot' first"; exit 1; }
	$(MAKE) -C $(BUILDROOT_DIR) BR2_EXTERNAL="$(BR2_EXTERNAL)" $(MAKECMDGOALS)

.PHONY: buildroot buildroot-patch buildroot-clean
