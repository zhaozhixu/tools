#! /bin/bash

ncpu=`cat /proc/cpuinfo | grep "processor" | sort | uniq | wc -l`
path_append=""
echo "Enter your password:"
read -s passwd

echo $passwd | sudo -S apt-get -y install build-essential cmake git wget unzip \
                    python python3 pkg-config python-dev python-numpy clang \
                    python3-dev python3-numpy libgtk2.0-dev libavcodec-dev \
                    libavformat-dev libswscale-dev libncurses-dev libtbb2 \
                    libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev \
                    libdc1394-22-dev
mkdir ~/Downloads ~/source

# install global and setup global tag database
(cd ~/Downloads && wget https://ftp.gnu.org/pub/gnu/global/global-6.6.tar.gz)
(cd ~/source && tar xvzf ~/Downloads/global-6.6.tar.gz)
(cd ~/source/global-6.6 && ./configure && make -j$ncpu \
     && echo $passwd | sudo -S make install -j$ncpu)
mkdir ~/.gtags
(cd ~/.gtags && ln -s /usr/include usr-include \
     && ln -s /usr/local/include usr-local-include \
     && ln -s /usr/src/linux-headers-`uname -r`/include linux-headers-include \
     && gtags -cv)
echo "export GTAGSLIBPATH=\$HOME/.gtags" >> ~/.bashrc

# install and setup emacs
(cd ~/Downloads && wget http://mirrors.ustc.edu.cn/gnu/emacs/emacs-25.3.tar.xz)
(cd ~/source && tar xvJf ~/Downloads/emacs-25.3.tar.xz)
(cd ~/source/emacs-25.3 && ./configure && make -j$ncpu \
     && echo $passwd | sudo -S make install -j$ncpu)
(cd ~/source && git clone https://github.com/zhaozhixu/emacs-config)
mkdir ~/.emacs.d
cp -r ~/source/emacs-config/* ~/.emacs.d

# install opencv
(cd ~/Downloads && wget https://github.com/opencv/opencv/archive/3.3.0.zip \
     && mv 3.3.0.zip opencv-3.3.0.zip)
(cd ~/source && unzip ~/Downloads/opencv-3.3.0.zip)
(cd ~/source/opencv-3.3.0 && mkdir build)
(cd ~/source/opencv-3.3.0/build \
     && cmake \
            -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_INSTALL_PREFIX=/usr/local \
            -DBUILD_opencv_python2=ON \
            -DBUILD_opencv_python3=ON \
            .. \
     && make -j$ncpu && echo $passwd | sudo -S make install -j$ncpu)
