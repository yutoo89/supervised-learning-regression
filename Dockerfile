FROM python:3.9-buster
USER root

RUN apt-get update
RUN apt-get -y install locales && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ JST-9
ENV TERM xterm

# 日本語 font のインストール
RUN apt-get install -y fonts-noto-cjk

RUN apt-get install -y vim less
RUN apt install -y graphviz
RUN pip install --upgrade pip
RUN pip install --upgrade setuptools

RUN python -m pip install \
    pandas \
    matplotlib \
    seaborn \
    numpy \
    scipy \
    ipython \
    scikit-learn \
    mglearn \
    jupyterlab \
    graphviz \
    tabulate \
    notebook \
    jupyter-contrib-nbextensions \
    jupyter-nbextensions-configurator

RUN jupyter contrib nbextension install
RUN jupyter nbextensions_configurator enable

RUN echo "alias p='python'" >> /root/.bashrc

RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install -y --fix-broken ./google-chrome-stable_current_amd64.deb
