FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /demo && echo "Hello from inside the container!" > /demo/hello.txt
WORKDIR /demo

EXPOSE 80
CMD ["python3", "-m", "http.server", "80"]

