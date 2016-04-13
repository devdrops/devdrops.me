---
layout: post
title:  "Vagrant and Blackfire"
date:   2016-04-13
categories:
---

In this short post, I'll share the basics I've learned a couple weeks ago on how to profile your application using [Blackfire](https://blackfire.io/), a powerful profiling tool created by SensioLabs, inside your Vagrant boxes. With this post, you'll be able to start profiling and improving your apps with the ease provided by Vagrant to carry your environment whethever you go ;).

### Requirements

For this post, I'll consider that you already have:

* A Vagrant setup complete on your machine;
* A basic understanding on how to create Vagrant boxes;
* Ansible as the provisioner;
* An account created on Blackfire (if you don't, just [create your own](https://blackfire.io/signup) before start).

### Getting Started





# Vagrant and Blackfire

* Provisioning your Vagrant box with Ansible:
	* Create box
	* Use Ansible Galaxy to install Blackfire
	* Use basic shell to install Blackfire
	* Other ways?
* Check if Blackfire is correctly installed in your Vagrant box
	* Add any required configuration
* Provide an PHP application
* Profile your app with Blackfire
