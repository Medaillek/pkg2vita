FROM archlinux:base

# Disable interactive prompts and cache
RUN echo 'Verity = Off' >> /etc/pacman.conf && \
    pacman -Sy --noconfirm --needed pacman git base-devel 7zip python

# Build and install pkg2zip from AUR PKBUILD
RUN git clone https://aur.archlinux.org/pkg2zip.git /aur/pkg2zip && \
    cd /aur/pkg2zip && \
    makepkg -sri --noconfirm && \
    rm -rf /aur

COPY unpack.py /unpack.py

RUN rm -rf /var/cache/pacman/pkg /var/lib/pacman/sync

WORKDIR /zip

CMD ["python", "/unpack.py", "/zip"]
