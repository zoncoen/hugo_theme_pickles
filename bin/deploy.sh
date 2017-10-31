set -e

if [[ "false" != "$TRAVIS_PULL_REQUEST" ]]; then
	echo "Not deploying pull requests."
	exit
fi

if [[ "master" != "$TRAVIS_BRANCH" ]]; then
	echo "Not on the 'master' branch."
	exit
fi

rm -rf .git
rm -r .gitignore

echo ".bowerrc
.editorconfig
.travis.yml
.gitignore
.babelrc
./images
webpack.config.babel.js
bin
gulpfile.babel.js
config.js
node_modules
content
package.json
svgpack
tmp
src
config.toml
yarn.lock
!/exampleSite/config.toml
!/exampleSite/content
!/exampleSite/static" > .gitignore

openssl aes-256-cbc -K $encrypted_58ce1a42e263_key -iv $encrypted_58ce1a42e263_iv -in .travis_key.enc -out ~/.ssh/id_rsa -d
chmod 600 ~/.ssh/id_rsa
echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
git config --global user.name "Travis CI"
git config --global user.email "travis@example.com"

git init
git add .
git commit --quiet -m "Deploy from Travis CI (JOB ${TRAVIS_JOB_NUMBER})"
git push --force "${GH_REF}" master:release
