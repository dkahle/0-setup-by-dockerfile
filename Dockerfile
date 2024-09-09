FROM ubuntu:22.04

# update, upgrade
RUN apt update && apt -y upgrade

# install necessary packages
RUN yes | unminimize 
RUN apt install -y \
  man-db \
  vim \ 
  nano \
  sudo \
  tldr \
  git \
  wget \
  zsh \
  tree \
  texlive \
  lsb-release \
  gpg # for eza # https://eza.rocks

# setup tldr
RUN mkdir -p /root/.local/share/tldr
RUN tldr -u

# setup zsh (ohmyzsh)
RUN yes | sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
RUN exit
RUN sed -i 's/robbyrussell/af-magic/' ~/.zshrc
RUN sed -i '22s/..-./.. ./' /root/.oh-my-zsh/themes/af-magic.zsh-theme

# setup student eza, https://eza.rocks
RUN mkdir -p /etc/apt/keyrings
RUN wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | \
  gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | \
  tee /etc/apt/sources.list.d/gierens.list
RUN chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
RUN apt update
RUN apt install -y eza

# setup student account
RUN useradd --create-home student
RUN printf "student:a" | chpasswd
RUN usermod -aG sudo student

# setup student zsh
RUN chsh --shell /bin/zsh student
RUN cp /root/.zshrc /home/student/.zshrc
RUN cp -r /root/.oh-my-zsh /home/student/.oh-my-zsh
RUN chown -R student /home/student/.oh-my-zsh
RUN chown student /home/student/.zshrc

# setup a few student aliases
RUN echo "alias ls='eza'" >> /home/student/.zshrc
RUN echo "alias ll='eza -alF'" >> /home/student/.zshrc

# setup student tldr
USER student
WORKDIR /home/student
RUN mkdir -p ~/.local/share/tldr
RUN tldr -u

# run command
CMD ["zsh"]