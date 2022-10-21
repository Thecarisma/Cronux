
# Github Wiki

cd dist/
git clone https://github.com/Thecarisma/Cronux.wiki.git
cd Cronux.wiki/
cp -r ../wiki/* ./ -Force
git config --local user.email "iamthecarisma@gmail.com"
git config --local user.name "thecarisma-ci"
git add .; git commit -m "Documentation build. Update Wiki from Travis CI"
git push -f "https://Thecarisma:$($env:GITHUB_TOKEN)@github.com/Thecarisma/Cronux.wiki.git" HEAD:main
cd ../../

# Upload Github Pages 
     
cd dist/
git clone -b gh-pages https://github.com/Thecarisma/Cronux.git
cd Cronux/
cp -r ../../docs/.nojekyll ./ -Force
cp -r ../../commands/cronux/installx.ps1 ./ -Force
cp -r ../gh-pages/build/html/* ./ -Force
git config --local user.email "iamthecarisma@gmail.com"
git config --local user.name "thecarisma-ci"
git add .; git commit -m "Documentation build. Update Documentation from Travis CI"
git push "https://Thecarisma:$($env:GITHUB_TOKEN)@github.com/Thecarisma/Cronux.git" HEAD:gh-pages
cd ../../