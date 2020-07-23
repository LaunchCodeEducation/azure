=========================
Cmdlet: Invoke-RestMethod
=========================

PowerShell is filled with cmdlets that allow you to accomplish many things. This chapter has done a good job of introducing the foundational features of PowerShell. However, to use PowerShell to its fullest extent you must be willing to continue learning and practicing. This article will introduce a new cmdlet, ``Invoke-RestMethod``. 

`Invoke-RestMethod <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7>`_ is a cmdlet that gives the ability to send Rest web requests from a powershell session.

.. admonition:: tip

   This article is a great opportunity for you to combine cmdlets, pipes, expressions, variables, etc to build your PowerShell skills. Work through the examples, and then try them out with other things you have learned throughout this chapter.

Command-Line REST
=================

Throughout this class we have used Postman as a way for making requests to a RESTful API. Postman offers a GUI that is a very pleasant interface to work with, however a GUI is not always the best interface for a given job. 

A benefit of making requests from the CLI is that you can combine as many requests as necessary into a single script. This grants the ability to automate interactions with a RESTful API, like endpoint testing.

Invoke-RestMethod
=================

In a similar vein to Postman, ``Invoke-RestMethod`` allows you to set the HTTP request: 

- URI
- HTTP method
- headers
- body
- etc

The ``Invoke-RestMethod`` cmdlet makes an HTTP request the server returns an HTTP response as a JSON object that can be mapped directly to a `PSCustomObject <https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-pscustomobject?view=powershell-7>`_. 

This object can be used directly within a PowerShell session, or can be saved in a JSON file. You will see examples below.

Open-Notify Examples
--------------------

To start we will make a request for the ``astros.json`` file:

.. sourcecode:: powershell

   > Invoke-RestMethod -URI http://api.open-notify.org/astros.json

   message number people
   ------- ------ ------
   success      5 {@{craft=ISS; name=Chris Cassidy}, @{craft=ISS; name=Anatoly Iv…

Invoke-RestMethod returns a Custom Object that contains a message, and the payload of the request. The request was successful and the payload contains a string representation of JSON containing the number of people in space, a collection of their names, and the space craft they are currently on.

Following is an example of how we could access just the ``people`` property of the Custom Object:

.. sourcecode:: powershell

   > (Invoke-RestMethod -URI http://api.open-notify.org/astros.json).people

   craft name
   ----- ----
   ISS   Chris Cassidy
   ISS   Anatoly Ivanishin
   ISS   Ivan Vagner
   ISS   Doug Hurley
   ISS   Bob Behnken

In this case we are simply looking at one field associated with the Custom Object in this case, all the astronauts currently in space and their spacecraft.

If we want to filter it down further we can use a pipe and the ``Select-Object`` cmdlet:

.. sourcecode:: powershell

   > (Invoke-RestMethod -URI http://api.open-notify.org/astros.json).people | Select-Object -Property name

   name
   ----
   Chris Cassidy
   Anatoly Ivanishin
   Ivan Vagner
   Doug Hurley
   Bob Behnken

Storing the result in a variable becomes useful so we don't have to keep making the same request to access it's data:

.. sourcecode:: powershell

   > $webRequest = Invoke-RestMethod -URI http://api.open-notify.org/astros.json 

Then accessing the variable:

.. sourcecode:: powershell

   > $webRequest.people[0].name

   Chris Cassidy

.. sourcecode:: powershell

   > $webRequest.people

   craft name
   ----- ----
   ISS   Chris Cassidy
   ISS   Anatoly Ivanishin
   ISS   Ivan Vagner
   ISS   Doug Hurley
   ISS   Bob Behnken

We can even use our variable to determine how the data is sorted (``Sort-Object``):

.. sourcecode:: powershell

   > $webRequest.people | Sort-Object -Property name

   craft name
   ----- ----
   ISS   Anatoly Ivanishin
   ISS   Bob Behnken
   ISS   Chris Cassidy
   ISS   Doug Hurley
   ISS   Ivan Vagner

Combining everything so far we can convert our response to CSV:

.. sourcecode:: powershell

   > $webRequest.people | Sort-Object -Property name | ConvertTo-Csv
   
   "craft","name"
   "ISS","Anatoly Ivanishin"
   "ISS","Bob Behnken"
   "ISS","Chris Cassidy"
   "ISS","Doug Hurley"
   "ISS","Ivan Vagner"

And finally writing this data to a CSV file:

.. sourcecode:: powershell

   > $webRequest.people | Sort-Object -Property name | Export-Csv "people.csv"


.. sourcecode:: powershell

   > Get-Content people.csv
   
   "craft","name"
   "ISS","Anatoly Ivanishin"
   "ISS","Bob Behnken"
   "ISS","Chris Cassidy"
   "ISS","Doug Hurley"
   "ISS","Ivan Vagner"

The ``Invoke-RestMethod`` cmdlet is a powerful tool for working with APIs. When combined with our knowledge of PowerShell we have a huge toolbox of things we can do with the data. 

To finish this article we will look at how we could use the ``Invoke-RestMethod`` cmdlet with our CodingEventsAPI.

CodingEventsAPI Examples
========================

.. admonition:: warning

   The following examples will not work unless you run your application locally.

Get Example
-----------

To get a collection of coding events you could use:

.. sourcecode:: powershell

   > Invoke-RestMethod -Uri http://localhost:5000/api/events


To get an individual coding event entity you could use:

.. sourcecode:: powershell

   > Invoke-RestMethod -Uri http://localhost:5000/api/events/{id}

Post Example
------------

To post a new coding event entity you could use:

.. sourcecode:: powershell

   > $body = @{
         "Title": "halloween hackathon!",
         "Description": "A gathering of nerdy ghouls to work on github hacktoberfest contributions",
         "Date": "2020-10-30"
      }

   > Invoke-RestMethod -Method "Post" -Uri http://localhost:5000/api/events -Body $body

Put Example
-----------

To update an existing coding event entity you could use:

.. sourcecode:: powershell

   > $body = @{
         "Title": "Halloween Hackathon!",
         "Description": "A gathering of nerdy ghouls to work on GitHub Hacktoberfest contributions",
         "Date": "2020-10-31"
      }

   > Invoke-RestMethod -Method "Put" -Uri http://localhost:5000/api/events/{id} -Body $body

Delete Example
--------------

To delete an existing coding event entity you could use:

.. sourcecode:: powershell

   > Invoke-RestMethod -Method "Delete" -Uri https://localhost:5000/api/events/{id}

Invoke-RestMethod Additional Options
------------------------------------

You have seen how the ``-Method`` and ``-Body`` options work. ``-Method`` allow us to define which type of HTTP method to use with our request. ``-Body`` allows us to define the request body that serves as a JSON representation of the data with our request.

There are a lot of additional options we can use to further configure the requests sent with ``Invoke-RestMethod``. You should look over the documentation of `Invoke-RestMethod <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7>`_ to get an understanding of everything that can be done, but you will most likely recognize some common flags like:

- ``-Headers``: used to define custom headers with our request
- ``-Authentication``: used to define the authentication type (bearer, oauth, etc), this automatically creates the proper header
- ``-Token``: used to define the oauth or bearer token to be included with the request this automatically creates the proper header

Continue Learning
=================

In an earlier lesson we used Postman to test out our CodingEventsAPI. If you have extra time in this course we recommend writing a PowerShell script that uses the ``Invoke-RestMethod`` cmdlet to send requests to all of the endpoints with the proper information.

You can work with any RESTful APIs using the ``Invoke-RestMethod`` cmdlet. To continue practicing you can self-host your own API, or you can find any publicly available APIs like the `GitHub Developer API <https://developer.github.com/v3/>`_.

