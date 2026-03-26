# Use PyTorch CUDA runtime image
FROM pytorch/pytorch:2.10.0-cuda13.0-cudnn9-runtime

# Install system packages
RUN apt-get update && \
    apt-get install -y python3-venv python3-pip curl && \
    apt-get install -y curl iptables sudo && \
    rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Create directory for Tailscale socket
RUN mkdir -p /var/run/tailscale

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

# Start tailscale and server at runtime
CMD ["sh", "-c", "tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock & sleep 2 && tailscale --socket=/var/run/tailscale/tailscaled.sock up --authkey=$TAIL_SCALE_AUTH_KEY --accept-routes --hostname=gpu-container && bash"]
