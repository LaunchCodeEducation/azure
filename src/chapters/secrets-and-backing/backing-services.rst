================
Backing Services
================

External Application Dependencies
=================================

- Database
- Logging
- Caching
- Ideally live on separate infrastructure

.. todo:: fit in

Least-Privileged Access
^^^^^^^^^^^^^^^^^^^^^^^

The ``--secret-permissions`` argument accepts a space-separated list of permissions you would like to grant to the given resource object, our VM in this case. Of the many available permissions which should we choose to grant and why?

In an ideal world your resources interact responsibly with each other and everything goes according to plan. But there can be disastrous consequences if they are given greater access privileges than needed to support that plan. 

Whenever you are granting permissions you want to follow the concept of **least-privileged access**: 

.. tip::

    Granting **least-privileged access** means to grant the bare minimum permissions needed to support the **current use case**.

Mistakes can happen within your team due to bugs or misconfigurations that, without access restriction, can result in havoc. For example, imagine a VM that due to a bug and broad access ends up deleting or overwriting mission-critical KeyVault secrets. If instead its access were restricted initially the result would have just been a crash report when its bugged request was rejected by the access policy. 

Even worse is the threat of a malicious user that gains access to a resource within the system. Many of the high-profile security failures you hear about were predicated on an attacker exploiting an over-privileged resource to do things it was never intended to do. Without proper access control these sorts of scenarios are a real threat to the work you do.

Never grant broad access because "we might need it later" or out of laziness. Granting additional access permissions is trivial if needed in the future by simply issuing another ``set-policy`` command. However, if you grant broad permissions from the start it can be challenging at best to undo the actions that an over-privileged service performs when misused. It is important to always review the available access permissions and consider their ramifications before granting them. 

In our case the API hosted by the VM only needs the ability to *read* from its KeyVault. It has no need for writing or deletion capabilities. The minimum permissions we need to grant to the VM to support this use case are:

- ``list``: for accessing the names of secrets
- ``get``: for accessing the individual secret values