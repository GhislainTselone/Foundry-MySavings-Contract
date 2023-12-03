-include .env

deploy_mumbai:; forge script script/DeployMySavings.s.sol --rpc-url $(MUMBAI_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
fund_mySavings:; forge script script/Interactions.s.sol:FundMySavings --rpc-url $(MUMBAI_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
withdraw_mySavings:; forge script script/Interactions.s.sol:WithdrawFromMySavings --rpc-url $(MUMBAI_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast