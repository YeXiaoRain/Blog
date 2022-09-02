#!/usr/bin/env sh

git add . && git commit -m "update & commit by script" && git push origin master
# rm -rf public && hexo g && cd public && git init && git checkout -b gh-pages && git add . && git commit -m "update" && git remote add origin git@github.com:CroMarmot/Blog.git && git push origin gh-pages -f && cd ../
