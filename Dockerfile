# Use PyTorch CUDA runtime image
FROM pytorch/pytorch:2.10.0-cuda13.0-cudnn9-runtime

# Install system packages
RUN apt-get update && \
    apt-get install -y python3-venv python3-pip curl iptables sudo && \
    rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Create directories
RUN mkdir -p /var/run/tailscale
RUN mkdir -p /var/lib/tailscale

# Persist Tailscale state
VOLUME ["/var/lib/tailscale"]

# Set working directory
WORKDIR /app

# Copy app files
COPY . /app

# Create virtual environment
RUN python -m venv /opt/venv

# Use venv's Python and pip
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip and install dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 5000

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
