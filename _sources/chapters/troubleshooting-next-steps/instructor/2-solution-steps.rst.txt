====================================================
2. Instructor & TAs: Troubleshooting Solution Steps
====================================================

There are many different approaches and orders that can be taken to troubleshoot and fix the deployment. Below are the logical steps for diagnosing and solving each issue starting from the outermost level inwards. 

.. admonition:: Warning

   Let the students know that they should **only issue observational commands**. The resources are restricted to read-only access but within the VM the students can technically do anything the TA can do. Let them know that it is critical to be aware of all changes to system state when troubleshooting.
   
   To that end it is important they understand that:
   
   - the group is relying on trusting everyone not to issue any mutating commands except the TA
   - if they mutate anything on their own they could cause a 10-15 minute delay for resetting the broken deployment (see the instructor solution setup article for instructions)
   
TAs ONLY: Notes for Facilitating
================================

Your primary goal is to provide **the bare minimum guidance to the group**. You should only guide them with hints if they are completely at a loss or way off track. There is ample time for them to troubleshoot and if they do not complete it in time everyone will see the solution during the instructor walkthrough.

.. admonition:: Note

   The temptation as a teacher is to help people who are struggling. But troubleshooting can only be learned through experience. In this context the best help you can provide is the minimal amount necessary to keep them on track. 

You should keep in mind the following additional goals as the facilitator:

- encourage everyone to accept that this is unknown territory **and it is okay to say "I don't know".**
- encourage everyone to perform observational actions on their own and share their findings
- don't allow a few students to dominate the conversation -- make sure every student is engaged (steps below)

.. admonition:: Warning

   **Only take a mutating action** after the group has come to a consensus on what next action to take. Do not start typing it in or reveal it to them before they have considered it.

TAs ONLY: Steps to Facilitate
=============================

At a high level this approach can be used to facilitate discussion by engaging each student in the group and providing hints if they are stuck. There are two lists you will use to stay on track:

#. **list of students**: keep track of who has contributed so every student is involved
#. **list of issues**: (below) to keep track of what next diagnosis or solution step can be used as a hint

.. admonition:: Tip

   As the group begins troubleshooting listen to what they are discovering and cross out the diagnosis step for the related issue. By crossing out steps a student or the group have completed you always know what the next hint should be if necessary.

Starting at the top of the student list select one at a time going down the list and ask "What should we do next?". Let them answer and entertain the group discussing what they are saying.

Using the Prompts
-----------------

To keep the discussion moving forward you can ask the following questions:

- What clues have been discovered so far?
- What level do you think the issue related to?
- What components do you think are involved?
- What tools will you need to use to identify the issue?
- What action do you suggest should be taken and why?
- What clues are presented after your TA attempted to fix the issue?

"I have no idea"
----------------

- ask them to take inventory of where they are in the troubleshooting process (the last known clue or steps taken)
- what issue they are currently facing

.. admonition:: Note

   If they are still not progressing then let them struggle for 3-5 minutes. Students should feel the tension of not knowing which will promote them to get creative. 

   **If there is still no progress then proceed to the next approach**:

Not Progressing
---------------

.. admonition:: Warning

   Give the students time to discuss and troubleshoot. **Only use this approach if they are not making progress** because they are: 

   - not suggesting a next action to take
   - are way off track

Starting from the top of the **list of issues** select the next available diagnosis or solution step and use it as a hint. As each diagnosis or solution step is taken by the student / group make sure to cross it out.

.. admonition:: Note

   Each step has an action on the left and (the outcome to discuss in parenthesis)

VM is not Running
=================

Diagnosis
---------

#. make an **external** request through: postman, browser, Invoke-RestMethod (network error: connection timeout)
#. try to SSH into the box (timeout)
#. is the VM running (Azure Portal `broken-linux-vm` status: Stopped)

Solution
--------

#. start the vm with ``az vm start``
#. SSH into the box

NSG
===

Diagnosis
---------

#. make an **external** request through: postman, browser, Invoke-RestMethod (network error: connection timeout)
#. check your NSGs (NSG does not contain an inbound rule for port 443)

Solution
--------

#. create a new NSG inbound rule for port 443 

NGINX
=====

Diagnosis
---------

#. make an internal request with curl (network error: connection refused)
#. check the web server from box ``service ngin x status`` (inactive (dead))

Solution
--------

#. ``sudo service nginx start``
#. ``service nginx status`` (active (running))

MySQL
=====

Diagnosis
---------

#. make an internal request with curl (HTTP status: 502 bad gateway)
#. check the mysql service from box ``service mysql status`` (inactive (dead))

Solution
--------

#. ``service mysql start``
#. ``service mysql status`` (active (running))

Wrong KV name
=============

Diagnosis
---------

#. make an internal request with curl (HTTP status: 502 bad gateway)
#. ``journalctl -fu coding-events-api`` (``Unhandled exception. System.UriFormatException: Invalid URI: The hostname could not be parsed.``)
#. research error message
#. ``cat /opt/coding-events-api/appsettings.json`` (notice the value for ``KeyVaultName`` is blank)

Solution
--------

#. get the name for the Key Vault (``az keyvault list --query '[0].name'`` or use the Azure Portal)
#. edit the file (``sudo nano /opt/coding-events-api/appsettings.json``)
#. enter the value for ``KeyVaultName`` you found in step one
#. save the file in ``nano`` editor with ``ctrl+o`` and then hit enter to confirm
#. exit ``nano`` editor with ``ctrl+x``
#. restart the service to reload the ``appsettings.json`` file (``sudo service coding-events-api restart``)

KV access policy
================

Diagnosis
---------

#. make an internal request with curl (HTTP status: 502 bad gateway)
#. ``journalctl -fu coding-events-api`` (``Unhandled exception. Microsoft.Azure.KeyVault.Models.KeyVaultErrorException: Operation returned an invalid status code 'Forbidden'``)
#. research error message
#. check KV access policies for VM (it's missing)

Solution
--------

#. check the help of az keyvault (``az keyvault -h``)
#. check the help of az keyvault set-policy (``az keyvault set-policy -h``, need objectId and Key Vault Name)
#. store object id of VM in variable (``$VmId = az vm show --query 'identity.principalId'``)
#. store Key Vault name in variable (``$KvName = az keyvault list --query '[0].name'``)
#. create new KV secrets access policy for VM (az keyvault set-policy --name $KvName --object $VmId --secret-permissions list get)