FROM ballerina/ballerina:2201.9.0

WORKDIR /app

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["echo \"$0\" > main.bal && bal run main.bal", "--"]
