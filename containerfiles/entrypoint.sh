#!/bin/bash

function yes_we_scan() {
    nmap --script=vulscan/vulscan.nse --script-args vulscandb=exploitdb.csv -sV --open -iL scan.txt --oN /tmp/outputfile.txt
}

function create_gh_issue_with_scan_results() {
    echo "[INFO] Upload nmap output as issue to GitHub"
    title="Yes we scanned on $(date "+%D %T")"
    body=$(sed '1d;s/"/\\"/g;:a;N;$!ba;s/\n/\\n/g' /tmp/outputfile.txt)
    payload="{\"title\":\"$title\",\"body\":\"$body\"}"
   
    echo "GITHUB_TOKEN:  $GITHUB_TOKEN"
    echo "REPO_URL: $REPO_URL"

    curl --request POST \
          --url https://api.github.com/repos/${REPO_URL}/issues \
          --header 'authorization: Bearer ${GITHUB_TOKEN}' \
          --header 'content-type: application/json' \
          --data '{
            "title": "${title}",
            "body": "${body}"
            }' \
          --fail  
}

function main() {
    yes_we_scan
    # create_gh_issue_with_scan_results
}

main
