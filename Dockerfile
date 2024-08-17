FROM ubuntu:latest AS ubuntu

ARG USERNAME=dockeruser

RUN apt update && apt upgrade -y
RUN apt install -y sudo

RUN useradd -m $USERNAME -G sudo && id $USERNAME
RUN echo "$USERNAME:user" | chpasswd
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER dockeruser

WORKDIR /home/dockeruser
COPY . dotfiles

CMD ["/bin/bash"]


FROM archlinux:latest AS arch

ARG USERNAME=dockeruser

RUN pacman -Syu --noconfirm
RUN pacman -S sudo --noconfirm

RUN useradd -m -g wheel $USERNAME
RUN echo "$USERNAME:user" | chpasswd
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER dockeruser

WORKDIR /home/dockeruser
COPY . dotfiles

CMD ["/bin/bash"]
