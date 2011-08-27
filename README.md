fretboard README

REFS:
music js: http://code.gregjopa.com/javascript/audio/musicjs/demo/
sound manager: http://www.schillmania.com/projects/soundmanager2/

closure/bin/build/depswriter.py --root_with_prefix="fb ../../fb" --root_with_prefix="libs ../../libs" > deps.js

closure-library/closure/bin/build/closurebuilder.py \
  --root=closure-library/ \
    --root=myproject/ \
      --namespace="myproject.start"

