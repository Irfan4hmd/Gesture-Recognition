# Base image optimized for Jetson Nano (L4T)
FROM nvcr.io/nvidia/l4t-ml:r32.6.1-py3

# Set working directory
WORKDIR /app

# Install system dependencies for OpenCV and TTS
RUN apt-get update && apt-get install -y \
    libsm6 \
    libxext6 \
    libxrender-dev \
    espeak \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy source code and config
COPY src/ src/
COPY config/ config/
COPY models/ models/

# Run the application
CMD ["python3", "src/main.py"]
