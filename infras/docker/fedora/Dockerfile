# Use the official Fedora image as the base image
FROM fedora:latest

# Install Git and Python 3.12
RUN dnf update -y && \
    dnf install -y git python3.12 && \
    dnf clean all

# Set Python 3.12 as the default python3
RUN alternatives --set python3 /usr/bin/python3.12

# Verify installations
RUN git --version && python3 --version

# Set the working directory
WORKDIR /app

# Default command
CMD ["bash"]