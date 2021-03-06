#!/bin/bash

# Copyright (c) 2015 Cisco and/or its affiliates.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

build_root=`pwd`
cd ../
wsroot=`pwd`

# PATH
if [[ ! $CCACHE_DIR ]];then
    CCACHE_DIR="$build_root/.ccache"
fi
ADD_TO_PATH="$build_root/tools/ccache-bin:$build_root/tools/bin"

# Construct build-config.mk
cd $build_root
echo SOURCE_PATH = $wsroot > build-config.mk
echo 
echo Saving PATH settings in `pwd`/path_setup
echo Source this file later, as needed
cat >path_setup <<EOF
#!/bin/bash

export PATH=$ADD_TO_PATH:$PATH
export CCACHE_DIR=$CCACHE_DIR
EOF

# regenerate tools/ccache-bin
rm -rf tools/ccache-bin
mkdir -p tools/ccache-bin

if [ ! -f /usr/bin/ccache ] ; then
    echo Please install ccache AYEC and re-run this script
fi

cd tools/ccache-bin
for c in gcc g++
    do
    if [ -f /usr/bin/ccache ] ; then
        ln -s /usr/bin/ccache $c
    else
        ln -s /usr/bin/gcc
    fi
done

cd $wsroot

cd $build_root
echo Compile native tools
for tool in tools
do
    make V=0 is_build_tool=yes $tool-install
done

