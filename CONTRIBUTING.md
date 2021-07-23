# EIDF Contributing

## Process

1. Identify Contribution - look at open issues, review existing documentation, look for gaps in documentation.
1. Fork the documentation repository on GitHub and clone the fork to your local system. See [Fork a GitHub Repository](https://help.github.com/articles/fork-a-repo/).
1. Make Edits and Additions to local copy. See below for setting up an editing environment.
1. Proof read and run pre-commit tests on local copy.
1. Update your forked repository on Github.
1. Create a Pull Request to merge your changes to the main documentation repository. Where possible you can assign this to a member of the EIDF Service team for review and merging, do not merge your own pull requests. See [Open a Pull Request](https://help.github.com/articles/using-pull-requests/).

## Setting up an editing environment

### Requirements

- Git
- Python 3.7+
- Pip
- VirtualEnv (or equivalent)

### Install Material for mkdocs via Pip and Requirements.txt

You should edit the documentation in an editor of your choice but you should set up
the required packages in a virtual environment. To ensure that you are using a compatible
set of packages for a virtual environment for editing the documentation, a requirements.txt
file is provided in the repository. You can install these requirements using Pip.

```bash
   python3 -m venv </path/to/new/virtual/environment>
   source </path/to/new/virtual/environment>/bin/activate
   pip install -r requirements.txt
```

### Docker Materials for mkdocs

You can use [Material for mkdocs](https://squidfunk.github.io/mkdocs-material/getting-started/)
in Docker containers. The documentation for
Material contains guidance on how to operate via Docker.

## Building the documentation on a local machine

Once Material for mkdocs is installed, you can preview the site locally using the
[instructions in the Material for mkdocs documentation](https://squidfunk.github.io/mkdocs-material/creating-your-site/#previewing-as-you-write).

### Local install quick start

In the root directory of your cloned repository, you can run:

```bash
   mkdocs serve
```

This will start a local web server which your browser can connect to
allowing you to view the updated documentation.

## Making changes

The documentation consists of a series of Markdown files which have the `.md`
extension. These files are then automatically converted to HTMl and
combined into the web version of the documentation by mkdocs. It is
important that when editing the files the syntax of the Markdown files is
followed. If there are any errors in your changes the build will fail
and the documentation will not update, you can test your build locally
by running `mkdocs serve`. The easiest way to learn what files should look
like is to read the Markdown files already in the repository.

## Pre-commit

The pre-commit will run a markdown linter configured with current rules
for the EIDF documentation. Your pull request should indicate that you have done this and fixed issues that arise.

## Style Guide

A short list of style guidance:

- Headings should be in sentence case
- Contact Details should be service level contact details
- Spellchecking should be employed
