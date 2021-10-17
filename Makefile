apply:
	@echo "Executando o provisionamento da infraestrutura"
	cd terraform && terraform init -backend-config=.config
	cd terraform && terraform apply -auto-approve

output-master-public-ip:
	cd terraform && terraform output master_ip_addr_public

output-nodes-public-ips:
	cd terraform && terraform output instance_ip_addr

destroy:
	@echo "Removendo o provisionamento da infraestrutura"
	cd terraform && terraform destroy --auto-approve

