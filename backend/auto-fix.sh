#!/bin/bash
echo "Auto Fix Started..."

npx prettier --write src >/dev/null 2>&1

npx eslint src --fix >/dev/null 2>&1

npm run build

if [ $? -eq 0 ]; then
 echo "BUILD GREEN"
 git add .
 git commit -m "Auto fix and build success" || true
 git push origin main || true
else
 echo "BUILD FAILED - CHECK LOG"
fi
