Networking
==========

In this class we will cover the basics of networking. Networking is an important and vast concept. Networking quickly gets complicated when you move beyond the basics. We will only cover the basics in this class, however you will continue learning about networking throughout your career.

**Networking** is the process of connecting machines together to communicate information.

Networking refers to both private networks (home network, office network), and public networks (the internet, a university/organization intranet).

There are two types of networks:

- Private Intranets
- Public Internet

Intranets are private networks that range from local networks like in your home to wider corporate networks that span multiple locations. Modern intranets also include private virtual networks that can be provisioned and managed from CSPs like Azure. The internet is a public world-wide network that interconnects machines across homes, companies and governments.

IP Addresses
------------

An **Internet Protocol Address** (IP address) is the unique identification of each comptuer/device connected to a network. All IP Addresses follow a specific numerical pattern. 

The pattern of an IP address always follows ``xxx.xxx.xxx.xxx`` where the 'x's can be replaced by integers between 0 and 255.

Examples of valid IP addresses: 

- ``192.168.0.1``
- ``127.0.0.1``
- ``255.255.255.255``
- ``47.120.14.1``

.. admonition:: Note

   For the purposes of this class we will only work with IPv4 addresses. It should be noted that a new format for IP addresses (IPv6) is also used, but goes beyond the scope of this class. Everything you learn about IPv4 addresses in this class can be applied directly to IPv6 addresses with the exception of the numbering pattern.

You have already worked with one special IP address the **loopback** IP Address. The loopback IP Address is represented as ``127.0.0.1`` and when requests are made to this address the request is sent back to the machine that made the request. We have done this throughout the class when running our C#.NET web applications, and to access the web app we would make a request to 127.0.0.1 in our browser.

.. admonition:: Fun Fact

   The Loopback Interface was designed specifically for developers to simulate networking from within a single host machine. The IP address ``127.0.0.1`` or *home IP* is mapped to the aptly named host name ``localhost`` which you have undoubtedly used many times!

Local Area Network
------------------

A **Local Area Network** (LAN) is a private network that connects all the computers/devices in a relatively small geographic location. You probably have a LAN in your place of residence, it may connect your computer, your smart phone, your printer, and anyone else in your house together on one network. Using the LAN you can send a print job from your computer to your printer and it may respond by printing the sent documents. Using your LAN you can access a shared hard drive, or move files between different devices.

Examples of places that may have a LAN:

- office
- hotel
- convention center
- restaurant

.. admonition:: Note

   A LAN may have access to the internet, but only if internet access has been configured into the LAN.

Private IP Addresses
^^^^^^^^^^^^^^^^^^^^

A **private IP address** is an IP Address that identifies a device within a LAN.

Consider the LAN in a home. Any computer or device connects to the LAN by communicating with a router. The router is responsbile for providing private IP addresses to each computer or device. The LAN gives each computer or device the ability to communicate with each other, however the LAN does not have access to the internet yet. The router must be connected to the internet via an Internet Services Provider (ISP). The ISP delegates one public IP address to your router which is used when any computer or device makes a request to the internet.


Wide Area Network
-----------------

A **Wide Area Network** (WAN) is a private network, or collection of connected private networks, that connect computers and devices in a large geographic location. Just like a LAN it doles out a unique private IP address to every device on the WAN.

One major difference between a WAN, and a LAN is that a WAN commonly uses public infrastructure to establish a connection between two or more private LANs. This is how the WAN can cover such a large geographic area.

Examples of places that may have a WAN:

- city
- public transict like a Metro
- organization with multiple office buildings
- state
- country



Internet
--------

The **internet** is a collection of inter-connected public networks. You can think of the internet as a very large publicly accesible WAN.

To access the internet you must go through an **Internet Service Provider (ISP)** an organization that controls a network that is already configured as one of the networks on the internet. Your ISP will provide you with an IP address on their network, that has access to the greater internet.

Once you have been delgated a public IP address from your ISP you can access other computers, or servers on the greater internet. For example to view the curriculum of this class you opened a web browser and navigated to ``education.launchcode.org``. Your browser uses the public IP address that was assigned to your LAN and accesses the public internet through the network established by the ISP. Once the request your browser makes gets to the public internet the URL ``education.launchcode.org`` can be resolved to an IP address where the website resources are located, and the resources are sent back to your browser where they are rendered.

Public IP Addresses
^^^^^^^^^^^^^^^^^^^

A **public IP address** is an IP Address that uniquely identifies end-users and servers on the greater internet. End-users are the consumers, or people that access the internet. Servers refer to the machines that host websites, web applications, and services. Both the end users and these machines need to have unqiue IP addresses.

You are given a public IP address by your ISP when you connect to the internet through one. Every time you make a request to a website, web app, or service your public IP address is sent with the request so the website, web app, or service know where to send their response.

.. admonition:: Note

   Even though every machine on the internet has an IP address, not every machine or network is configured to be accessed via the internet. Your LAN has a public IP address, but is not configured to be accessed by end users of the internet. If someone else makes a request to your public IP address it will be shut down by your router, and no payload will be sent back to whoever made the request. This is true for all machines on the internet. They must first be configured to allow traffic through before websites, web apps, or services can be accessed through the internet.

Additionally, every website, web app, or service on the internet is hosted on a a machine and each machine has a public IP address. When you want to access the website, web app, or service you must make a request to their machine's public IP address. To simplfy this process we typically use a domain name instead of a public IP address.

A **Domain Name System** is a naming system for IP addresses, and domain names. 

It's similar to a phone book. Wherein a telephone number (IP Address), is registered to one person, or business (Domain Name). 

As an example in your web browser you may enter ``google.com`` which gets sent to a DNS that resolves it to some IP Address like ``88.31.122.3`` which gives you access to the webpage, or web app on the server at that IP address.

.. admonition:: Note

   When accessing the internet through an ISP usually your entire private LAN is given one public IP address. This is why an ISP knows which household, or business made a specific request, but cannot pinpoint it to one specific user on the LAN. To figure out which specific user made a specific request, they would need information from the ISP, and additional information from the LAN
