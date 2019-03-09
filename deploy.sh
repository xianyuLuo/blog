hexo g
cp -rf ./public/* ../xianyuLuo.github.io/
cd ../xianyuLuo.github.io/
git pull
git add ./
git commit -a -m 'update blog'
git push origin master

echo ""
echo ""
echo "Update Sucesses!"

