.. _walkthrough_az-cli:

=======================================================
Walkthrough: Provisioning Resources Using the Azure CLI
=======================================================

In this walkthrough we will practice using the ``az CLI`` to provision the same resources that we spun up using the web portal GUI. As you work through these commands try to picture the manual steps you performed on the web portal and use your knowledge of the ``az CLI`` patterns to translate those steps into CLI commands.

Although you can simply read through this guide it is important that you actively attempt each command on your machine. The more practice you get the more comfortable you will be with using it.

For each resource we provision we will use a methodical approach:

- **Exploration**: issue a help command to learn about the the resource
- **Planning**: consider our tasks and what Commands, Sub-Groups and Arguments are needed to accomplish them
- **Provisioning**: put our Planning into action and provision the resource
- **Configuring**: any extra steps that use the new resource to complete our tasks

This is a process you can carry with you as you continue to work with the ``az CLI`` and other tooling. A good idea is to start a set of notes for easy access to common tasks you are faced with. These notes will prove invaluable when you begin composing commands together into automation scripts. 

.. note::

    As a cross-platform tool all of the base commands will work the same on any OS or shell. In some cases we will utilize shell-specific syntax to accomplish our tasks. Where there are syntactical differences the commands for both Linux/Bash and Windows/PowerShell will be presented. Otherwise you can freely use the commands in either shell.

Setup
=====

Before we begin you have to log in with your Azure subscription. This command will open your browser to enter your credentials. After logging in you can close the tab and return to your terminal.

.. sourcecode:: none

    > az login

Configuring Defaults
--------------------

Once you are logged in you can make use of the global ``configure`` Command to set defaults for the CLI. This will make working with resources easier by automatically inserting default values for common required Arguments. Let's set a default Azure Location for our resources.

.. sourcecode:: none

    # -d can also be used as a shorthand for --default 
    > az configure --default location=eastus

Now any resource that has a required Argument of ``--location`` or ``-l`` will automatically have ``eastus`` set as its value.

.. admonition:: Note

    We will use the ``configure`` Command to set defaults for common Arguments throughout this walkthrough. You can change your default values at any time by re-issuing the command with new ``name=value`` pairs. 
    
    You can also view your defaults using the ``--list-defaults`` Argument:

    .. sourcecode:: none

        # -l can also be used as a shorthand for --list-defaults
        > az configure --list-defaults

Resource Groups
===============

We will begin by provisioning a resource group to hold the other resources associated with it. Resource groups are an organizational tool to keep track of and manage resources as a whole instead of individually. One of the benefits of this approach is that it is easy to dispose of all of the resources by deleting the resource group they are contained in instead of deleting each of them one-by-one.

Exploration
-----------

Let's begin by using our trusty help command to learn what management is available for resource groups. Although it's confusing remember that resource groups are accessed under the Group name ``group``.  

.. sourcecode:: none

    > az group -h

Take a moment to look over the output. Because resource groups are simple containers there isn't much beyond the standard CRUD commands.

Planning
--------

Of the available commands we can see that our goal is to ``create`` the resource. Let's dig into the ``create`` Command to see what Arguments are available.

.. sourcecode:: none

    > az group create -h

We will need to provide at minimum the two **required** arguments:

- ``-n`` or ``-g``: the name of the resource group
- ``-l``: the Azure Location

Fortunately we have already configured our default Location value of ``eastus`` so all we need to supply is the resource group name. We will use a consistent naming convention to make sure none of our resources have conflicting names. The convention for resource groups we will use is "your name" + "cli-wt" (CLI walkthrough) + "rg" (resource group):

    <name>-cli-wt-rg

Note that there is a 23 character limit for resource names. If you have a long first name consider using a short name like Pat if your name is Patrick.

Provisioning
------------

Now that we have determined the command structure and its arguments we can create our resource group:

.. sourcecode:: none

    > az group create -n <name>-cli-wt-rg

You should see a JSON output like this:

.. sourcecode:: bash

    {
        "id": "/subscriptions/<subscription ID>/resourceGroups/<name>-cli-wt-rg",
        "location": "eastus",
        "managedBy": null,
        "name": "<name>-cli-wt-rg",
        "properties": {
            "provisioningState": "Succeeded"
        },
        "tags": null,
        "type": "Microsoft.Resources/resourceGroups"
    }

Notice how the subscription and location are set automatically. The former by logging in and the latter by configuring its default value.

Configuring
-----------

Earlier we configured a default location, let's configure the default resource group too. Don't forget to enter your new resource group name as the value:

.. sourcecode:: none

    > az configure --default group=<name>-cli-wt-rg

You can confirm the default has been set by checking the CLI configuration with the ``-l`` (list) argument and seeing that the "group" has value has been set correctly:

.. sourcecode:: none

    > az configure -l

Virtual Machines
================

For this walkthrough we will not be using our VM to deploy an application but simply to get comfortable using the CLI. 

Exploration
-----------

Virtual Machines are naturally more complex to interact with than a simple resource group. However, now that we understand the pattern of the ``az CLI`` that complexity can be managed using the help command to methodically work our way through its Sub-Groups and Commands.

Once again let's begin by assessing what is available to us:

.. sourcecode:: none

    > az vm -h

Planning
--------

Recall in the web portal how there were several menus we had to work through to provision it. In addition to all of those options the ``az CLI`` exposes additional configuration Arguments for more granular control. 

Let's see what Arguments are associated with creating a VM:

.. sourcecode:: none

    > az vm create -h

From this long list of Arguments we will need to provide values for the following:

- ``-n``: the name of the VM
- ``-l``: the location [default configured]
- ``-g``: the resource group name [default configured]
- ``--size``: the size of the VM
- ``--image``: the URN of the image used to create the VM
- ``--admin-username``: the username of the root account for the VM
- ``--assign-identity``: to assign an identity to the VM for granting access to the KeyVault secrets

Listing Images
^^^^^^^^^^^^^^

In order to define the image for the VM we have to find its URN. In the ``vm create`` help output we saw a note that guided is in discovering these URN values. Let's list the available images using the ``vm`` Sub-Group ``image`` and its associated ``list`` Command:

.. sourcecode:: none

    > az vm image list

Many different images are provided in the JSON object list output. But all we care for is the URN values. We could manually scroll through all of them to find the URN of the Ubuntu image. Or we can make use of the global ``--query`` Argument to output only the data we need!

The `JMESPath query <https://jmespath.org/>`_ value we will use is ``"[].urn"`` which means take the output list ``[]`` and instead of the complete image objects only output the value for each of their the ``urn`` properties. The result is a list of just URN values which is much easier to work with!

.. sourcecode:: none

    > az vm image list --query "[].urn"

From here we can see the URN we need for the Ubuntu image is ``"Canonical:UbuntuServer:18.04-LTS:latest"``. Let's assign that value to a variable so we don't have to clutter our clipboard:

.. sourcecode:: none
    :caption: on Windows/PowerShell

    > $ImageURN="Canonical:UbuntuServer:18.04-LTS:latest"

.. sourcecode:: bash
    :caption: on Linux/Bash

    $ image_urn="Canonical:UbuntuServer:18.04-LTS:latest"

Now we can reference the URN by its variable name ``$ImageURN`` (PowerShell) or ``image_urn`` (Bash) depending on your chosen shell.

.. admonition:: Tip

    You can make use of a slightly more advanced query and in-line execution to do this in one step. Below we use a filter on the list to only output objects whose URN property ``contains`` the string Ubuntu. Then we pipe the filtered list and assign the first element's URN value to the variable.

    .. sourcecode:: none
        :caption: filtering the image list

        > az vm image list --query "[? contains(urn, 'Ubuntu')] | [0].urn"

    When we issue this command using in-line execution we can assign output directly to the variable:

    .. sourcecode:: none
        :caption: Windows/PowerShell

        > $ImageURN="$(az vm image list --query "[? contains(urn, 'Ubuntu')] | [0].urn")" 

    When using the Bash shell there is a known `issue <https://github.com/Azure/azure-cli/issues/8401>`_ with the default JSON format where it includes quote characters ``""`` around single string outputs. Unfortunately this can break commands and scripts in Bash so we need to request a TSV output format to correct it:

    .. sourcecode:: bash
        :caption: Linux/Bash

        # -o: tsv sets the output to TSV format to remove the double quote characters
        $ image_urn="$(az vm image list --query "[? contains(urn, 'Ubuntu')] | [0].urn" -o tsv)" 

Provisioning
------------

Now that we have our image URN we can provision the VM. We will use the following values for the remaining arguments:

- ``-n``: <name>-linux-vm
- ``--size``: Standard_B2s
- ``--admin-username``: student
- ``--image``: the image URN [stored in a variable]

.. note::

    It is important that you use these exact values so that it is easier to help you if something goes wrong along the way.

Let's create our VM! Note that this command will take some time to complete.

.. sourcecode:: none
    :caption: Windows/PowerShell

    > az vm create -n <name>-linux-vm --size "Standard_B2s" --image "$ImageURN" --admin-username "student" --assign-identity

.. sourcecode:: bash
    :caption: Linux/Bash

    $ az vm create -n <name>-linux-vm --size "Standard_B2s" --image "$image_urn" --admin-username "student" --assign-identity

.. admonition:: Note

  If you receive the following error output:

  .. sourcecode:: bash

    An RSA key file or key value must be supplied to SSH Key Value.
    
    You can use --generate-ssh-keys to let CLI generate one for you

  You can fix this by reissuing the command and appending ``--generate-ssh-keys`` after ``--assign-identity``. We will learn about SSH, RSA keys and how they relate to this message in later lessons.    

You should receive an output like this:

.. sourcecode:: bash

    {
        "fqdns": "",
        "id": "/subscriptions/<subscription ID>/resourceGroups/<name>-cli-wt-rg/providers/Microsoft.Compute/virtualMachines/<name>-linux-vm",
        "identity": {
            "systemAssignedIdentity": "<vm object ID>",
            "userAssignedIdentities": {}
        },
        "location": "eastus",
        "macAddress": "00-0D-3A-18-98-5F",
        "powerState": "VM running",
        "privateIpAddress": "10.0.0.4",
        "publicIpAddress": "13.72.111.180",
        "resourceGroup": "<name>-cli-wt-rg",
        "zones": ""
    }

Notice how the default resource group value you set earlier was automatically included along with the subscription and location.  

Configuring
-----------

Before we continue let's set this VM as the default:

.. sourcecode:: bash

    $ az configure --default vm=<name>-linux-vm

Next let's use the VM ``show`` Command to view all of the details of our new VM. The ``show`` Command requires the following Arguments:

- ``-n``: VM name (``--ids`` can be used in place of the name)
- ``-g``: the resource group the VM is in
- ``--subscription``: the subscription the VM is a part of

Since we have configured default values for each of these arguments we do not need to provide any of them to issue the command:

.. sourcecode:: bash

    $ az vm show

If you configured the default VM correctly you should receive a lengthy output object representing the state and configuration of the new VM. We will make use of the ``show`` Command when granting access to the KeyVault in the following section.

KeyVault Secrets
================

As our final step we will provision and configure our KeyVault. Recall that the KeyVault is used to store external configuration values for flexibility and security. We use the KeyVault (and its local counterpart User-Secrets) to keep our protected credentials out of version control.

Exploration
-----------

First explore the command using the ``keyvault`` Group name:

.. sourcecode:: none

    > az keyvault -h

From the KeyVault help we will need to use the ``secret`` Sub-Group along with the ``create`` and ``set-policy`` Commands.

Planning
--------

Looking back on the steps we performed in the web portal we will need to:

- create a KeyVault
- add a secret for the database connection string
- grant permission to the VM so it can access the connection string secret

Creating a KeyVault
^^^^^^^^^^^^^^^^^^^

To create a KeyVault we need to know what arguments it requires. Let's use the help command:

.. sourcecode:: none

    > az keyvault create -h

From the list of arguments we will need to provide:

- ``-n``: the name of the KeyVault
- ``-g``: the resource group name [default configured]
- ``-l``: the location [default configured]

Adding a Connection String Secret
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Let's see what command and arguments we need for creating the connection string secret:

.. sourcecode:: none

    > az keyvault secret -h

We can see that the ``set`` command is used to create or update a secret. What arguments does it require?

.. sourcecode:: none

    > az keyvault secret set -h

We will need to provide:

- ``-n``: the name of the secret
- ``--value``: the value of the secret
- ``--vault-name``: the name of the KeyVault the secret belongs to

Granting VM Access to the KeyVault
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After we provision the KeyVault we will need to set its access policy to allow the VM to read the connection string secret. Let's see what arguments the ``set-policy`` command takes:

.. sourcecode:: none

    > az keyvault set-policy -h

We will need to provide:

- ``-n``: the name of the KeyVault
- ``-g``: the resource group it belongs to [default configured]
- ``--object-id``: the VM object ID that uniquely identifies it for granting access
- ``--secret-permissions``: space-separated list of access permissions to secrets to grant the VM

We will discuss how the ``--object-id`` and ``--secret-permissions`` arguments will be defined in the KeyVault Configuration section.

Provisioning
------------

First let's create the KeyVault itself. KeyVaults, unlike most other resources, have names that **must be globally unique across all Azure accounts**. For this reason we will need to use a unique pattern: 

    ``lc-<YY>-<name>-kv`` with ``YY`` standing for the current 2-digit year. 
    
This pattern should be unique but if you share a name with another student in the class just append your favorite number to the end and make note of it if requesting help from your instructor.

Before issuing the command let's store the KeyVault name in a variable since we will be using it more than once throughout our remaining tasks:

.. sourcecode:: none
    :caption: Windows/PowerShell

    > $KeyVaultName="lc-20-<name>-kv"
    > az keyvault create -n "$KeyVaultName"

.. sourcecode:: bash
    :caption: Linux/Bash

    $ keyvault_name="lc-20-<name>-kv"
    $ az keyvault create -n "$keyvault_name"

After the KeyVault has been provisioned let's set the connection string secret name and value:

- ``--vault-name``: the KeyVault name [stored in a variable]
- ``name``: "ConnectionStrings--Default"
- ``value``: "server=localhost;port=3306;database=coding_events;user=coding_events;password=launchcode"

.. admonition:: Tip

    Recall that secrets are like the other JSON entries in ``application.properties`` that we need to keep private and out of version control. The ``--`` is used as shorthand to define properties of JSON objects in a single "flat" string for the CLI command. In this case it is used to define a property called ``Default`` of a ``ConnectionStrings`` JSON object that would look like this:

    .. sourcecode:: javascript

        "ConnectionStrings": {
            "Default": "<connection string value>"
        }

.. sourcecode:: none
    :caption: Windows/PowerShell

    > az keyvault secret set --vault-name "$KeyVaultName" -n "ConnectionStrings--Default" --value "server=localhost;port=3306;database=coding_events;user=coding_events;password=launchcode"

.. sourcecode:: bash
    :caption: Linux/Bash

    $ az keyvault secret set --vault-name "$keyvault_name" -n "ConnectionStrings--Default" --value "server=localhost;port=3306;database=coding_events;user=coding_events;password=launchcode"

Configuring
-----------

Now that the KeyVault and connection string secret have been managed, all that remains is to to set the access policy for the VM. Earlier we listed two arguments needed for the ``set-policy`` KeyVault command that whose values weren't immediately obvious, the ``--object-id`` and ``--secret-permissions``.

Getting the VM Object ID
^^^^^^^^^^^^^^^^^^^^^^^^

In order to grant access to a resource we need to provide a unique identifier for it. Earlier when we provisioned our VM we used the ``--assign-identity`` argument to generate and assign a **service principal identifier**. Azure documentation refers to this identifier as either a **principal ID** or an **object ID**. 

The VM ``show`` command provided us with a JSON object of configuration details. Issue the ``show`` command again and look for the ``identity`` object property. Within this sub-object is the ``principalId`` that we need.

We can capture this value in a variable by combining the VM ``show`` command with a ``--query`` filter:

.. sourcecode:: none
    :caption: Windows/PowerShell

    > $VmObjectId="$(az vm show --query "identity.principalId")"

.. sourcecode:: bash
    :caption: Linux/Bash

    $ vm_object_id="$(az vm show --query "identity.principalId" -o tsv)"

.. tip::

    While exploring the VM Group you may have noticed a Sub-Group called ``identity`` which is a shortcut for accessing the same information. How would you modify your command and ``--query`` to use this Sub-Group instead?

Least-Privileged Access
^^^^^^^^^^^^^^^^^^^^^^^

The ``--secret-permissions`` Argument accepts a space-separated list of permissions you would like to grant to the given resource object, our VM in this case. Of the many available permissions which should we choose to grant and why?

Remember that whenever you are granting permissions you want to follow the concept of least-privileged access. In our case the API hosted by the VM only needs the ability to *read* from its KeyVault. It has no need for writing or deletion capabilities. The minimum permissions we need to grant to the VM to support this use case are:

- ``get``: for accessing the individual secret values
- ``list``: for accessing the names of secrets so they can be read

Granting VM Access
^^^^^^^^^^^^^^^^^^

It's now time to issue our final command:

.. sourcecode:: none
    :caption: Windows/PowerShell

    > az keyvault set-policy -n "$KeyVaultName" --object-id "$VmObjectId" --secret-permissions get list 

.. sourcecode:: bash
    :caption: Linux/Bash

    $ az keyvault set-policy -n "$keyvault_name" --object-id "$vm_object_id" --secret-permissions get list

If everything went well you should get a confirmation output with a new entry under ``properties.accessPolicies`` for our VM that looks like this:

.. sourcecode:: javascript

    {
        "applicationId": null,
        "objectId": "<vm object ID>",
        "permissions": {
          "certificates": null,
          "keys": null,
          "secrets": [
            "get",
            "list"
          ],
          "storage": null
        },
        "tenantId": "<azure directory ID>"
    }

Next Step
=========

Before moving on let's revisit the web portal and see all the resources we created. Look for your CLI walkthrough resource group. Take a few minutes to see how all of the configurations you performed from the CLI resulted in the same resources as the ones you provisioned before. Remember that the CLI and GUI are just *interfaces* for interacting with the central API that backs them. 

After reviewing your resources it's time to clean up after ourselves by deleting the resource group. This will delete all of the resources contained in it so we don't use up our subscription credits. Notice how we don't have to specify the group because it has been set as a default:

.. sourcecode:: none

    # when prompted enter y for yes
    > az group delete

.. todo:: SECURITY - discuss using service principals for CLI use vs logging in? refer to the addition of our personal account in the access policies list

Congratulations on learning a new way of managing your Azure resources. Now that you have tried both the CLI and GUI, what are the pros and cons of each type of interface? In terms of automation, consider how all of these steps could be accomplished in a single command by composing them into a script. Up next we will learn about provisioning and configuring a new type of VM, the Windows Server, along with its suite of related tools!