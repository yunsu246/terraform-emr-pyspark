#!/usr/bin/env bash

# install conda
wget --quiet https://repo.continuum.io/miniconda/Miniconda3-py37_4.8.2-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p $HOME/conda

echo -e '\nexport PATH=$HOME/conda/bin:$PATH' >> $HOME/.bashrc && source $HOME/.bashrc

# install packages
conda install -y notebook=5.7.* jupyter=1.0.* pandas seaborn pyarrow

# install findspark
pip install --upgrade pip
pip install findspark
pip install sklearn

# initialize conda
conda init bash