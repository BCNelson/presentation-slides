FROM archlinux:latest

RUN pacman -Sy

RUN pacman -S tree archiso pacman-contrib reflector --noconfirm

COPY ./build.sh root/

RUN ["chmod", "+x", "root/build.sh"]

ENTRYPOINT ["./root/build.sh"]