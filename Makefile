.PHONY: all docker_unit_test test
.docker_build:
	docker build -t puppetlabs-postgresql-test .
docker_unit_test: .docker_build
	docker run -t puppetlabs-postgresql-test bundle exec rake spec
test: docker_unit_test
all: test
