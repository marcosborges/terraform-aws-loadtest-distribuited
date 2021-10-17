apply:
	@echo "Executando o provisionamento da infraestrutura"
	cd src/terraform && terraform init -backend-config=.config
	cd src/terraform && terraform apply -auto-approve

output-master-public-ip:
	cd src/terraform && terraform output master_ip_addr_public

output-nodes-public-ips:
	cd src/terraform && terraform output instance_ip_addr

destroy:
	@echo "Removendo o provisionamento da infraestrutura"
	cd src/terraform && terraform destroy --auto-approve

