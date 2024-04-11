gradle-build:
	docker run --rm -u gradle -v $(PWD):/home/gradle/project -w /home/gradle/project gradle:8-jdk17 gradle build -x test

build-image: gradle-build
	docker build -t prueba-ms .

run:
	docker run --rm -p 9091:9091 --name prueba-ms prueba-ms