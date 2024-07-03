#!/usr/bin/env bash

OS="$(uname -s)"
case "${OS}" in
    Linux*)
        if [ -f /etc/redhat-release ]; then
            sudo dnf install -y ansible
        elif [ -f /etc/lsb-release ]; then
            sudo apt-get update
	    sudo apt-get install -y ansible
        else
            echo "Unsupported Linux distribution"
            exit 1
        fi
        ;;
    Darwin*)
        brew install ansible
        ;;
    *)
        echo "Unsupported operating system: ${OS}"
        exit 1
        ;;
esac

ansible-playbook ~/.bootstrap/setup.yaml --ask-become-pass

echo "Ansible installation complete."
