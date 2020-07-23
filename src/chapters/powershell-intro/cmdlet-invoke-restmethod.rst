===========================================
Making API Requests Using Invoke-RestMethod
===========================================

`Invoke-RestMethod <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7>`_ is a PowerShell cmdlet that gives the ability to send requests from the command-line to a REST API. 

``Invoke-RestMethod`` can be used to make web requests to any server, but is specifically tuned to work with REST APIs that use JSON as their data representations.

.. admonition:: Note

    The `Invoke-WebRequest <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7>`_ cmdlet is a more generalized tool for working with other formats like XML or HTML.

Command-Line REST
=================

Throughout this class we have used Postman as a way for making requests to a RESTful API. Postman offers a GUI that is a very pleasant interface to work with, however a GUI is not always the best interface for a given job. 

A benefit of making requests from the CLI is that you can combine as many requests as necessary into a single script. This grants the ability to automate interactions with a RESTful API.

Invoke-RestMethod
=================

In a similar vein to Postman, ``Invoke-RestMethod`` allows you to fully configure each HTTP request including setting the: 

- URI
- method
- headers
- body

The JSON responses received by an ``Invoke-RestMethod`` call are automatically converted from a JSON-formatted string to a `PSCustomObject <https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-pscustomobject?view=powershell-7>`_. The fields of the JSON response are then accessible as properties of this object using dot notation.

.. admonition:: Tip

   These response objects can be used directly within a PowerShell session, in a script or can be saved to a JSON file.

Open-Notify Examples
====================

   Open-Notify is a publicly available REST API that returns information about astronauts in space.
   
The `Open-Notify API <http://open-notify.org/>`_ contains live data that is continuously updated. Let's explore this API by making a simple ``GET`` request for its ``Astros`` Resource using ``Invoke-RestMethod``.

Astronaut Resource Shapes
-------------------------

The ``Astros`` Resource has the following shape:

.. sourcecode:: json
   :caption: the Astros Resource shape

   {
      message: integer,
      number: integer,
      people: Person[]
   }

The ``people`` field is an array of ``Person`` Resources with the following shape:

.. sourcecode:: json
   :caption: Person Resource shape

   {
      name: string,
      craft: string
   }

Making a request
----------------

Let's make a ``GET`` request for the ``Astros`` Resource. If you don't specify the request method it will default to ``GET``.

``Invoke-RestMethod`` will convert the JSON response to a ``PSCustomObject``. By default these Custom Objects are printed in the Terminal in a table presentation:

.. sourcecode:: powershell

   > Invoke-RestMethod -URI "http://api.open-notify.org/astros.json"

   message number people
   ------- ------ ------
   success      5 {@{craft=ISS; name=Chris Cassidy}, @{craft=ISS; name=Anatoly Iv…

Grouping to access fields of the JSON response
----------------------------------------------

Using the grouping operator we can access just the ``people`` array property of the Custom Object in the following way:

.. sourcecode:: powershell

   > (Invoke-RestMethod -URI "http://api.open-notify.org/astros.json").people

   craft name
   ----- ----
   ISS   Chris Cassidy
   ISS   Anatoly Ivanishin
   ISS   Ivan Vagner
   ISS   Doug Hurley
   ISS   Bob Behnken

.. admonition:: Note

   Recall that the grouping operator will cause the ``Invoke-RestMethod`` to be executed *first*. The resulting Custom Object can then have its properties accessed using dot notation on the closing ``)``.

Piping to access nested fields
------------------------------

Because we are working with objects we can filter it down further by piping the ``people`` array object to the ``Select-Object`` cmdlet:

.. sourcecode:: powershell

   > $uri = "http://api.open-notify.org/astros.json"
   > (Invoke-RestMethod -URI $uri).people | Select-Object -Property name

   name
   ----
   Chris Cassidy
   Anatoly Ivanishin
   Ivan Vagner
   Doug Hurley
   Bob Behnken

Storing response objects in a reusable variable
-----------------------------------------------

Storing the result in a variable becomes useful so we don't have to keep making the same request to access it's data:

.. sourcecode:: powershell

   > $webRequest = Invoke-RestMethod -URI "http://api.open-notify.org/astros.json"

We can then work with the data through the variable. For example, we can access the ``people`` field:

.. sourcecode:: powershell

   > $webRequest.people

   craft name
   ----- ----
   ISS   Chris Cassidy
   ISS   Anatoly Ivanishin
   ISS   Ivan Vagner
   ISS   Doug Hurley
   ISS   Bob Behnken

We can also access the nested ``name`` field of one of the astronauts by chaining property and array access:

.. sourcecode:: powershell

   > $webRequest.people[0].name

   Chris Cassidy

Sorting response data
---------------------

We can even use our variable to control how the ``people`` array is sorted by piping it to the ``Sort-Object`` cmdlet:

.. sourcecode:: powershell

   > $webRequest.people | Sort-Object -Property name

   craft name
   ----- ----
   ISS   Anatoly Ivanishin
   ISS   Bob Behnken
   ISS   Chris Cassidy
   ISS   Doug Hurley
   ISS   Ivan Vagner

Converting to other formats
---------------------------

We can combine these steps in a longer pipe that:

#. accesses the ``people`` array field
#. sorts each ``Person`` element by their nested ``name`` field
#. converts the sorted array into a CSV format

.. sourcecode:: powershell

   > $webRequest.people | Sort-Object -Property name | ConvertTo-Csv
   
   "craft","name"
   "ISS","Anatoly Ivanishin"
   "ISS","Bob Behnken"
   "ISS","Chris Cassidy"
   "ISS","Doug Hurley"
   "ISS","Ivan Vagner"

Saving and loading as CSV files
-------------------------------

In many cases it is beneficial to save transformed responses to a file for later use. Rather than just printing the converted results we can use the ``Export-Csv`` cmdlet to write it to a file:

.. sourcecode:: powershell

   > $webRequest.people | Sort-Object -Property name | Export-Csv "people.csv"

You can then use the ``Get-Content`` cmdlet to view the CSV contents *as strings*:

.. sourcecode:: powershell

   > Get-Content people.csv
   
   "craft","name"
   "ISS","Anatoly Ivanishin"
   "ISS","Bob Behnken"
   "ISS","Chris Cassidy"
   "ISS","Doug Hurley"
   "ISS","Ivan Vagner"

Saving and loading as JSON files
--------------------------------

If we wanted to save in a JSON format we would need to add an additional step in our pipeline to convert the Custom Object back to a JSON string.

We use the ``ConvertTo-Json`` cmdlet to accomplish this *serialization* from an object back to a JSON string:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # (scroll to view)
   > $webRequest.people | Sort-Object -Property name | ConvertTo-Json | Set-Content "people.json"

.. admonition:: Note

   We can also split up this pipeline to make it more readable:

   .. sourcecode:: powershell
      :caption: Windows/PowerShell
   
      > # split for readability
      > $SortedPeople = $webRequest.people | Sort-Object -Property name
      > $SortedPeople | ConvertTo-Json | Set-Content "people.json"
   

This approach is invaluable for practicing with data transformations. Whereas a variable in our PowerShell Terminal will disappear after closing, a file can be reused indefinitely and shared with others.

You can then load the JSON contents *as a string* using ``Get-Content``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Content "people.json"

   [
      {
         "craft": "ISS",
         "name": "Anatoly Ivanishin"
      },
      {
         "craft": "ISS",
         "name": "Bob Behnken"
      },
      {
         "craft": "ISS",
         "name": "Chris Cassidy"
      },
      {
         "craft": "ISS",
         "name": "Doug Hurley"
      },
      {
         "craft": "ISS",
         "name": "Ivan Vagner"
      }
   ]

However, in order to work with the JSON contents as Custom Objects we need to convert it back (*deserialize*) using the ``ConvertFrom-Json`` cmdlet. This will enable dot notation access of fields like in the original ``Invoke-RestMethod`` output:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Content "people.json" | ConvertFrom-Json

   craft name
   ----- ----
   ISS   Anatoly Ivanishin
   ISS   Bob Behnken
   ISS   Chris Cassidy
   ISS   Doug Hurley
   ISS   Ivan Vagner

The ``Invoke-RestMethod`` cmdlet is a powerful tool for working with APIs. When combined with our knowledge of PowerShell we have many options for interacting with a REST API and transforming the data we receive.

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

