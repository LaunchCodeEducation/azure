=========================
Cmdlet: Invoke-RestMethod
=========================

PowerShell is filled with Cmdlets that allow you to accomplish many things. This chapter has done a good job of introducing the foundational features of PowerShell. However, to truly to take advantage of this tool you must be willing and able to continue learning and practicing this tool.

That's what we will do in this article, learn about and practice a PowerShell cmdlet. Not only will we talk about what the cmdlet is and how it is used, but we will emphasize **why** you may want to use this tool.

We will be working with the `Invoke-RestMethod <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7>`_.

Command-Line REST
=================

Throughout this class we have used Postman as a way for making requests to a RESTful API. Postman offers a GUI that is a very pleasant interface to work with, however a GUI is not always the best interface for a given job. 

PowerShell offers multiple cmdlets for making HTTP requests from the CLI. A benefit of making requests from the CLI is that you can combine as many requests as you want and run them in a single script. This gives you the power to script interactions with a RESTful API to automate tasks.

Invoke-RestMethod
=================

In a similar vein to Postman, ``Invoke-RestMethod`` allows you to set the request: URI, HTTP method, headers, body, and more all from a PowerShell terminal. 

The ``Invoke-RestMethod`` cmdlet makes an HTTP request the server returns an HTTP response as a JSON object that can be mapped directly to a `PSCustomObject <https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-pscustomobject?view=powershell-7>`_ which can be used directly with PowerShell, or can be saved in a JSON file. 

.. ::

   The ``Invoke-RestMethod`` cmdlet returns a JSON object that is seamless to interact with using PowerShell. We can easily access any attached properties or sub-collections from the response body using the familiar dot-notation and collection index selection syntax. In addition many PowerShell cmdlets can take the JSON response object returned from ``Invoke-RestMethod`` as an argument when using pipes (``|``) and sub-expressions (``$()``).

Open-Notify Examples
--------------------

To start we will make a request for the ``astros.json`` file:

.. sourcecode:: powershell

   > Invoke-RestMethod -URI http://api.open-notify.org/astros.json

   message number people
   ------- ------ ------
   success      5 {@{craft=ISS; name=Chris Cassidy}, @{craft=ISS; name=Anatoly Iv…

Invoke-RestMethod returns a Custom Object that contains a message, and the payload of the request. The request was successful and the payload contains a string representation of JSON containing the number of people in space, and a collection of their names, and the space craft they are currently on.

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

In this case we are simply looking at one field associated with the Custom Object, in this case all the astronauts currently in space.

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

Continue exploring ``Invoke-RestMethod`` and the `Open Notify API <http://api.open-notify.org/>`_. The following studio will require you to use the same PowerShell tools to gather, organize, and write data from the `GitHub Developers API <https://developer.github.com/v3/>`_.

To finish this article we will look at how we could use the ``Invoke-RestMethod`` cmdlet with our CodingEventsAPI.

.. admonition:: note

   The following examples won't work unless you run your application locally.

CodingEventsAPI Examples
========================

Get Example
-----------

.. sourcecode:: powershell

   > Invoke-RestMethod -Uri http://localhost:5000/api/events

.. sourcecode:: powershell

   > Invoke-RestMethod -Uri http://localhost:5000/api/events/{id}

Post Example
------------

.. sourcecode:: powershell

   > $body = @{
         "Title": "halloween hackathon!",
         "Description": "A gathering of nerdy ghouls to work on github hacktoberfest contributions",
         "Date": "2020-10-30"
      }

   > Invoke-RestMethod -Method "Post" -Uri http://localhost:5000/api/events -Body $body

Put Example
-----------

.. sourcecode:: powershell

   > $body = @{
         "Title": "Halloween Hackathon!",
         "Description": "A gathering of nerdy ghouls to work on GitHub Hacktoberfest contributions",
         "Date": "2020-10-31"
      }

   > Invoke-RestMethod -Method "Put" -Uri http://localhost:5000/api/events/{id} -Body $body

Delete Example
--------------

.. sourcecode:: powershell

   > Invoke-RestMethod -Method "Delete" -Uri https://localhost:5000/api/events/{id}

Additional Options
------------------

You have seen how the ``-Method`` and ``-Body`` options work. ``-Method`` allow us to define which type of HTTP method to use with our request. ``-Body`` allows us to define the request body that serves as a JSON representation of the data with our request.

There are a lot of additional options we can use to further configure the requests sent with ``Invoke-RestMethod``. You should look over the documentation of `Invoke-RestMethod <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7>`_ to get an understanding of everything that can be done, but you will most likely recognize some common flags like:

- ``-Headers``: used to define custom headers with our request
- ``-Authentication``: used to define the authentication type (bearer, oauth, etc)
- ``-Token``: used to define the oauth or bearer token to be included with the request

