=================
Processes & Ports
=================

As a final precursor to web hosting we need to learn a little about computer processes and the ports they are bound to.

Server Processes
================

.. index:: ! process

A computer **process** is an actively running instance of a program. Every time you launch an application on your computer, the operating system creates at least one process that runs the entire time the application is open. 

When you run your code, similarly, the operating system creates at least one process for your application code. The process will stay alive until the application stops running. Anytime an application is open, running, or idling in the background, the operating system has at least one process running that is managing the application's access to the operating system and hardware.

.. index:: ! process ID

A process will always have a process ID (PID), along with some information about which application the process is associated with. This varies between OS, and is sometimes a path to the program using the process, or the name of the program. The PID can be used to *identify* a specific process.

You can view running processes on a Windows machine by opening the Windows Task Manager. You can view the running processes on a UNIX based machine by running ``top`` or ``ps`` in a terminal.

.. admonition:: Note

   If you viewed the running processes, you probably noticed there are quite a few processes running in the background of your computer that don't correspond to applications you have started. 
   
   Consider that every facet of your computer needs at least one constantly running process to work correctly, because there is some underlying code that needs to be run in order to interface with all of the things built into your computer. Examples include physical devices like your monitor, camera, microphone, keyboard, mouse, and wifi card, which all need some code in order to function properly. Also your operating system comes with lots of software to make your life easier, such as a clock, calendar, GUI tools, etc. All of these things and more require lots of processes to be running in the background so that your computer behaves in a way that you can use it.

In this class, we won't pay much attention to our application processes because the processes are managed for us by the operating system. However, it is important to know the basics of what is going on behind the scenes for when you may need to troubleshoot in the future.

Ports
=====

.. index:: ! port, SSH

A **port** is simply a communication endpoint. In networking, and this class, a port is a way to determine which specific application to access on a remote computer. For example, if you want to access a bash terminal on a linux server you must provide the IP address of the linux server along with the port number that is currently listening for bash terminal requests. By default, the secure shell (SSH) port is 22. Therefore, you would need to make a request to: ``192.168.0.9:22`` to access this application. This requires that you know two things in order to gain access to a specific application: the IP address of the remote server and the port number of running process.

A good analogy is that of parking a boat at a busy marina with a collection of slips. You first have to find the marina (IP address), and then you have to navigate to your specifically assigned slip (port). Finally, you can park your boat in your reserved space.

Consider a remote computer running a web server. You need to access this web server to view a website, or use a web application. You must provide the IP address of the machine, along with the port the web server process is currently running on. By default, HTTP uses port 80 and HTTPS uses port 443. So to access the web server on a remote machine you would need to enter ``192.168.0.89:80`` to access the web server running on port 80.

When you make the request to ``192.168.0.89:80`` your computer sends the request to the router, and then the router sends the request to the remote server that has been assigned the IP address ``192.168.0.89``. When the remote server receives the request, it sends the request to the process that is bound to port ``80``, which is the running web server.

.. admonition:: Note

   Both ports 80 and 443 are reserved ports for web applications using HTTP or HTTPS. Since this is a widely adopted standard, browsers automatically append ``:80``, or ``:443`` to the requests you make in your browser, which is why you don't see them reflected in the URL. 
   
   This also explains why when we run a web application on our local machines we must make a request to ``127.0.0.1:8080`` or some other port. Since port 80 is reserved for web traffic, we run our application on a different port while we are developing, and access it through our browser by manually setting the port. ``127.0.0.1`` is a reserved IP address that is the loopback to your own machine, so when you make the request your router sends it back to the machine that made the request.
