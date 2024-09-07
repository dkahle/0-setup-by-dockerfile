FROM ubuntu:22.04

# update, upgrade
RUN apt update && apt -y upgrade

# install necessary packages
RUN yes | unminimize 
RUN apt install -y man vim nano sudo tldr git wget zsh tree texlive lsb-release

# setup tldr
RUN mkdir -p /root/.local/share/tldr
RUN tldr -u

# setup zsh (ohmyzsh)
RUN yes | sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
RUN exit
RUN sed -i 's/robbyrussell/af-magic/' ~/.zshrc
RUN sed -i '22s/..-./.. ./' /root/.oh-my-zsh/themes/af-magic.zsh-theme

# setup student account
RUN useradd --create-home student
RUN printf "student:a" | chpasswd
RUN usermod -aG sudo student

# setup student zsh
RUN chsh --shell /bin/zsh student
RUN cp /root/.zshrc /home/student/.zshrc
RUN cp -r /root/.oh-my-zsh /home/student/.oh-my-zsh

# setup student tldr
USER student
RUN cd ~
RUN mkdir -p ~/.local/share/tldr
RUN tldr -u

# run command
CMD ["zsh"]