=====================================================
Group Walkthrough: Troubleshooting a Linux Deployment
=====================================================

This walkthrough is different than any walkthroughs you have done so far. Troubleshooting skills can only be developed through experience. The methodologies and tools can be taught, but the experience is invaluable to your ability to solve real-world problems. You will be working as a group, like you would be on a professional team. Together your group will be troubleshooting a broken deployment. You will need to work together to engage in a troubleshooting discussion to reach a resolution to the issues presented in the deployment.

Each student will be given read-only access to the Azure resources and file system of the VM used in the deployment. Your TA will be the only member of your group with administrative access. For each issue the group encounters your TA will facilitate discussion and take any actions the group agrees upon.

After setting up access of the group members you will have one hour to reach a functional deployment. After the time is up your instructor will walkthrough each issue and it's resolution.

.. admonition:: note

   Take your time on each issue.
   
   The purpose of this exercise is to engage in a dialogue around identifying, isolating, and resolving issues in a live deployment. If you do finish early there is a bonus section your group can work on.

... TODO: VM access can be restricted

.. ::

   .. admonition:: Warning

   You will be collaborating with your group mates and TA. **Make sure you do not change anything in the machine**. Your role is **purely observational**. The TA will perform any mutating actions to ensure a manageable process for everyone in the group.

Troubleshooting Tools
=====================

For our troubleshooting exercise we will need troubleshooting tools to work with our broken deployment. Luckily some of these tools will look familiar as we have worked with them throughout this course.

.. admonition:: Note

   The tools we use in this exercise are not exhaustive. Due to the variable nature of deployments many different tools have been created to assist in troubleshooting. Throughout your career you will use many of these different tools as a response to different systems, tech stack, or team preferences.

Our Troubleshooting Tools
-------------------------

In large scale systems you would rely on bulk remote management tools, but in our case we only need to manage one machine. For our Linux machine we will use ``ssh`` (Secure Shell) to securely connect to the shell of the provisioned VM.

We are bound to the tools that come included in the selected Ubuntu image. This includes the File System navigation tools you learned in the Bash chapter, and the following:

- ``cat`` or ``less``: to inspect configuration files
- ``service``: to view the status of the services
- ``journalctl``: to view log outputs
- ``curl``: to make network requests from inside the Ubuntu machine

Outside of the host machine we will use the following tools for external troubleshooting:

- ``az CLI``: for information about each resource component (or the Azure web portal)
- ``browser dev tools``: to inspect response behavior in the browser
- ``Invoke-RestMethod``: to make network requests from your Windows development machine

Using ``service``
^^^^^^^^^^^^^^^^^

The `service <http://manpages.ubuntu.com/manpages/bionic/man8/service.8.html>`_ program is a wrapper that simplifies how several of the `init systems <http://www.troubleshooters.com/linux/init/features_and_benefits.htm>`_ on a Linux machine can be managed through a single tool. Init systems are used to *initialize* and manage background processes running on Linux systems. 

On Ubuntu machines the `systemd init system <>`_ and its client program `systemctl <>`_ (system control manager) are used by default to manage *service units*. In the configuration script of our final deployments we created a *systemd unit file* to define how our Coding Events API would be operated a background service on the Ubuntu VM.  The script also used the ``service`` tool (rather than the underlying ``systemctl`` it wraps) to make our script portable across supporting Linux distributions.

In addition to controlling services, the ``service`` tool can be used to view the status of any registered service units like our ``coding-events-api``, ``nginx`` and ``mysql``:

.. admonition:: Warning

   Be mindful of your group's effort in troubleshooting the deployment. **Only use** the ``service`` tool **for observation** with the ``status`` command.
   
   After reaching a group consensus your TA can issue the ``service`` commands that mutate service state.

.. sourcecode:: bash
  :caption: Linux/BASH

   service <service-name> status

For example if you were to check the status of a *functioning* API service you would receive the following output:

.. sourcecode:: bash
  :caption: Linux/BASH

  $ service coding-events-api status

  ● coding-events-api.service - Coding Events API
    Loaded: loaded (/etc/systemd/system/coding-events-api.service; disabled; vendor preset: enabled)
    Active: active (running) since Tue 2020-10-31 19:04:51 UTC; 1 day 4h ago
  Main PID: 18196 (dotnet)
      Tasks: 16 (limit: 4648)
    CGroup: /system.slice/coding-events-api.service
            └─18196 /usr/bin/dotnet /opt/coding-events-api/CodingEventsAPI.dll

.. :: FOR TAS

   service nginx status

   service mysql-server status

   service coding-events-api status

Using ``journalctl``
^^^^^^^^^^^^^^^^^^^^

The `journalctl <https://www.freedesktop.org/software/systemd/man/journalctl.html>`_ tool can be used to view the logs written by systemd services. You can use it to view the logs of a particular service unit using the ``-u`` (unit name) option:

.. sourcecode:: bash
  :caption: Linux/BASH

  $ journalctl -u <service-name>

The systemd journal can store thousands of logs and lines within them. Often it is useful to view just the most recent logs. The ``-f`` option will *follow* the logs starting from the last 10 lines and continuously display new lines as they are written:

.. sourcecode:: bash
  :caption: Linux/BASH

  $ journalctl -f -u <service-name>

  # shorthand (-u comes after to pair with the service name argument)
  $ journalctl -fu <service-name>

.. admonition:: Note

  Like other *foreground* CLI programs that attach to your Terminal, you can use ``ctrl+c`` to exit ``journalctl``.

Working with Self-Signed Certificates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A self-signed certificate means that the signature used to sign the certificate is not recognized by an external `certificate authority (CA) <https://www.ssl.com/faqs/what-is-a-certificate-authority/>`_. These certificates can still be used for TLS encryption but are not *inherently trusted* like traditional SSL certificates due to their unknown signing authority. By default HTTP client applications like browsers or CLI tools will automatically reject self-signed certificates as a security measure. 

In our ``configure-ssl.sh`` deployment script our VM *internally generated* the signing key used to sign the SSL certificate with the ``openssl`` tool. Recall that when you first connected to the Swagger documentation of your API in the browser you had to bypass the warning and accept (*explicitly trust*) the self-signed certificate. CLI tools can be configured similarly to also accept self-signed certificates.

When working with ``Invoke-RestMethod`` cmdlet the default certificate validation behavior for self-signed certificates results in the following error for servers using self-signed certificates:

.. sourcecode:: powershell
  :caption: Windows/PowerShell

   Invoke-RestMethod: The remote certificate is invalid according to the validation procedure.

We can override the default validation procedure by using the ``-SkipCertificateCheck`` option:

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > Invoke-RestMethod -Uri https://<PUBLIC IP> -SkipCertificateCheck

Similarly, when working *inside* the Ubuntu VM with ``curl`` the validation can be skipped using the ``-k`` option:

.. sourcecode:: powershell

   # curl https://localhost -k

When troubleshooting within a VM you can use ``curl`` to *isolate* networking related issues. If you are able to connect successfully from inside the machine, but cannot connect externally, it indicates that an internal firewall or external network security rule is the issue.

.. admonition:: Note

   In Ubuntu the default `ufw tool <https://help.ubuntu.com/community/UFW>`_ is used for managing *internal* firewall rules.

Setup
=====

Before the troubleshooting timer begins you will need to work with your TA to set up your access to the Azure resources and VM. For this walkthrough your TA will grant you ``Reader`` access to their directory and lab subscription. Once you have registered with their directory and assumed the ``Reader`` role you will be able to access the public IP address of the VM and ``ssh`` into the machine.

Access Troubleshooting Subscription
-----------------------------------

- accept invitation
  - Reader role only
  - create new account (in the TA directory)
    - your email
    - LaunchCode-@zure1
- az account clear
- az login
  - select other account
  - enter your email
  - select the Work or School account created by IT admin (TA email) option
    - (SCREENSHOT)
- az configure -d group=linux-ts-rg vm=broken-linux-vm
- az group show and az vm show
- you now have read access to all resources for investigating

USE NAMES
- rg: linux-ts-rg
- vm: broken-linux-vm

SSH Into the Machine
--------------------

After configuring your default resource group and VM you can request the public IP address of the VM using the ``az CLI``:

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > $VmPublicIp = az vm list-ip-addresses --query '[0].virtualMachine.network.publicIpAddresses[0].ipAddress'

After storing the public IP you can use it for the ``ssh`` host address. 

The first time you connect to a machine over SSH you will be prompted to trust or reject the remote host. When prompted enter ``yes`` to continue.

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > ssh student@$VmPublicIp
  # trust the remote host
  # enter password: LaunchCode-@zure1

If you are not on a Windows machine, remember that you will need to output in TSV format using the ``-o tsv`` option:

.. sourcecode:: bash
  :caption: Linux/BASH

  $ vm_public_ip=$(az vm list-ip-addresses -o tsv --query '[0].virtualMachine.network.publicIpAddresses[0].ipAddress')
  $ ssh student@"$vm_public_ip"
  # trust the remote host
  # enter password: LaunchCode-@zure1

.. admonition:: Warning

  Using *knowledge-based* authentication (username and password) is much less secure than using something *owned* like a private (digital) key.  The topic of using `RSA keys with SSH <https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2>`_ falls outside the scope of this course but you should know it is **the more secure and preferred mechanism.**
  
  We will authenticate using credentials to avoid detouring away from the learning goals of this troubleshooting exercise.

...for each of the following issues use SSH and the tools above to investigate...

Taking Inventory
================

In a live deployment any misconfigured component could be the cause of an issue. It is important to have a mental model of the system and the *current* state of each component in it. To gain an understanding of the deployment and it's state your group should discuss the components, listed below, and how they could be misconfigured.

...this course is an introduction so we are taking inventory up front, but this isn't how it's always done in the real-world usually inventory for just the level where you believe the issue is happening

.. admonition:: Warning

   Recall that when troubleshooting any changes made to the state of a component needs to be accounted for. As your group makes changes, record them, and adjust your mental model accordingly. 

Deployment Components
---------------------

Let's consider the components in each layer of our system.

Network Level
^^^^^^^^^^^^^

...Network related issues are always based around routing behavior and access rules. As an introductory course we have only explored access rules in the form of our network security groups. To that end consider the three components of an access rule

- NSG rules for controlling access at the network level
- what rules do you expect?
  - SSH (22)
  - HTTP (80)
  - HTTPS (443)

Service Level
^^^^^^^^^^^^^

- KeyVault
  - what configuration is expected?
    - a secret: database connection string
    - an access policy for our VM
- AADB2C
  - what configuration is expected?
    - tenant dir
    - protected API (user_impersonation scope)
    - Postman client application
    - SUSI flow

Hosting Environment Level
^^^^^^^^^^^^^^^^^^^^^^^^^

- VM external configuration
  - what configuration is expected?
    - size
    - image (defines available tools)
    - system assigned identity for KV access
- VM internal configuration
  - what configuration is expected?
    - runtime dependencies (dotnet, mysql, nginx)
    - self-signed SSL cert
  - what services are expected?
    - embedded MySQL
    - NGINX web server (reverse proxy)
    - API service
- MySQL db server
  - user and database for the API
- NGINX
  - RP configuration
  - using SSL cert

Application Level
^^^^^^^^^^^^^^^^^

- appsettings (external configuration)
- source code
  - could have issues but we will assume it is working as expected

Deployment Issues
=================

.. use GitHub issues to have students engage in a realistic setting 
.. someone raises issue -> people diagnose and work towards solution
  .. TA has a script for responding to student questions / suggestions
  .. no progress TA slips in a breadcrumb

Experiencing a Connection Timeout
---------------------------------

.. browser screenshot of timeout

prompts
- what clues have been discovered so far?
- what level is this issue related to?
- what components are involved?
- what tools will you use to identify the issue?
- what action do you suggest should be taken?
- what clues are presented after the TA attempted to fix the issue?

Receiving a 502 Bad Gateway Error
---------------------------------

.. Invoke-RestMethod to check if the connection works

.. todo:: get snippet and output

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > Invoke-RestMethod -Uri https://<PUBLIC IP> -SkipCertificateCheck

    Invoke-RestMethod: 
    502 Bad Gateway
    502 Bad Gateway
    nginx

prompts
- what clues have been discovered so far?
- what level is this issue related to?
- what components are involved?
- what tools will you use to identify the issue?
- what clues are presented after the TA attempted to fix the issue?

.. admonition:: Note

  Remember that fixing one issue may expose another. Through each phase of troubleshooting remember to consider *the new state* of the system and adapt your approach. 

Bonus
=====

Customer Reports Unexpected Bug
-------------------------------

  validation on coding event

A customer opened an issue that they were seeing some unexpected behaviors. The QA team reports that this bug is happening in the model at this line, it is up to us to solve the issue and redeploy the application.

It is up to you on how you approach this, but we recommend using a debugger, and looking into the Microsoft validation module.

Consider taking the same approach you used before, by asking some questions on where this is happening, why, and how to resolve the issue.

If you and your group are able to fix the issue locally let your TA know how it can be fixed, and as a group observe as the TA deploys the fix.
