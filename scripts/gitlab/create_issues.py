#!/usr/bin/env python3
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "fzf-wrapper",
#     "python-gitlab",
#     "yaspin",
# ]
# ///

import argparse
import getpass
import os

import gitlab


GITLAB_URL = "https://code.haltu.net"
PAT_CACHE_FILE = "/tmp/gitlab_pat.txt"


def parse_arguments():
    """
    Parse and return the command-line arguments.
    """
    parser = argparse.ArgumentParser(
        description="Create issues from a list of titles for a GitLab project."
    )
    parser.add_argument(
        "--private-token",
        type=str,
        help="GitLab Personal Access Token (PAT). If not provided, you will be prompted to enter it.",
    )
    parser.add_argument(
        "--project_id",
        type=int,
        help="GitLab project ID. If not provided, you will be prompted to select one.",
    )
    parser.add_argument(
        "--titles_file",
        type=str,
        help="Path to the file with issue titles (one per line).",
    )
    return parser.parse_args()


def get_private_token() -> str:
    """
    Reads the PAT from a cache file, or asks the user and then saves it.
    """
    if os.path.exists(PAT_CACHE_FILE):
        with open(PAT_CACHE_FILE, "r") as f:
            token = f.read().strip()
        if token:
            return token

    token = getpass("Enter your GitLab Personal Access Token (PAT): ").strip()
    with open(PAT_CACHE_FILE, "w") as f:
        f.write(token)
    return token


def select_project_id(gl, provided_project_id: int = None) -> int:
    """
    Returns the project ID either from the provided argument or by prompting the user via FZF.
    """
    if provided_project_id:
        return provided_project_id

    from yaspin import yaspin

    print("Fetching projects... This may take a moment.")
    with yaspin(text="Loading projects", color="cyan") as spinner:
        projects = gl.projects.list(get_all=True)
        spinner.ok("✔")

    project_list = [f"{p.id} - {p.name_with_namespace}" for p in projects]

    from fzf_wrapper import prompt

    result = prompt(project_list)
    if not result:
        raise ValueError("No project selected.")
    return int(result[0].split(" - ")[0])


def create_issue(gl: gitlab.Gitlab, project, title: str):
    """
    Creates an issue with the given title (empty description).
    """
    issue_data = {"title": title, "description": ""}
    issue = project.issues.create(issue_data)
    return issue


def main():
    # Parse command-line arguments
    args = parse_arguments()

    # Get or prompt for the private token
    private_token = args.private_token if args.private_token else get_private_token()

    # Connect to GitLab and authenticate
    gl = gitlab.Gitlab(GITLAB_URL, private_token=private_token)
    gl.auth()

    # Select the project, either via the argument or FZF prompt
    try:
        project_id = select_project_id(gl, args.project_id)
    except ValueError as e:
        print(e)
        return

    try:
        project = gl.projects.get(project_id)
    except Exception as e:
        print(f"Error retrieving project with ID {project_id}: {e}")
        return

    # Read issue titles from the file
    titles_file = args.titles_file
    if not titles_file:
        titles_file = input(
            "Enter the path to the file with issue titles (one per line): "
        ).strip()

    if not os.path.isfile(titles_file):
        print(f"Titles file '{titles_file}' does not exist.")
        return

    # Read issue titles from the file.
    with open(titles_file, "r") as f:
        titles = [line.strip() for line in f if line.strip()]

    if not titles:
        print("No issue titles found in the file.")
        return

    print(
        f"Creating {len(titles)} issue(s) in project {project.name_with_namespace} (ID: {project_id})..."
    )
    for title in titles:
        try:
            issue = create_issue(gl, project, title)
            print(f"Issue '{title}' created: {issue.web_url}")
        except Exception as e:
            print(f"Failed to create issue '{title}': {e}")


if __name__ == "__main__":
    main()
