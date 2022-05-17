.PHONY: up
up: ## Start container
	docker-compose up -d

.PHONY: j
j: ## Jupyter Notebook 起動
	docker-compose exec app jupyter notebook --allow-root --ip=0.0.0.0
