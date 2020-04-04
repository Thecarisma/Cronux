cd dist/
git clone -b gh-pages https://github.com/Thecarisma/Cronux.git
cd Cronux/
cp -r ../gh-pages/build/html/* ./
git add .; git commit -m "Travis build=${TRAVIS_BUILD_NUMBER}. Update Documentation from Travis CI"
git push https://Thecarisma:${GITHUB_TOKEN}@github.com/Thecarisma/Cronux.git HEAD:gh-pages;
cd ../../