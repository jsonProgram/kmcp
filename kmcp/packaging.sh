#!/usr/bin/env sh

CGO_ENABLED=0 gox -os="windows darwin linux" -arch="amd64" -tags netgo -ldflags '-w -s' -asmflags '-trimpath'

dir=binaries
mkdir -p $dir;
rm -rf $dir/$f;

for f in kmcp_*; do
    mkdir -p $dir/$f;
    mv $f $dir/$f;
    cd $dir/$f;
    mv $f $(echo $f | perl -pe 's/_[^\.]+//g');
    tar -zcf $f.tar.gz kmcp*;
    mv *.tar.gz ../;
    cd ..;
    rm -rf $f;
    cd ..;
done;
