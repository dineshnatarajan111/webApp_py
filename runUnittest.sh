#!/bin/bash

. ${WORKSPACE}/venv/bin/activate && pytest --junitxml=report.xml
commitSHA=$GIT_COMMIT
tests=$(xmllint --xpath 'string(//testsuite/@tests)' report.xml)
errors=$(xmllint --xpath 'string(//testsuite/@errors)' report.xml)
failures=$(xmllint --xpath 'string(//testsuite/@failures)' report.xml)
# Assuming "passed" means tests - (errors + failures)
passed=$((tests - errors - failures))
githubComment="Test Results for commit ${commitSHA}: \n- Total Tests: ${tests}\n- Passed: ${passed}\n- Failed: ${failures}
curl -H "Authorization: token ${env.GITHUB_TOKEN}" \
        -X POST \
        -d '{ "body": "${githubComment}" }' \
        "https://api.github.com/repos/${env.GITHUB_REPO}/commits/${commitSHA}/comments"