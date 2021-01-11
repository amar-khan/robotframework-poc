#!/bin/bash
robotenv=$(env  | grep robotenv | grep -oe '[^=]*$')
testtarget=$(env  | grep testtarget | grep -oe '[^=]*$')
testsuite=$(env  | grep testsuite | grep -oe '[^=]*$')
echo "**Setup testing parameter for $robotenv**"
echo "**Testsuite: $testsuite**"
echo "**Test Target: $testtarget**"
echo "Calling script to create virtual display"
chmod +x Scripts/Xvfb.sh
sh Scripts/Xvfb.sh start
load_testcases () {
    echo "Loading PRP-TestCase"

    if [ ! -d PRP-TestCase/.git ]
    then
        git clone "https://github.hpe.com/amar-khan/PRP-TestCase.git" PRP-TestCase
    fi
}

load_testcases
cd PRP-TestCase/"$testsuite"
git pull
export DISPLAY=:99
echo "Result-Start"
pybot "$testtarget"
cp $(find ./ -name "*.html" -o -name "*.log" -o -name "*.xml") ../../"$testsuite"/
echo "Result-End"

