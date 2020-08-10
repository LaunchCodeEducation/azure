=====================================================
Studio: Automated Deployment of the Coding Events API
=====================================================

In this studio we will be using *PowerShell to script a complete deployment of the Coding Events API to a Linux VM*.

This PowerShell script will provision and configure all of the Azure resources we will need for the deployment. The script will combine all the steps from the Azure CLI chapter into one easily runnable deploy script.

You will be writing the PowerShell script, however the provisioned VM will require three Bash configuration scripts. `The VM Bash configuration scripts <https://github.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment>`_ will be provided for you, but it would be in your best interest to read over them to make sense of what they are doing.

This will be one of the most challenging studios you have worked on. However, at the end of this studio, you will gain invaluable practical experience writing real scripts and utilizing the *power* of PowerShell. To that end, consider a methodical approach to completing it:

#. The manual steps you need to perform to provision Azure resources
#. The Azure CLI groups, sub-groups, commands, and arguments you will need to use to accomplish them
#. The PowerShell syntax you will need to coordinate the steps
#. *Break the problem down into discrete tasks that you can test in isolation*

While the first two steps should now be familiar to you, the final two points are the most critical. Before you start using any of the commands, make sure to write smaller scripts to test out how to:

- Capture command outputs as variables
- Access properties of variable objects
- Use variable and command substitution

These are all techniques you have worked with in previous walkthroughs and studios that you can review if necessary.

Your Tasks
==========

Fork & Clone
------------

Fork and clone the VM Bash configuration scripts and practice resources `repository <https://github.com/LaunchCodeEducation/powershell-az-cli-scripting-deployment>`_.

Complete the Provision Resources Script
---------------------------------------

Update the ``provisionResources.ps1`` script so that it accomplishes the following:

#. Set variables
#. Provision RG
#. Provision VM
#. Capture the VM ``systemAssignedIdentity``
#. Open vm port 443
#. Provision a Key Vault
#. Create the Key Vault secret (database connection string)
#. Set the Key Vault's access-policy (using the vm ``systemAssignedIdentity``)
#. Send 3 bash scripts to the VM using az vm run-command invoke (``configure-vm.sh``, ``configure-ssl.sh``, ``deliver-deploy.sh``)
#. Print VM public IP address to STDOUT or save it as a file

We will provide you with steps 6 and 9, which have a high likelihood being written incorrectly and causing an error. 

.. admonition:: Tip

   The Bash script ``provision-resources.sh`` you saw earlier is very similar to this script, due to the cross-platform nature of the Azure CLI. However, the shell-specific syntax will be the bulk of your work in writing a PowerShell variant.

Update Source Code
------------------

After completing the script, you will need to update the ``KeyVaultName`` in your ``appsettings.json`` using the name that you set in your ``provisionResources.ps1`` script. In step 6 of the script it was automatically set to ``<name>-lc0820-ps-kv``.

Update the Deliver & Deploy Script
----------------------------------

The ``deliver-deploy.sh`` script will require you to set your GitHub username and the branch of your Coding Events API that includes the updated ``appsettings.json``. These are the variables at the top of the script:

- ``github_username=`` (your username)
- ``solution_branch=`` (``3-aadb2c``)

Run the Script
--------------

Finally, run the script and confirm the deployment by navigating to the public IP address that it prints out!

Submitting Your Work
====================

After you have finished and executed your deploy script you will be able to access your running application using HTTPS at the public IP address of your VM. 

Share this link along with your ``powershell-az-cli-scripting-deployment`` repo link with your TA so they can review your work.

Limited Guidance
================

Running Custom PowerShell Scripts
---------------------------------

Recall that Windows will not let you just run a PowerShell script, you must first set the ``ExecutionPolicy`` before you can run any custom PowerShell scripts.

Azure CLI Response Examples
---------------------------

In the cloned repository you will find a folder called ``exampleResources``. This folder contains three JSON files with the output of each Azure CLI command. 

You can use these example resources to practice working with these outputs as PowerShell objects. They can be loaded from the file and converted to ``PSCustomObjects`` (*exactly what the commands will output*) using ``Get-Content`` and ``ConvertFrom-Json``.

For example, you can examine the resource group name with:

.. sourcecode:: powershell

   (Get-Content ./resourceGroup.json | ConvertFrom-Json).name

Recall that your Key Vault will need the VM's ``systemAssignedIdentity`` to properly set an access policy from the Azure CLI. See if you can access this property with PowerShell and ``virtualMachine.json``. Then consider and practice accessing the other properties you will need using:

- ``virtualMachine.json``
- ``resourceGroup.json``
- ``keyVault.json``

Here is a general example of how to load and access a property. Be mindful of the syntax needed to access nested properties, or those that exist within an array field:

.. sourcecode:: powershell
   :caption: load JSON file into a PS variable

   > $virtualMachine = Get-Content virtualMachine.json | ConvertFrom-Json

   > $virtualMachine.someProperty

.. admonition:: Fun Fact

   These files were created using a simple PowerShell pipeline. For example, the ``virtualMachine.json`` file was created like this:

   .. sourcecode:: powershell
      :caption: capture AZ CLI output in JSON file

      > az vm create -n .... | Set-Content virtualMachine.json

AZ CLI Help
-----------

As we saw in the Azure CLI walkthrough, you will want to explore and plan out your commands before turning them into a script. As a reminder, you can get help for any AZ CLI command, or sub-command with ``-h`` or the longhand ``--help``:

.. sourcecode:: powershell

   > az vm create -h

Capturing AZ CLI Output in a Variable
-------------------------------------

Similar to how the example ``.json`` files were created, you can capture the output in a variable:

.. sourcecode:: powershell
   :caption: capture AZ CLI output in variable

   > $someVariable = az vm create -n .....

   > $someVariable.someProperty

.. RunCommand from the AZ CLI
.. --------------------------

.. You can access the ``RunCommand`` for any VM with the following command: 

.. .. sourcecode:: powershell

..   > az vm run-command invoke --command-id RunShellScript --scripts @relative/path/to/script.sh

.. You will have to successfully invoke the three provided scripts for you application to finish it's deployment.

.. .. admonition:: Note

..    **Relative paths must be written relative to the script that is executing the command**.

..    You can use an absolute or relative path to define the script location. Multiple scripts can be separated by spaces as arguments to the ``--scripts`` option. Scripts are executed in order from left to right. 

Fresh Start
-----------

If you think you've messed something up throughout this deployment, you can easily destroy the entire resource group using the AZ CLI:

.. sourcecode:: powershell

  > $rgName = "<your-rg-name>"
  > az group delete -n "$rgName"

This command takes a couple of minutes to run because it first has to delete each of the resources inside of the resource group. However, this handy command allows you to cleanup easily, or start over if you've made a mistake!
