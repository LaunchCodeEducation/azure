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

Using the grouping operator we can access the ``people`` array property of the Custom Object in the following way:

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

   The grouping operator will cause the ``Invoke-RestMethod`` to be executed *first*. The resulting Custom Object can then have its properties accessed using dot notation on the closing parenthesis: ``)``.

Piping to access nested fields
------------------------------

Because we are working with objects we can filter the response down further by piping the ``people`` array object to the ``Select-Object`` cmdlet:

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

Let's test this out with our Coding Events API. To keep things simple let's use the ``1-sqlite`` branch so we don't need to worry about setting up a database, a secrets manager, or AADB2C.

Run this branch to start the Coding Events API on your local machine.

GET Example
-----------

To get a collection of coding events you could use:

.. sourcecode:: powershell

   > Invoke-RestMethod -Uri "http://localhost:5000/api/events"

To get an individual coding event entity you could use:

.. sourcecode:: powershell

   > $CodingEventId = 1
   > Invoke-RestMethod -Uri "http://localhost:5000/api/events/$CodingEventId"

DELETE Example
--------------

To delete an existing coding event entity you could use:

.. sourcecode:: powershell

   > $CodingEventId = 1
   > $uri = "http://localhost:5000/api/events/$CodingEventId"
   > Invoke-RestMethod -Method "Delete" -Uri $uri

POST Example
------------

To create a new coding event we need to use two additional options:

- ``-Method``: to set the ``POST`` HTTP method
- ``-Body``: to define the body of the ``POST`` request

To provide the body of the request you can use a `HashTable object <https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-hashtable?view=powershell-7#what-is-a-hashtable>`_ or a `here-string <https://4sysops.com/archives/the-powershell-here-string-preserve-text-formatting/>`_.

The ``HashTable`` object is simple to create:

.. sourcecode:: powershell

   > $body = @{
       Title = "Halloween Hackathon!"
       Description = "A gathering of nerdy ghouls..."
       Date =  "2020-10-30"
     }

.. admonition:: Note

   The ``HashTable`` object **does not have any commas** and uses the ``=`` assignment operator for defining each key-value entry.

However, before it can be used in the request it **must be converted to JSON** with an appropriate ``Content-Type`` header. 

We can use:

- ``ConvertTo-Json``: in a grouped expression to serialize the ``HashTable`` as a JSON string
- the ``-ContentType`` option: to automatically set the ``Content-Type`` header of ``application/json``

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > $uri = "http://localhost:5000/api/events"
   > Invoke-RestMethod -Method "Post" -Uri $uri -Body ($body | ConvertTo-Json) -ContentType "application/json"

Using a JSON file
^^^^^^^^^^^^^^^^^

You can also load the body from a json file. This allows you to use existing files or a GUI editor to create the JSON body in a more intuitive way.

Let's assume we have a file ``~\coding-event.json`` with the following contents:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Get-Content ~\coding-event.json

   {
      "Title": "test title is long",
      "Description": "test description goes here",
      "Date": "2020-10-31"
   }

We could use this file as the contents of the request body using a grouped expression:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Invoke-RestMethod -Method Post -Uri $uri -Body (Get-Content ~\coding-event.json) -ContentType "application/json"

.. admonition:: Tip

   You can use any of these ``-Body`` defining approaches for creating and adding bodies to ``PUT`` and ``PATCH`` requests as well. When used on a ``GET`` request the body will be converted to query string parameters in the URI.

Continue Learning
=================

``Invoke-RestMethod``, like Postman, has many additional options we can use to further configure requests. 

You can look over the documentation of `Invoke-RestMethod <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-restmethod?view=powershell-7>`_ to get an understanding of its capabilities. 

You can work with any RESTful APIs using the ``Invoke-RestMethod`` cmdlet. To continue practicing you can work with any publicly available APIs like the `GitHub Developer API <https://developer.github.com/v3/>`_.