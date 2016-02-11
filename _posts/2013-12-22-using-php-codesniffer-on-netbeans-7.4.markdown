---
layout: post
title:  "Using PHP_CodeSniffer on NetBeans 7.4"
date:   2013-12-22
categories:
---

In this first post, I'll share my basic experience in how to use an important tool to assure and verify your code quality.

Special thanks to *Tomas Mysik* and *Adam McAuley* for their efforts on [Bugzilla](https://netbeans.org/bugzilla/) and the NetBeans PHP Mailing List, which helped me a lot on how to use these combined tools, and then create this tutorial.

## Requirements

* PHP >= 5.3
* [NetBeans 7.4](https://netbeans.org/downloads/)
* [PEAR](http://pear.php.net/)


**Note:** I'm assuming you already have an HTTP Server (like Apache) installed and ready for action.

#### 1) PHP_CodeSniffer
It's a powerfull tool to verify if your code attends to a specific set of rules, contained on a *standard*. It can also be used thought prompt or command line.

To install this tool, we'll use _Composer_, the modern package manager for PHP tools and projects. I'll consider that you already have Composer installed and ready for action, so fire up your terminal (DOS on Windows) and execute the command below:

<div class="livecodeserver">
<pre><code>composer global require "squizlabs/php_codesniffer=*"</code></pre>
</div>

> Tip: the directive global will provide the installed tool for all environments. Just remember to check that you have the _~/.composer/vendor/bin/_ in your _PATH_, on Windows by checking the environment variables.

To finally check, run <code>phpcs -i</code>, where the directive <code>-i</code> asks for PHP_CodeSniffer to show alll the standards installed on your machine. You should see this message as a confirmation, as the same command on a Linux environment:

![phpcs -i](/assets/images/2013/12/22/phpcs_standards.png)


#### 2) Setting things up on NetBeans

Once you've installed PHP CodeSniffer successfully, you'll need to inform the path of your phpcs file (in Windows, *phpcs.bat*) to allow NetBeans to use  PHP CodeSniffer.

Go to *Tools > Options > PHP > Code Sniffer*. Look for the *Code Sniffer* field, and then click on the *Search...* button at the right of the field. This will make NetBeans find a list of installed versions of phpcs file on your computer.
Select the phpcs file (located at your PEAR root's installation folder), and then CodeSniffer is configured and ready for action.

> Tip: As soon the phpcs file is correctly configured on NetBeans, you'll see a command line in an output window on NetBeans performing `phpcs -i`, listing all the standards, as mentioned above.
	![netbeans-detail](/assets/images/2013/12/22/netbeans_phpcs_confirmation.png)

#### 3) How to use it on NetBeans

Simple and easy. On the top menu, go for *Source > Inspect...*. The following window show you the basic settings before perform the inspection:

![netbeans-inspect](/assets/images/2013/12/22/netbeans_inspect_window.png)

* **Scope** suggests *where* you'd like to perform the inspection: in a project, all your projects, or even in a single file.

* **Configuration > All Analyzers** allow you to select which tool you would like to use in  the inspection: CodeSniffer, Mess Detector, both, or a customized profile.

Once you have selected all your preferences, click on the *Inspect* button to start the inspection. It may take some time, so I suggest you to open a window and have some fresh air ;-)

> Tip: if you want to change the scope before adjust the settings, select a file or a project in the *Projects* window before you go to *Source > Inspect...* . 

NetBeans will then output a list of matchings according to which standards you've used to perform the inspection, as the image above (a dog icons indicates a CodeSniffer match, and a garbage can points to a MessDetector match). Then, apply all your methods to fix these matchings to assure that your code is 100% according to the standards, as you wish.

![netbeans-result](/assets/images/2013/12/22/phpcs_netbeans_analysis.png)
