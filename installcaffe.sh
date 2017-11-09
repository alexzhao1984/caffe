#！/bin/bash
yum install -y git

yum install -y protobuf-devel leveldb-devel snappy-devel opencv-devel boost-devel hdf5-devel
yum install -y gflags-devel glog-devel lmdb-devel
cd /root/
wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/google-glog/glog-0.3.3.tar.gz
tar zxvf glog-0.3.3.tar.gz
cd glog-0.3.3
./configure
make && make install
cd /root/
wget https://github.com/schuhschuh/gflags/archive/master.zip
unzip master.zip
cd gflags-master
mkdir build && cd build
export CXXFLAGS="-fPIC" && cmake .. && make VERBOSE=1
make && make install
cd /root/
git clone https://github.com/LMDB/lmdb
cd lmdb/libraries/liblmdb
make && make install
yum install -y atlas-devel
yum install -y python-devel

yum install -y openblas-devel
yum install -y gcc-c++
yum install -y python2-pip
pip install -U scikit-image
pip install --upgrade protobuf

cd /root/caffe/examples/web_demo/
for req in $(cat requirements.txt); do pip install $req; done

cd /root/
git clone https://github.com/BVLC/caffe
cd caffe
cp /root/Makefile.config.example Makefile.config
make all -j8
make test -j8
make runtest -j8
make pycaffe -j8
make distribute -j8
./scripts/download_model_binary.py models/bvlc_reference_caffenet
./data/ilsvrc12/get_ilsvrc_aux.sh
export PYTHONPATH=/root/caffe/python
python examples/web_demo/app.py -h
python examples/web_demo/app.py -p 33333 &
