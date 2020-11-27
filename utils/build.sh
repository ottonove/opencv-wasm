git clone --branch 4.3.0 --depth 1 https://github.com/opencv/opencv.git
chmod -R 755 ./opencv

# BUILD
cd opencv
git checkout 4.3.0

# Add non async flag before compiling in the python build_js.py script
docker run --rm --workdir /code -v "$PWD":/code "trzeci/emscripten:sdk-tag-1.38.32-64bit" python ./platforms/js/build_js.py build_wasm --build_wasm --build_test --build_flags "-s WASM=1 -s WASM_ASYNC_COMPILATION=0 -s SINGLE_FILE=0 "

# Backup the default build_wasm result
cp -a ./build_wasm/ ./build_wasm_backup
cd ..



# SEPARATE WASM
chmod -R 755 ./opencv/build_wasm/bin
node seperateBinaryFile.js



# BEAUTIFY JS
cd opencv/build_wasm/bin
npx js-beautify opencv.js -r
cd ../../..
