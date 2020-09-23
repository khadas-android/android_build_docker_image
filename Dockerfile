FROM ubuntu:20.04
ARG userid=1001
ARG groupid=1001
ARG username=android
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update && apt upgrade -y && apt install -y git gnupg flex bison gperf build-essential zip curl wget zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
 lib32ncurses-dev x11proto-core-dev libx11-dev lib32z1-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip python-is-python2 openjdk-8-jdk libtinfo5 \
 libncurses5 bc rsync net-tools python3 && apt clean && rm -rf /var/lib/apt/lists/*
RUN curl -o jdk8.tgz https://android.googlesource.com/platform/prebuilts/jdk/jdk8/+archive/master.tar.gz \
 && tar -zxf jdk8.tgz linux-x86 \
 && mv linux-x86 /usr/lib/jvm/java-8-openjdk-amd64 \
 && rm -rf jdk8.tgz
RUN curl -o /usr/local/bin/repo https://storage.googleapis.com/git-repo-downloads/repo \
 && chmod a+x /usr/local/bin/repo
RUN wget https://releases.linaro.org/archive/13.11/components/toolchain/binaries/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux.tar.bz2 \
 && wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 \
 && mkdir -p /opt/toolchains && tar -xjf gcc-linaro-aarch64-none-elf-4.8-2013.11_linux.tar.bz2 -C /opt/toolchains \
 && tar -xjf gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 -C /opt/toolchains && rm -f gcc-linaro-aarch64-none-elf-4.8-2013.11_linux.tar.bz2 \
 && rm -f gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2
RUN wget https://releases.linaro.org/components/toolchain/binaries/6.3-2017.02/arm-linux-gnueabihf/gcc-linaro-6.3.1-2017.02-x86_64_arm-linux-gnueabihf.tar.xz \
 && wget https://releases.linaro.org/components/toolchain/binaries/6.3-2017.02/aarch64-linux-gnu/gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu.tar.xz \
 && mkdir -p /opt/toolchains && tar xvJf gcc-linaro-6.3.1-2017.02-x86_64_arm-linux-gnueabihf.tar.xz -C /opt/toolchains \
 && tar xvJf gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu.tar.xz -C /opt/toolchains && rm -f gcc-linaro-6.3.1-2017.02-x86_64_arm-linux-gnueabihf.tar.xz \
 && rm -f gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu.tar.xz
RUN mkdir -p $GITHUB_WORKSPACE/git_lfs && cd $GITHUB_WORKSPACE/git_lfs \
 && wget https://github.com/git-lfs/git-lfs/releases/download/v2.3.4/git-lfs-linux-amd64-2.3.4.tar.gz && tar xvzf git-lfs-linux-amd64-2.3.4.tar.gz \
 && cd git-lfs-2.3.4 && ./install.sh && git lfs install && cd $GITHUB_WORKSPACE && rm -rf $GITHUB_WORKSPACE/git_lfs
RUN groupadd -g $groupid $username \
 && useradd -m -u $userid -g $groupid $username \
 && echo $username >/root/username
ENV HOME=/home/$username
ENV USER=$username
ENV PATH="/usr/local/bin:/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/sbin:/opt/toolchains/gcc-linaro-aarch64-none-elf-4.8-2013.11_linux/bin:\
/opt/toolchains/gcc-arm-none-eabi-6-2017-q2-update/bin:/opt/toolchains/gcc-linaro-6.3.1-2017.02-x86_64_arm-linux-gnueabihf/bin:\
/opt/toolchains/gcc-linaro-6.3.1-2017.02-x86_64_aarch64-linux-gnu/bin"
