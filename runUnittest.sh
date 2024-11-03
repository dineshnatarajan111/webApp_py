#!/bin/bash
env
. ${WORKSPACE}/venv/bin/activate && pytest --junitxml=report.xml
git config --global --add safe.directory /home/jenkins/agent/workspace/webapp_${BRANCH_NAME}
commitSHA=$(git log -n 1 --pretty=format:'%H')
echo "commitSHA: $commitSHA"
echo "GITHUB_REPO: $GITHUB_REPO"
tests=$(xmllint --xpath 'string(//testsuite/@tests)' report.xml)
errors=$(xmllint --xpath 'string(//testsuite/@errors)' report.xml)
failures=$(xmllint --xpath 'string(//testsuite/@failures)' report.xml)

# Assuming "passed" means tests - (errors + failures)
passed=$((tests - errors - failures))
githubComment="Test Results for commit ${commitSHA}: \n- Total Tests: ${tests}\n- Passed: ${passed}\n- Failed: ${failures}"

# GitHub API URL for setting commit status
GITHUB_API_URL="https://api.github.com/repos/${GITHUB_REPO}/statuses/$commitSHA"

# Run unit tests and capture the result
if [ "$failures" -eq 0 ] && [ "$errors" -eq 0 ]; then  # Replace './run_tests.sh' with your test command
  STATE="success"
  DESCRIPTION="All unit tests passed!"
else
  STATE="failure"
  DESCRIPTION="Some unit tests failed."
fi

# Post the status to GitHub
curl -s -X POST "$GITHUB_API_URL" \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d "{
    \"state\": \"$STATE\",
    \"target_url\": \"http://example.com\",  # Optional, link to more details
    \"description\": \"$DESCRIPTION\",
    \"context\": \"continuous-integration/unittest\"
  }"
