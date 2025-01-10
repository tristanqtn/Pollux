# Use the official Ubuntu base image
FROM ubuntu:latest

# Update the package list and install necessary packages
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y git python3.12 python3.12-venv python3.12-dev && \
    apt-get clean

# Set Python 3.12 as the default python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1

# Verify installations
RUN git --version && python3 --version

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Command to run when the container starts
CMD ["bash"]