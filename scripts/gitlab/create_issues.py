#!/usr/bin/env python3

import os
import gitlab

GITLAB_URL = 'https://code.haltu.net'
PROJECT_ID = 1875
PAT_CACHE_FILE = '/tmp/gitlab_pat.txt'

def get_private_token():
    """
    Reads the PAT from a cache file, or asks the user and then saves it.
    """
    if os.path.exists(PAT_CACHE_FILE):
        with open(PAT_CACHE_FILE, 'r') as f:
            token = f.read().strip()
        if token:
            return token

    token = input("Enter your GitLab Personal Access Token (PAT): ").strip()

    with open(PAT_CACHE_FILE, 'w') as f:
        f.write(token)
    return token

def create_issue(gl, project, title):
    """
    Creates an issue with the given title (empty description).
    """
    issue_data = {
        'title': title,
        'description': ''
    }
    issue = project.issues.create(issue_data)
    return issue

def main():
    private_token = get_private_token()

    gl = gitlab.Gitlab(GITLAB_URL, private_token=private_token)
    gl.auth()

    project = gl.projects.get(PROJECT_ID)

    titles_file = input("Enter the path to the file with issue titles (one per line): ").strip()

    with open(titles_file, 'r') as f:
        titles = [line.strip() for line in f if line.strip()]

    if not titles:
        print("No issue titles found in the file.")
        return

    print(f"Creating {len(titles)} issue(s)...")
    for title in titles:
        issue = create_issue(gl, project, title)
        print(f"Issue '{title}' created: {issue.web_url}")

if __name__ == '__main__':
    main()
