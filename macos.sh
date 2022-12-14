#!/bin/sh

git clone https://github.com/tsuraan/Jerasure.git
git clone https://github.com/ceph/gf-complete.git

cd gf-complete
autoreconf --force --install
./configure
make
echo Installing gf-complete library
sudo make install
cd ..

cd Jerasure
autoreconf --force --install
./configure
make
echo Installing jerasure library
sudo make install
cd ..

echo Done
