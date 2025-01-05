# Pollux

```plaintext
__/\\\\\\\\\\\\\__________________/\\\\\\_____/\\\\\\________________________________
 _\/\\\/////////\\\_______________\////\\\____\////\\\________________________________
  _\/\\\_______\/\\\__________________\/\\\_______\/\\\________________________________
   _\/\\\\\\\\\\\\\/______/\\\\\_______\/\\\_______\/\\\_____/\\\____/\\\__/\\\____/\\\_
    _\/\\\/////////______/\\\///\\\_____\/\\\_______\/\\\____\/\\\___\/\\\_\///\\\/\\\/__
     _\/\\\______________/\\\__\//\\\____\/\\\_______\/\\\____\/\\\___\/\\\___\///\\\/____
      _\/\\\_____________\//\\\__/\\\_____\/\\\_______\/\\\____\/\\\___\/\\\____/\\\/\\\___
       _\/\\\______________\///\\\\\/____/\\\\\\\\\__/\\\\\\\\\_\//\\\\\\\\\___/\\\/\///\\\_
        _\///_________________\/////_____\/////////__\/////////___\/////////___\///____\///__
```

## Description

Pollux is a cybersecurity tool that allows small and medium-sized businesses to perform security audits on their infrastructure. It is a simple and automated solution that does not require advanced computer or cybersecurity skills.

### Context

In 2022, 347,000 cyberattacks were recorded against companies, of which approximately 330,000 targeted SMEs. These small and medium-sized enterprises are often vulnerable due to the lack of specialized cybersecurity resources. A study conducted by ANSSI reveals that 72% of SMEs do not have a formalized cybersecurity strategy. The lack of accessible and easy-to-deploy tools makes it difficult for these companies to continuously assess the security of their servers. It is therefore crucial to develop a solution that allows SMEs to perform security audits in an automated manner and without requiring advanced computer or cybersecurity skills.

### Objectives

The main objective of Pollux is to provide a simple and automated solution for small and medium-sized businesses to perform security audits on their infrastructure. The tool should be easy to deploy and use, and should not require advanced computer or cybersecurity skills. The tool should be able to scan the company's servers and identify potential vulnerabilities, misconfigurations, and security weaknesses. The tool should provide a detailed report of the audit results, including recommendations for improving the security of the infrastructure.

## Technical Stack

### Presentation

Pollux is made of a Python wrapper that orchestrate the scripts execution. The scripts are written in Powershell and Bash. The results of each script are stored in a temporary file. The Python wrapper then reads the results and generates a report in markdown format.

## Installation

There are two ways to install Pollux: usage installation and development installation. The usage installation is intended for users who want to use Pollux to perform security audits on their infrastructure. The development installation is intended for developers who want to contribute to the development of Pollux.

### Usage Installation

To install Pollux for usage, follow these steps:

1. Clone the Pollux repository:

```bash
git clone
```

2. Run the installation script:

```bash
# (Linux)
cd pollux
./install.sh

# (Windows)
cd pollux
install.ps1
```

### Development Installation

To install Pollux for development, follow these steps:

1. Clone the Pollux repository:

```bash
git clone
```

2. Run the development installation script:

```bash
cd pollux
poetry install
poetry shell
```

## Authors

|        Name         |    GitHub     |             Mail             |
| :-----------------: | :-----------: | :--------------------------: |
|   Tristan Querton   |  tristanqtn   |  tristan.querton@edu.ece.fr  |
| Xavier de la Chaise |    Hioav2     | xavier.delachaise@edu.ece.fr |
|  Lucie Lagarrigue   |    Luxlag     | lucie.lagarrigue@edu.ece.fr  |
|   Antoine Herman    | AntoineHerman |  antoine.herman@edu.ece.fr   |
|     Evan Debray     |    EvanDbr    |    evan.debray@edu.ece.fr    |
|  Théophile Broqua   |  TheoLeDozo   | theophile.broqua@edu.ece.fr  |
