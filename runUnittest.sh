#!/bin/bash

. ${WORKSPACE}/venv/bin/activate && pytest --junitxml=report.xml
git log -n 1 --pretty=format:'%H'
commitSHA=$(git log -n 1 --pretty=format:'%H')
echo "commitSHA: $commitSHA"
echo "GITHUB_REPO: $GITHUB_REPO"
tests=$(xmllint --xpath 'string(//testsuite/@tests)' report.xml)
errors=$(xmllint --xpath 'string(//testsuite/@errors)' report.xml)
failures=$(xmllint --xpath 'string(//testsuite/@failures)' report.xml)
# Assuming "passed" means tests - (errors + failures)
passed=$((tests - errors - failures))
githubComment="Test Results for commit ${commitSHA}: \n- Total Tests: ${tests}\n- Passed: ${passed}\n- Failed: ${failures}"
curl -H "Authorization: token ${GITHUB_TOKEN}" \
        -X POST \
        -d '{ "body": "${githubComment}" }' \
        "http://gitea-http:3000/repos/${GITHUB_REPO}/commits/${commitSHA}/comments"
