# Use the latest Windows Server Core image
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Install Chocolatey
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Git
RUN choco install git -y

# Install Python 3.12
RUN choco install python --version=3.12.0 -y

# Add Python to PATH
RUN setx PATH "%PATH%;C:\Python312;C:\Python312\Scripts"

# Verify installations
RUN git --version && python --version

# Set the working directory
WORKDIR /app

# Default command
CMD ["cmd"]