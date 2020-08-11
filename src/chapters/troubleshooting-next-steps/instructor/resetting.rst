==========================
Instructor & TAs Resetting
==========================

Reset the Broken Deployment
===========================

.. admonition:: Warning

   Resetting will remove all progress. You will start with a fresh broken deployment. However, you can re-issue any correct actions to get back to where you were before.

If after following all the solution steps the deployment is still not fixed it means a student may have mutated something in the VM without your knowledge.

You can re-run the script and it will:

- automatically destroy the system
- recreate the broken deployment to its initial state

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # in powershell-az-cli-scripting-deployment/ dir
   # on the tps-reports branch
   > ./full-deployment.ps1

.. admonition:: Note

   This process will take 10-15 minutes. During this time you can have a dialogue about what went wrong and what else needs to be done.

Reset Your ``az CLI``
=====================

First get the list of your subscriptions:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > az account list

In the list select the subscription you want to switch back to and copy the ``id`` field value. Then set this as the default subscription:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > az account set -s <account id value>
   > az account show
   # confirm the correct subscription is set

.. admonition:: Note

   If you know the subscription name (or at least enough chars to uniquely identify it) you can use this shortcut:

   .. sourcecode:: powershell
      :caption: Windows/PowerShell
   
      # put the name inside the single quotes
      > $SubscriptionName = ''
      > az account set -s $(az account list --query "[? contains(name, '$SubscriptionName') ] | [0].id")

   Adjusted to Bash you just need to add ``-o tsv`` for the output format and update the variable syntax:

   .. sourcecode:: bash
      :caption: Linux/BASH
   
      # put the name inside the single quotes
      $ subscription_name=''
      $ az account set -s $(az account list -o tsv --query "[? contains(name, '$subscription_name') ] | [0].id")

   Example switching between troubleshooting lab subscription and main (called ``Azure subscription 1``):

   .. sourcecode:: bash
      :caption: Linux/BASH
   
      # just enough to uniquely identify it
      $ subscription_name='Azure subscription'
      $ az account set -s $(az account list -o tsv --query "[? contains(name, '$subscription_name') ] | [0].id")
      
      $ az account show
      # main subscription

      $ subscription_name='Troubleshooting'
      $ az account set -s $(az account list -o tsv --query "[? contains(name, '$subscription_name') ] | [0].id")
      
      $ az account show
      # troubleshooting subscription