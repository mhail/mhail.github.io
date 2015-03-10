#/bin/bash
docker run -v "$PWD:/site" -p 4000:4000 andredumas/github-pages  serve --host=0.0.0.0 --force_polling --drafts -V --trace

