========================================
Development Troubleshooting Case Studies
========================================

Development issues relate to the source code of a deployed application. *Ideally* these issues are discovered before reaching the live production environment by automated tests and Quality Assurance testers. However, sometimes these issues are discovered by end users who report that the application is not behaving correctly. 

In these situations, the deployment isn't necessarily broken, but the application is not behaving properly.

Case Study: 500 Internal Server Error
=====================================

Realize Issue
-------------

A user sends a report that they received an HTTP response of ``500 Internal Server Error`` when sending a GET request for a specific coding event.

A ``500 Internal Server Error`` is almost *always* the result of a runtime error within the source code of the application.

Identify Issue through Duplication
----------------------------------

We first reproduce the issue by requesting the specific coding event, and then we continue attempting to reproduce the issue with other specific coding events. We are trying to determine if it is something special about this one coding event, or if it is a behavior seen across all coding events. In this case, it's only the one specific coding event that is experiencing this issue.

Research Potential Causes
-------------------------

In researching potential causes across the Internet and talking to some of the developers on the team, we come up with one potential reason:

- This coding event may have a special character that is not serializing to or from the database correctly

Isolate Root Cause
------------------

It's a short list, but at least we can check something. 

We fire up MySQL and make a request for the specific coding events record. We notice this coding event has some special characters in it: ``â€``. We put in a breakpoint to pause the application before it pulls the data out of the database and step through the code. Alas, as our API tries to serialize the special characters, the ORM throws an error and our API returns a ``500 Internal Server Error``.

Research Root Cause Fixes
-------------------------

Next we research solving this error and find a couple of solutions:

- Change the underlying data in MySQL
- Implement a third-party library that assists in special character serialization
- Write our own database special character serialization library

It is never a good idea to change the underlying data that is owned by end users, so the first option is out. The remaining two options have obvious pros and cons. It would be faster to use the third party library, however we would need to research the library to make sure it doesn't contain insecure code and that it won't break any of our existing functionality. Writing our own library would give us full control and the ability to make it as secure as we need, but would take development time.

.. admonition:: Note

   The decision between using a third-party library and writing an in-house solution is one that is typically made by management and senior level engineers. This is a situation in which effectively communicating the issue is extremely important.

Implement Root Cause Fix
------------------------

Being a junior dev, we decide *this issue needs to be elevated to our superior*, as we don't feel comfortable reviewing the security of a third-party library. 

We explain the issue, the solutions we found, and pass the information to our senior who thanks us for not only finding the issue, but for researching potential fixes. The senior engineers will research the third-party library and management will decide on the proper course of action.

Communicate Issue With Others
-----------------------------

A communication to the affected team members might look like this:

   An HTTP ``500 Internal Server Error`` was encountered when a database record contained various special characters. Upon debugging the application, it was discovered that the current ORM serialization libraries were incapable of working with various special characters. The issue was elevated to senior developers who are determining how to resolve the issue.

.. admonition:: Note

   The Coding Events API does not behave this way, so you won't encounter this issue when running that app. This was simply a hypothetical example of how a 500 Internal Server Error could occur and how you may resolve, or in this case, identify, isolate, research, and pass it to a more senior developer.

Case Study: API Bug
===================

Realize Issue
-------------

A user reports a bug in the API. It isn't throwing any errors, but the application is not behaving correctly. When the user deletes a coding event they are the owner of, they can still view and edit the coding event.

An API bug is almost *always* the result of a logic error within the source code of the application.

Identify Issue Through Duplication
----------------------------------

We first reproduce the issue with a copy of the exact event in which we also experience the incorrect DELETE error. We also notice that any coding event we create cannot be deleted, despite a proper DELETE request coming through.

Research & Isolate Root Cause
-----------------------------

We research the issue. Luckily, this is easy because we know how a RESTful API works and feel confident looking at the source code. Upon looking at the source code, we can see the line that sends the resource deletion to the ORM is commented out and skips straight to sending back a ``204 No Content``. Our research indicates:

- Fixing the source code error may resolve the issue

Implement Root Cause Fix
------------------------

We build the project locally on our machine and make the change. It seems to work, however since we are not a developer on this project we will just communicate this issue and resolution to the responsible dev team. After all, the dev team may have their reasons for that specific line we edited.

Luckily, we are very capable of explaining the issue, our research, and our proposed solution to the problem. After communicating it to them, the dev team will be responsible for making the change and running it through the automated tests to make sure the change doesn't result in any unexpected behaviors.

Communicate Issue with Others
-----------------------------

A communication to the affected team members might look like this:

   Users reported that after deleting an event the event was still accessible. We reproduced the issue and found that the reported behavior was consistent across all events. Upon investigating the issue it was determined that the RESTful API event DELETE method was not implemented correctly. The dev team needs to re-examine this method to determine why the RESTful API is not deleting resources correctly.

.. admonition:: Note

   The Coding Events API does not behave this way. This was a hypothetical example to illustrate a logic error in a deployed application.

In summary, we understand the steps of the troubleshooting process and have seen examples of how it can be used to effectively:

- Realize issues
- Identify issues
- Research potential causes
- Isolate root causes
- Resolve issues
- Verify the resolution of issues
- Communicate about issues and their solutions

Next Steps
==========

We have seen three different case studies that illustrate the troubleshooting process and have gained an *understanding of the troubleshooting process*.

The next section will provide opinionated strategies on *how* to troubleshoot issues using this process.