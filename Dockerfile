ARG USERNAME=dockeruser


# Ubuntu
FROM ubuntu:latest AS ubuntu

ARG USERNAME

RUN apt update && apt upgrade -y
RUN apt install -y sudo

RUN useradd -m $USERNAME -G sudo && id $USERNAME
RUN echo "$USERNAME:user" | chpasswd
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME

WORKDIR /home/$USERNAME

CMD ["/bin/bash"]


# Ubuntu with Homebrew
FROM ubuntu AS ubuntu-brew

ARG USERNAME

RUN sudo apt install -y curl git
RUN sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"


# Arch Linux
FROM archlinux:latest AS arch

ARG USERNAME

RUN pacman -Syu --noconfirm
RUN pacman -S sudo --noconfirm

RUN useradd -m -g wheel $USERNAME
RUN echo "$USERNAME:user" | chpasswd
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USERNAME

WORKDIR /home/$USERNAME

CMD ["/bin/bash"]
