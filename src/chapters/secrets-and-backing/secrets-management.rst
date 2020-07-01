==================
Secrets Management
==================

An application may need access to lots of different data. An application may make a request to a database to write or read crucial business information, to do this the application needs credentials to access the database, a database connection string.

Consider the fictionalized database connection string to connect a .NET web application to a MySQL database: ``server=257.28.162.111;port=3306;database=car_db;user=car_user;password=7p*RTY5g8i#WB@F8``.

This string contains:

- the IP address of the database server
- the port of the database server 
- a database name 
- a username and password that has access to the database

That's essentially all the information anyone needs to gain access to your database server!

All of the data in our database connection string is sensitive. **Sensitive data** is privileged data that we wouldn't want anyone accessing for any number of reasons. In the case of our database connection string, the sensitive data is data that could be used to compromise our application, data backing services, or infrastructure. 

.. admonition:: note

	Sensitive data could also include proprietary knowledge or Personal Identifying Information (PII). This sensitive data is usually secured within a data backing service. The data backing service credentials are what are guarded to ensure only individuals with authorization can access this sensitive data.

In the wrong hands our database connection string could be used to compromise the data of our database, but this data needs to be included in our application so that it can access the necessary data.

How do we give this data to the application and keep the sensitive data a **secret**?

Secrets
-------

**Secret** data is information that is required by an application to function, but is kept separate from the source code of the application. In other words a **secret** is information that is never made publicly available. A **secret** is only made available to individuals that can provide credentials that prove the correct level of authorization.

.. admonition:: note

	A secret is a subset of sensitive data. However, a secret is sensitive data that is necessary for an application to function properly. Proprietary knowledge and PII may be part of the underlying data an application uses, they are not necessary for an application to function.

Examples of secrets:

- databases connection strings
- API keys
- usernames
- passwords
- VM IP addresses

Examples of PII:

- first & last name
- email address
- residential address
- phone number
- zip code
- SSN

Examples of Proprietary data:

- user habits, behaviors, and trends
- information about internal products or processes
- results of internal research
- patented or copyrighted materials

Handling Sensitive Data
-----------------------

.. option 1

There are a few things we must do to ensure our sensitive data is not exposed to the public. We need to make sure all sensitive data stays out of our VCS tooling. Any secrets our application depends on must be loaded into our source code via external configuration. Our infrastructure must be configured in a way to restrict access to anything which doesn't specifically need access to the given resource. All requests for PII or Proprietary data should be adequately housed must require authorization.

.. option 2

There are a few things we must do to ensure our sensitive data is not exposed to the public. 

- sensitive data stays out of VCS
- application secrets are stored externally and loaded at runtime
- infrastructure must be configured to give least privileged access
- All PII and proprietary data is securely housed and requires authorization

.. admonition:: warning

	The remaining article will talk about various strategies, and tooling to keep sensitive data protected, however this article is not exhaustive.

VCS
^^^

To ensure we don't accidentally expose sensitive data we must be careful with the files we track using ``git``. If we have a file that contains sensitive data we need to make sure the file is never added to staging and isn't committed to a repository. If sensitive data is tracked, committed and pushed to a remote repository other people can view it. 

Manually determining which file has sensitive data and making sure it isn't added to the local ``git`` repository would be a pain. Fortunately for us ``git`` has a built in feature that allows us to easily track the files we don't want to include in our ``git`` repository. 

This feature is managed by the aptly name ``.gitignore`` file. Files, and directories added to this file will simply be skipped over when ``git`` checks your directories for changes.

Let's make a new temporary directory, initialize it as a local ``git`` repository and take a look.

.. sourcecode:: powershell
	:caption: Windows/Powershell

	New-Item -ItemType "directory" -Name temp_directory
	Set-Location ./temp_directory/
	New-Item -ItemType "file" -Name new-file.txt -Value "hello world"
	git init
	git status

	On branch master

	No commits yet

	Untracked files:
	(use "git add <file>..." to include in what will be committed)
		new-file.txt

	nothing added to commit but untracked files present (use "git add" to track)

As we expect when creating a new directory, file, and local git repository when we run the command ``git status`` the output shows us the *untracked files*. In this case our untracked file is ``new-file.txt``.

Let's try adding a ``.gitignore`` file with the entry of ``new-file.txt`` and run the ``git status`` command again.

.. sourcecode:: powershell
	:caption: Windows/PowerShell

	Set-Location ./temp_directory/
	New-Item -ItemType "file" -Name .gitignore -Value "new-file.txt"
	git status

	On branch master

	No commits yet

	Untracked files:
	(use "git add <file>..." to include in what will be committed)
		.gitignore

	nothing added to commit but untracked files present (use "git add" to track)

Our local ``git`` repository has detected a different change. It no long detects ``new-file.txt`` since it is an entry in the ``.gitignore`` file. In this case ``git`` simply skipped over ``new-file.txt`` when scanning our project directory. 

Our local ``git`` repository has detected that a new file is currently untracked: ``.gitignore``. We do want to stage, and commit this file because we can use it as a source of determining which files are not being tracked by ``git`` and no sensitive data should ever be in this file.

.. admonition:: tip

	When writing code you should always consider the data that is exposed in your source code. If you determine a file does have sensitive data in it you should add it to the ``.gitignore`` file right away.

We have only scratched the surface of ``.gitignore``. It is also used to ignore build artifacts, and other derived code, can ignore entire directories, understands wildcard syntax, and more. These aspects go beyond the scope of this course. However, you can `learn more here <https://git-scm.com/docs/gitignore>`_.

External Configuration
^^^^^^^^^^^^^^^^^^^^^^

A best practice for handling secrets is to use ``external configuration`` files. In the same vein as keeping sensitive data out of our source code, ``external configuration`` aims to keep our secrets out of our VCS.

You have already encountered various project configuration files. In the ``CodingEventsAPI`` we have been deploying throughout this class has an ``appsettings.json`` file which contains various configuration properties. Separating the configurations from the rest of the source code has a host of benefits and is a best practice. However, when dealing with ``secrets`` we want to distance this data even further. As a reminder ``secrets`` are data required for applications to function, but the secrets need to be kept external to our project.

``external configuration`` is the process of keeping configuration data outside of the source code of a project and loading the configuration values into the project at runtime. This keeps the ``secrets`` separate from the project completely. 

Using ``external configuration`` files has two major benefits: 

#. secrets are kept separate and safe from both the code, and running application
#. an applications running across different environments can be configured in different ways

We will discuss application environments in the next article, but before then let's look at how we can manage secrets in .NET and Azure.

Secrets Management
------------------

- secrets management implementation
- local: user-secrets
- remote: key-vault