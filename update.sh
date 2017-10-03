git add . && git commit -m "update" && git push origin master
hexo generate && cd public && git add . && git commit -m "update" && git push origin gh-pages && cd ../
