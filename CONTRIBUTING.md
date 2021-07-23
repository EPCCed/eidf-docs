# EIDF Contributing

To contribute content to this documentation, first you have to fork it
on GitHub and clone it to your machine, see [Fork a
Repo](https://help.github.com/articles/fork-a-repo/) for the GitHub
documentation on this process.

Once you have the git repository locally on your computer, you will need
to [install Material for mkdocs](https://squidfunk.github.io/mkdocs-material/getting-started/)
to be able to build the documentation. This can be done using a local installation
or using a Docker container.

Once you have made your changes and updated your Fork on GitHub you will
need to [Open a Pull
Request](https://help.github.com/articles/using-pull-requests/).

## Building the documentation on a local machine

Once Material for mkdocs is installed, you can preview the site locally using the
[instructions in the Material for mkdocs documentation](https://squidfunk.github.io/mkdocs-material/creating-your-site/#previewing-as-you-write).

## Making changes and style guide

The documentation consists of a series of Markdown files which have the `.md`
extension. These files are then automatically converted to HTMl and
combined into the web version of the documentation by mkdocs. It is
important that when editing the files the syntax of the Markdown files is
followed. If there are any errors in your changes the build will fail
and the documentation will not update, you can test your build locally
by running `mkdocs serve`. The easiest way to learn what files should look
like is to read the Markdown files already in the repository.

A short list of style guidance:

- Headings should be in sentence case
