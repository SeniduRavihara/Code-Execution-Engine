FROM alpine:3.18

# Install basic tools and dependencies
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    unzip \
    ca-certificates \
    openssl \
    && update-ca-certificates

# Install Python 3
RUN apk add --no-cache \
    python3 \
    py3-pip

# Install OpenJDK 17 (Java)
RUN apk add --no-cache \
    openjdk17-jdk \
    openjdk17-jre

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH="$JAVA_HOME/bin:${PATH}"

# Set working directory
WORKDIR /runner

# Copy the execution script
COPY run-code.sh /usr/local/bin/run-code
RUN chmod +x /usr/local/bin/run-code

# Default command
ENTRYPOINT ["run-code"]