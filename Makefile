
run-minio:
	mkdir -p tmp/data
	@echo "Do this"
	@echo "export AWS_CONFIG_FILE=`pwd`/local-minio-profile.conf"
	@echo "export GIT_OBJECTSTORE_ENDPOINT=http://localhost:9000"
	@echo "export GIT_OBJECTSTORE_DEBUG=1"

	docker run -ti \
		-p 9000:9000 \
		-e "MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE" \
  		-e "MINIO_SECRET_KEY=xxxxxxxxxx" \
		-v `pwd`/tmp/data:/data \
		minio/minio \
		server /data

test:
	cd test && ./pull.sh && ./push.sh  && ./clone.sh

.PHONY: test
