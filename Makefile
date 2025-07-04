.PHONY: install split merge split-check merge-check

# Install dependencies using forge soldeer
install:
	cd cfm-v1 && forge soldeer install

# Split and wrap tokens using the provided config file
# Usage: make split filepath=path/to/config.json -- [additional forge script arguments]
# Example: make split filepath=split-wrap-morpho.json -- --private-key $$PRIVATE_KEY -vvvv
split:
	@if [ -z "$(filepath)" ]; then \
		echo "Error: filepath is required. Usage: make split filepath=path/to/config.json"; \
		exit 1; \
	fi
	cd cfm-v1 && CONFIG_PATH=../$(filepath) forge script script/SplitAndWrap.s.sol:SplitAndWrap --rpc-url $$RPC_URL --broadcast $(filter-out $@,$(MAKECMDGOALS))

# Unwrap and merge tokens using the provided config file
# Usage: make merge filepath=path/to/config.json -- [additional forge script arguments]
# Example: make merge filepath=split-wrap-morpho.json -- --private-key $$PRIVATE_KEY -vvvv
merge:
	@if [ -z "$(filepath)" ]; then \
		echo "Error: filepath is required. Usage: make merge filepath=path/to/config.json"; \
		exit 1; \
	fi
	cd cfm-v1 && CONFIG_PATH=../$(filepath) forge script script/UnwrapAndMerge.s.sol:UnwrapAndMerge --rpc-url $$RPC_URL --broadcast $(filter-out $@,$(MAKECMDGOALS))

# Check split and wrap status for the provided config file
# Usage: make split-check filepath=path/to/config.json -- [additional forge script arguments]
split-check:
	@if [ -z "$(filepath)" ]; then \
		echo "Error: filepath is required. Usage: make split-check filepath=path/to/config.json"; \
		exit 1; \
	fi
	cd cfm-v1 && CONFIG_PATH=../$(filepath) forge script script/SplitAndWrap.s.sol:SplitAndWrapCheck --rpc-url $$RPC_URL $(filter-out $@,$(MAKECMDGOALS))

# Check unwrap and merge status for the provided config file
# Usage: make merge-check filepath=path/to/config.json -- [additional forge script arguments]
merge-check:
	@if [ -z "$(filepath)" ]; then \
		echo "Error: filepath is required. Usage: make merge-check filepath=path/to/config.json"; \
		exit 1; \
	fi
	cd cfm-v1 && CONFIG_PATH=../$(filepath) forge script script/UnwrapAndMerge.s.sol:UnwrapAndMergeCheck --rpc-url $$RPC_URL $(filter-out $@,$(MAKECMDGOALS))

# This allows us to accept extra arguments after --
%:
	@:
