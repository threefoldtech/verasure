#!/bin/sh

git clone https://github.com/tsuraan/Jerasure.git
git clone https://github.com/ceph/gf-complete.git

cd gf-complete
autoreconf --force --install
./configure
make
echo "Installing gf-complete library"
sudo make install
cd ..

cd Jerasure
autoreconf --force --install
./configure
make
echo "Installing jerasure library"
sudo make install
cd ..

# note about how to compile jerasure-simple as dynamic library but not needed for this
# gcc -dynamiclib -o libjerasuresimple.dylib jerasure-simple.c -I/usr/local/include/jerasure -lJerasure

echo Done
