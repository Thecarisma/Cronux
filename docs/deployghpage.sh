
# Github Wiki

cd dist/
git clone https://github.com/Thecarisma/Cronux.wiki.git
cd Cronux.wiki/
cp -r ../wiki/* ./
git add .; git commit -m "Travis build=${TRAVIS_BUILD_NUMBER}. Update Wiki from Travis CI"
git push https://Thecarisma:${GITHUB_TOKEN}@github.com/Thecarisma/Cronux.wiki.git HEAD:master;
cd ../../

# Upload Github Pages 
     
cd dist/
git clone -b gh-pages https://github.com/Thecarisma/Cronux.git
cd Cronux/
cp -r ../../docs/.nojekyll ./
cp -r ../gh-pages/build/html/* ./
git config --local user.email "azeezadewale98@gmail.com"
git config --local user.name "travis-ci.org"
git add .; git commit -m "Travis build=${TRAVIS_BUILD_NUMBER}. Update Documentation from Travis CI"
git push https://Thecarisma:${GITHUB_TOKEN}@github.com/Thecarisma/Cronux.git HEAD:gh-pages;
cd ../../