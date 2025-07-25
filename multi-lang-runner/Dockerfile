FROM ubuntu:22.04

# Install needed tools
RUN apt-get update && apt-get install -y \
    python3 \
    openjdk-17-jdk \
    curl unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Ballerina (headless)
RUN curl -sL https://dist.ballerina.io/downloads/2201.9.0/ballerina-2201.9.0-swan-lake-linux-x64.deb -o ballerina.deb \
    && apt install -y ./ballerina.deb \
    && rm ballerina.deb

# Set up working dir
WORKDIR /runner
COPY run-code.sh /usr/local/bin/run-code
RUN chmod +x /usr/local/bin/run-code

ENTRYPOINT ["run-code"]
