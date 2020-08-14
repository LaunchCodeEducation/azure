Networking
==========

In this class we will cover the basics of networking. Networking is an important and vast concept. Networking quickly gets complicated when you move beyond the basics. We will only cover the basics in this class, however you will continue learning about networking throughout your career.

.. index:: ! networking

**Networking** is the process of connecting machines together to communicate information.

Networking refers to both private networks (home network, office network), and public networks (the Internet, a university/organization intranet).

There are two types of networks:

- Private Intranets
- Public Internet

.. index:: intranet

**Intranets** are private networks that range from local networks, like the one in your home, to larger corporate networks that span multiple locations. Modern intranets also include private virtual networks that can be provisioned and managed from CSPs like Azure. The Internet is a public, world-wide network that connects machines across homes, companies, and governments.

IP Addresses
------------

.. index:: ! IP address

An **Internet protocol address (IP address)** is a unique identifier that identifies each computer or device connected to a network. All IP Addresses follow a specific numeric pattern. 

The pattern of an IP address always follows ``xxx.xxx.xxx.xxx`` where the 'x's can be replaced by integers between 0 and 255.

Examples of valid IP addresses: 

- ``192.168.0.1``
- ``127.0.0.1``
- ``255.255.255.255``
- ``47.120.14.1``

.. admonition:: Note

   For the purposes of this class, we will only work with IPv4 addresses. It should be noted that a new format for IP addresses (IPv6) is also used, but goes beyond the scope of this class. Everything you learn about IPv4 addresses can be applied directly to IPv6 addresses with the exception of the numbering pattern.

.. index:: loopback

You have already worked with one special IP address, the **loopback** IP Address. The loopback IP Address is ``127.0.0.1``. When requests are made to this address the request is sent back to the machine that made the request. We have done this throughout the class when running our C# .NET web applications---to access the web app we would make a request to 127.0.0.1 in our browser.

.. admonition:: Fun Fact

   The loopback interface was designed specifically for developers to simulate networking from within a single host machine. The IP address ``127.0.0.1``, or home IP, is mapped to the aptly named host ``localhost``, which you have undoubtedly used many times!

Local Area Network
------------------

.. index:: ! local area network

A **Local Area Network** (LAN) is a private network that connects all the computers/devices in a relatively small geographic location. You probably have a LAN in your place of residence. It may connect your computer, your smart phone, your printer, and anyone else in your house together on one network. Using the LAN, you can send a print job from your computer to your printer and it may respond by printing the sent documents. Using your LAN, you can access a shared hard drive, or move files between different devices.

Examples of places that may have a LAN:

- Office
- Hotel
- Convention center
- Restaurant

.. admonition:: Note

   A LAN may have access to the Internet, but only if the LAN has been explicitly connected to the public Internet.

Private IP Addresses
^^^^^^^^^^^^^^^^^^^^

.. index::
   single: IP address, private

A **private IP address** is an IP Address that identifies a device within a LAN.

Consider the LAN in a home. Any computer or device connects to the LAN by communicating with a router. The router is responsible for providing private IP addresses to each computer or device. The LAN gives each computer or device the ability to communicate with each other, however the LAN does not have access to the Internet yet. The router must be connected to the Internet via an Internet services provider (ISP). The ISP assigns one public IP address to your router. This address is then used when any computer or device makes a request to the Internet.

Wide Area Network
-----------------

.. index:: ! wide area network

A **wide area network** (WAN) is a private network, or collection of connected private networks, that connect computers and devices across a large geographic area. Just like a LAN, a WAN doles out a unique private IP address to every device on the network.

One major difference between a WAN and a LAN is that a WAN commonly uses public infrastructure to establish a connection between two or more private LANs. This is how the WAN can cover such a large geographic area.

Examples of places that may have a WAN:

- City
- Public transit
- Organization with multiple office buildings
- State
- Country

Internet
--------

.. index:: ! Internet

The **Internet** is a collection of inter-connected public networks. You can think of the Internet as a very large, publicly accessible WAN.

.. index:: ! Internet service provider

To access the Internet you must go through an **Internet service provider (ISP)**, which is an organization that controls a network that is already configured as one of the networks on the Internet. Your ISP will provide you with an IP address on their network, which has access to the greater Internet.

Once you have been assigned a public IP address from your ISP you can access other computers, or servers, on the Internet. For example, to view the curriculum of this class you opened a web browser and navigated to ``education.launchcode.org``. Your browser used the public IP address that was assigned to your LAN and accessed the public Internet through the network established by the ISP. Once the request your browser makes gets to the public Internet, the URL ``education.launchcode.org`` can be resolved to an IP address where the website resources are located. Those resources are then sent back to your browser where they are rendered.

Public IP Addresses
^^^^^^^^^^^^^^^^^^^

.. index:: ! public IP address

A **public IP address** is an IP address that uniquely identifies end-users and servers on the greater Internet. End-users are the consumers, or people that access the Internet. Servers refer to the machines that host websites, web applications, and services. Both the end users and these machines need to have unique IP addresses.

You are given a public IP address by your ISP when you connect to the Internet through their network. Every time you make a request to a website, web app, or service, your public IP address is sent with the request so that the website, web app, or service knows where to send the response.

.. admonition:: Note

   Even though every machine on the Internet has an IP address, not every machine or network is configured to be accessed via the Internet. Your LAN has a public IP address, but is not configured to be accessed by end users of the Internet. 
   
   If someone else makes a request to your public IP address, it will be denied by your router, and no response will be sent. This is true for all machines on the Internet. They must first be configured to allow traffic through before websites, web apps, or services can be accessed.

Additionally, every website, web app, or service on the Internet is hosted on a machine and each machine has a public IP address. When you want to access the website, web app, or service you must make a request to their machine's public IP address. To simplify this process we typically use a domain name instead of a public IP address.

.. index:: ! domain name system

A **domain name system (DNS)** is a naming system for IP addresses, and domain names. 

A DNS is similar to a phone book. A phone book maps a telephone number to one person or business. Similarly, a DNS maps an IP address to one device on the Internet. 

As an example, in your web browser you may enter ``google.com``. Your computer then uses a DNS to resolve it to an IP Address like ``88.31.122.3``. This address is then used to make the request to the specific machine where the web page or data is hosted. 

.. admonition:: Note

   When accessing the Internet through an ISP, usually your entire private LAN is given one public IP address. This is why an ISP knows which household, or business, made a specific request, but cannot pinpoint it to one specific user on the LAN. To figure out which specific user made a specific request, they would need information from the ISP, and additional information from the LAN.
