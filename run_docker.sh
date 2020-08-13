docker rm -f rasa_container
docker build -t rasa_image .
# talk with shell
docker run -it rasa_image shell
docker run -it rasa_image run