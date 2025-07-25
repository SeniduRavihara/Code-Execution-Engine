FROM openjdk:17-slim

# Create working directory
WORKDIR /code

# Copy run script into container
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Default command
ENTRYPOINT ["/run.sh"]
