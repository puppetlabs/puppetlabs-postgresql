test:
	docker build -t puppetlabs-postgresql-test . && docker run -t puppetlabs-postgresql-test
