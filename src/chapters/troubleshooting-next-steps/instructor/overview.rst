===========================
Instructors & TAs: Overview
===========================

There are internal and student steps. The list below is all the steps combined and the order they should take place in.

.. admonition:: Note

   The instructor can decide on the timing for all of this. A suggested schedule is:

   - 20-30 minutes for the group discussion
   - 15 minutes for student setup and confirmation
   - 1.5-2 hours for the group troubleshooting
   - 20-30 minutes for instructor solution walkthrough

Overview of Issues
==================

#. **connection timeout**: VM is not running
#. **connection timeout**: NSG inbound rule for port 443 is missing
#. **connection refused**: NGINX service is down
#. **502 bad gateway**: MySQL service is down
#. **502 bad gateway**: ``appsettings.json`` doesn't contain the correct KV name
#. **502 bad gateway**: VM not granted access to KV

Before Walkthrough: Instructor & TAs
====================================

.. admonition:: Warning

   If you set up the lab and roles before the day of the walkthrough **make sure to tell the students to only confirm they received the email -- not to open it**.

   Tell them they may read the walkthrough but **should not do any of the setup until the walkthrough itself**.

#. instructor and TA setup steps
#. students can read over the conceptual article and walkthrough **but do not do the student setup**

Walkthrough: TAs
================

The walkthrough is facilitated by the TA with all the students in their group.

.. todo:: automate or include step of creating the final coding event

#. **group**: discussion of the system expectations
#. **student**: (follow walkthrough instructions) setup their access and ``az CLI``
#. **student**: (follow walkthrough instructions) setup their Postman
#. **TA**: confirm all students have access and ``az CLI`` are working
#. **group**: troubleshooting
#. **student**: final step to join the coding event

Walkthrough Solution: Instructor
================================

After the time is up the instructor will walk the class through the solution. You can use the TA solution steps as a guide which is guaranteed to work if going from top to bottom. However, feel free to solve it any way you feel comfortable teaching. 