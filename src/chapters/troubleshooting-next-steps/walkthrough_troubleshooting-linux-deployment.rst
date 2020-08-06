=====================================================
Group Walkthrough: Troubleshooting a Linux Deployment
=====================================================

This walkthrough is different than any walkthroughs you have done so far. Troubleshooting skills can only be developed through experience. The methodologies and tools can be taught, but the experience is invaluable to your ability to solve real-world problems. You will be working as a group, like you would be on a professional team. Together your group will be troubleshooting a broken deployment. You will need to work together to engage in a troubleshooting discussion to reach a resolution to the issues presented in the deployment.

Each student will be given read-only access to the Azure resources used in the deployment. Your TA will be the only member of your group with administrative access. For each issue the group encounters your TA will facilitate discussion and take any actions the group agrees upon.

.. admonition:: Warning

You will be collaborating with your group mates and TA. **Make sure you do not change anything in the machine**. Your role is **purely observational**. The TA will perform any mutating actions to ensure a manageable process for everyone in the group.

After setting up access of the group members you will have one hour to reach a functional deployment. After the time is up your instructor will walkthrough each issue and it's resolution.

.. admonition:: Note

   Take your time on each issue. The purpose of this exercise is to engage as a team in identifying, isolating and resolving issues in a live deployment.

Troubleshooting Tools
=====================

For this troubleshooting exercise we will need troubleshooting tools to work with our broken deployment. Luckily some of these tools will look familiar as we have worked with them throughout this course.

.. admonition:: Note

   The tools we use in this exercise are not exhaustive. Due to the variable nature of deployments many different tools have been created to assist in troubleshooting. Throughout your career you will use many of these different tools as a response to different systems, tech stack, or team preferences.

Our Troubleshooting Tools
-------------------------

In large scale systems you would rely on bulk remote management tools, but in our case we only need to manage one machine. For our Linux machine we will use ``ssh`` to securely connect to the shell of the provisioned VM.

We are bound to the tools that come included in the selected Ubuntu image. This includes the FS navigation tools you learned in the Bash chapter, and the following:

- ``cat`` or ``less``: to inspect configuration files
- ``service``: to view the status of the services
- ``journalctl``: to view log outputs
- ``curl``: to make network requests from inside the Ubuntu machine

Outside of the host machine we will use the following tools for *external* troubleshooting:

- ``az CLI``: for information about each resource component (or the Azure web portal)
- ``browser dev tools``: to inspect response behavior in the browser
- ``Invoke-RestMethod``: to make network requests from your Windows development machine

SSH Into the Machine
^^^^^^^^^^^^^^^^^^^^

Within the Setup section of this walkthrough your TA will invite you to your ``Reader`` role for accessing the Azure resources related to this broken deployment. *After you have accepted the invitation* and configured your default resource group and VM in the ``az CLI`` you can request the public IP address of the VM.

Using the ``az CLI`` you can store the public IP in a variable so it can be used as the host component of the ``ssh`` command:

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > $VmPublicIp = az vm list-ip-addresses --query '[0].virtualMachine.network.publicIpAddresses[0].ipAddress' 

The first time you connect to a machine over SSH you will be prompted to trust or reject the remote host. When prompted enter ``yes`` to trust the host and connect to it:

.. sourcecode:: powershell
  :caption: Windows/PowerShell

  > ssh student@$VmPublicIp
  # trust the remote host
  # enter password: LaunchCode-@zure1

.. admonition:: Warning

  Using *knowledge-based* authentication (username and password) is much less secure than using something *owned* like a private (digital) key.  The topic of using `RSA keys with SSH <https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2>`_ falls outside the scope of this course but you should know it is **the more secure and preferred mechanism.**
  
  We will authenticate using credentials to avoid detouring away from the learning goals of this troubleshooting exercise.

Once you have connected to the machine you will be able to navigate and use Bash and the tools listed above to gather information and plan a solution with your group.

.. admonition:: Note

  If you are not on a Windows machine, remember that you will need to output in TSV format using the ``-o tsv`` option:

  .. sourcecode:: bash
    :caption: Linux/BASH

    $ vm_public_ip=$(az vm list-ip-addresses -o tsv --query '[0].virtualMachine.network.publicIpAddresses[0].ipAddress')
    $ ssh student@"$vm_public_ip"
    # trust the remote host
    # enter password: LaunchCode-@zure1

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

When troubleshooting within a VM you can use ``curl`` to *isolate* networking related issues. If you are able to connect successfully from inside the machine, but receive a timeout when connecting externally, it indicates that an internal firewall or external network security rule is the issue.

.. admonition:: Note

   In Ubuntu the default `ufw tool <https://help.ubuntu.com/community/UFW>`_ is used for managing *internal* firewall rules.

Discussion: Components of a Functioning System
==============================================

When troubleshooting your first step is to form a mental model of the system you are working on. Due to the introductory nature of this course you and your group will begin by discussing what you know about a fully functioning system. Consider all of the deployment components you have learned about throughout this course. Pay particular attention to the components that have given you trouble in your previous studios.

For each component you should define what expectations need to be met for it to operate in a *healthy state* and which misconfigurations could lead to a *failed state*. By thinking about the system holistically you will be able to keep track of which expectations are not met and collectively decide on the actions needed to reach a resolution.

These assumptions will be the starting points for troubleshooting once your group gains access to Azure. Any expectations that are not met in the broken deployment will offer a clue as to what needs to be fixed.

Your TA will lead your group in this discussion. For each of the network, service, host and application levels consider the following:

- What components are in this level?
- How does each component need to be configured to function properly?
- What common misconfigurations have you encountered with each component and what was the behavior that led to discovering an issue?

You do not need to be exhaustive but every expectation you define will help guide you when you begin troubleshooting. For example, if you were to describe the components in the service level:

- AADB2C
- Key vault

You could then proceed to listing some of the expectations of an operational AADB2C component:

- A tenant directory linked to an active subscription
- At least two registered applications -- the Coding Events API and Postman client
- A SUSI flow that uses the local email account provider
- an exposed ``user_impersonation`` scope for restricting access to the API that has been granted to the Postman client
- Postman is configured to use the implicit flow and the hosted postman redirect URI 

.. admonition:: Note

  After you gain experience with troubleshooting you will be able to hone in on one component or level at a time. However, when you are just starting out it is beneficial to think about the system as a whole.

Setup
=====

Before the troubleshooting timer begins you will need to work with your TA to set up your access to the Azure resources and VM. For this walkthrough your TA will grant you ``Reader`` access to their directory and lab subscription. Once you have registered with their directory and assumed the ``Reader`` role you will be able to access the public IP address of the VM and ``ssh`` into the machine.

Access Troubleshooting Subscription
-----------------------------------

For this exercise an Azure subscription will be setup for your group. Your TA will be the administrator of this group and each student will have read-only access. You will be able to view the deployment, but will need to work together with your team to diagnose the issue and tell your TA how to resolve it.

Even though you already have an account with Microsoft it is only associated with one subscription. You will be able to create a new subscription using your same email, but will have to provide a new password ('LaunchCode-@zure1').

To use this new subscription you will need to:

#. accept the email for the new subscription
#. create a new account (for this new subscription) by using your same email address and a new password: ``LaunchCode-@zure1``
#. setup your AZ CLI to use the new account

Accept Email
^^^^^^^^^^^^

The first step is accessing the email that was sent from Microsoft on your TAs behalf. The email will include a link that will allow you to associate your email address with a new account under the subscription the TA administers.

Upon clicking the link you will be taken to a Microsoft web-page that will prompt you to create an account for this new subscription.

Create Account for New Subscription
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The form will come pre-populated with your email address (since you navigated to the webpage from your email client) and you will need to enter a password.

This account, and subscription, will be temporary so we are all going to use the same password to make things consistent.

Use the password: ``LaunchCode-@zure1``

After entering your password submit the form.

You may be automatically redirected to the new subscription home page, but if you currently have an Azure account in the browser's memory you may be prompted to login.

If you login you will need to make sure you select the correct account, as there will be two accounts associated with your email address. You will need to select ``Use another account``:

.. image:: /_static/images/troubleshooting-next-steps/exercises/pick-another-account.png

Microsoft will inform you that your email address is associated with multiple accounts. You will need to select the account listed under ``Work or school account``:

.. image:: /_static/images/troubleshooting-next-steps/exercises/work-or-school-account.png

From here you will be presented with a form to provide the password you entered above (``LaunchCode-@zure1``).

You will be redirected to the subscription home screen in the Azure portal. Take a look around you should be able to read (but not mutate) any resources.

Setup AZ CLI
^^^^^^^^^^^^

We have worked with the AZ CLI throughout this class, however it is currently configured to work with your personal Azure subscription. We will need to reconfigure it to work with the new subscription. Luckily the AZ CLI gives us a pretty easy way to do this.

First up we need to clear the AZ CLI cache:

.. sourcecode:: PowerShell

   > az account clear

Now we need to login again which will present us with the form to authenticate:

.. sourcecode:: PowerShell

   > az account login

.. admonition:: Warning

  Make sure to select the correct account (``Work or school account``) and use the correct password (``LaunchCode-@zure1``)!
  
  The section immediately before this contains pictures of what this will look like.

Once the authentication is complete the AZ CLI will output some information about your subscription to STDOUT.

After configuring the AZ CLI to use the new subscription let's setup our AZ CLI defaults for the correct resource group and virtual machine:

.. sourcecode:: PowerShell

   > az configure -d group=linux-ts-rg vm=broken-linux-vm

You can verify everything worked by looking at the default VM. It should be identical to your groupmates and TA:

.. sourcecode:: PowerShell

   > az vm show

.. admonition:: Note

   You only have read-access to this Azure subscription. Feel free to look around all you want, however any Azure commands will need to be run by your TA.

Configure Postman
-----------------

For this walkthrough you will use a Postman collection that has the AADB2C details pre-configured as variables. 

Import the Final Postman Collection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can import this collection by selecting the **Import** button and then selecting the **Link** tab in the import window. Paste in the following link then select **Continue**:

- `postman collection link (GitHub gist file) <https://gist.githubusercontent.com/lc-education-ci-user/5e4c91152702502c10ceea28899c29ff/raw/9537c5f7974d719c2001a0043a8cedc5201b5640/postman_coding-events-api.json>`_

.. image:: /_static/images/troubleshooting-next-steps/exercises/postman-import-gist-collection.png
  :alt: Postman import collection from gist URL

Update Access Token Settings
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After importing you will need to update your access token settings to use the following pre-defined variables (from top to bottom of the access token form). As a reminder you can access this by selecting the **three dots** next to the collection name, selecting **Edit** then from the **Authorization** tab select **Get New Access Token**:

- **Token Name**: ``{{TokenName}}``
- **Redirect URL**: ``{{RedirectURL}}``
- **Auth URL**: ``{{AuthURL}}``
- **Client ID**: ``{{ClientID}}``
- **Scopes**: ``{{Scopes}}``
- **State**: ``{{State}}``

.. admonition:: Note

  You can copy and paste each ``{{Variable}}`` value into the settings form. If you misspell any variable it will turn red.

  If you would like to preserve your existing settings you can copy them to another document before pasting in the variable references.

After updating the form your settings should match the image below:

.. image:: /_static/images/troubleshooting-next-steps/exercises/postman-access-token-variables.png
  :alt: Postman configure access token variables

You can now request an access token and **create a new account** in this shared AADB2C tenant. After receiving your access token leave the edit collection window open. 

Update the ``baseURL`` Variable
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

From the **Authorization** tab select the **Variables** tab. Then (as seen in a previous studio) in the **Current Value** entry on the right side replace the current value, ``https://localhost:5001``, with the public IP address of your group's VM:

.. image:: /_static/images/intro-oauth-with-aadb2c/studio_2-aadb2c-explore/postman-update-baseurl.png
   :alt: Postman update the baseUrl variable with the public IP address of the API

Although you will not be able to access the API due to the broken deployment you are ready to use Postman in the final step of this walkthrough.

Deployment Issues
=================

.. FUTURE THOUGHTS:
.. use GitHub issues to have students engage in a realistic setting 
.. someone raises issue -> people diagnose and work towards solution
  .. TA has a script for responding to student questions / suggestions
  .. no progress TA slips in a breadcrumb

.. admonition:: Warning

   Recall that when troubleshooting any changes made to the state of a component needs to be accounted for. Defer to your TA for taking any mutating actions -- **do not make changes on your own**.
   
   As your TA makes changes consider the outcome and adjust your mental model accordingly. 

Once everyone in your group has configured access to Azure you can begin troubleshooting! You can start by using external tools for diagnosis (like the browser, ``az CLI`` or ``Invoke-RestMethod``). Then for each issue you discover you can use the following revolving prompts to discuss and progress towards resolving it:

- What clues have been discovered so far?
- What level do you think the issue related to?
- What components do you think are involved?
- What tools will you need to use to identify the issue?
- What action do you suggest should be taken and why?
- What clues are presented after your TA attempted to fix the issue?

Final Mission
=============

If you and your group are able to fix the deployment you will be able to load the Swagger documentation at the public IP of the host machine. At this point the API will be fully functional and you can complete your final mission using Postman:

- Create an account in the AADB2C tenant to get an access token
- Join the coding event with an ID of ``1`` and read its description!

.. ::

   Bonus
   =====

   Customer Reports Unexpected Bug
   -------------------------------

   validation on coding event

   A customer opened an issue that they were seeing some unexpected behaviors. The QA team reports that this bug is happening in the model at this line, it is up to us to solve the issue and redeploy the application.

   It is up to you on how you approach this, but we recommend using a debugger, and looking into the Microsoft validation module.

   Consider taking the same approach you used before, by asking some questions on where this is happening, why, and how to resolve the issue.

   If you and your group are able to fix the issue locally let your TA know how it can be fixed, and as a group observe as the TA deploys the fix.
