---
layout: post
title:  "Xdebug, NetBeans and Vagrant"
date:   2015-05-06
categories:
---

Hi! In this short post I'll describe the steps I've made, with the great help of a work colleague, on how to achieve the combination of these great tools together: <strong>NetBeans</strong>, <strong>Xdebug</strong> and <strong>Vagrant</strong>.

The following steps were executed in a vagrant box using Ubuntu, and with the Yosemite as the OS for the hosting machine.

### Xdebug

<div style="text-align:center"><img src ="/assets/images/2015/05/06/xdebug-logo.png" /></div>

<a href="http://xdebug.org/"><strong>Xdebug</strong></a> is one of the most amazing tools for any PHP developer. 
Consider yourself in the following situation: you have your code base, developed under some framework, and you have some few bugs while developing new features. The most common attitude would be to add some <code>echo</code> calls to find out what exactly is happening in your code. Or even some <code>var_dump</code> to output the value of some variables.

Well that's the most usual behaviour for many developers. But if you've started with any other language instead of PHP, you know how valuable is a proper debugger. That's why xdebug was created: to bring the same functionality for PHP devs.

![phpcs -i](/assets/images/2015/05/06/breakpoint.png)


### Vagrant

<div style="text-align:center"><img src ="/assets/images/2015/05/06/vagrant-logo.png" /></div>

<a href="https://www.vagrantup.com/"><strong>Vagrant</strong></a> is a tool to provide virtual environments for development, with different specifications from each other.  It's based on virtual machines inside your OS, and allow you to have flexible and portable environments.

> For this post, I'll consider that you already have an environment with Vagrant in your machine up and running.


#### Installing and Configuring Xdebug

First of all, you need to install Xdebug. From inside your vagrant box, execute the following command:

<div class="command">
    <pre><code>sudo apt-get install php5-xdebug</code></pre>
</div>

This will install the <code>xdebug.so</code> extension file inside of <code>/usr/lib/php5/20121212/</code> path.
Once the command is complete, check with <code>phpinfo()</code>to find that the extension is correctly installed.

Then, we have to proceed to edit some basic configuration files:

1. The <code>20-xdebug.ini</code> file, which is a config file for Xdebug;
2. And the <code>php.ini</code>, which is the basic config file for PHP.

You can find the <code>20-xdebug.ini</code> file inside of these paths: <code>/etc/php5/cli/conf.d/</code> and <code>/etc/php5/fpm/conf.d/</code>. If you can't find these files, then create them inside of these paths.

For both <code>20-xdebug.ini</code> files, add the following settings:

<div class="gist">
	<pre><code>zend_extension=/usr/lib/php5/20121212/xdebug.so
xdebug.default_enable=1
xdebug.remote_enable=1
xdebug.remote_connect_back=on
xdebug.remote_port=9000
xdebug.remote_autostart=0
xdebug.remote_log=/tmp/php5-xdebug.log
xdebug.idekey=netbeans-xdebug</code></pre>
</div>

These are parameters for Xdebug to work properly. Remember that the <code>netbeans-xdebug</code> value is designed to follow NetBeans instructions.

Once the <code>20-xdebug.ini</code> is created/updated, it's time to add more settings for the <code>php.ini</code> files. You may find them in the <code>/etc/php5/cli</code> and <code>/etc/php5/fpm</code> paths. For these files, add the following parameters:

<div class="gist">
    <pre><code>[xdebug]
zend_extension="/usr/lib/php5/20121212/xdebug.so"
xdebug.remote_enable=1
xdebug.remote_host=localhost
xdebug.max_nesting_level=1000</code></pre>
</div>

Now remember to restart the fpm and HTTP server services and you have the Xdebug installed successfully.

## NetBeans Settings and Tips

Now that you already have the Xdebug ready for action, it's time to configure it for your IDE. Go to Options > PHP > Debugging and add the following settings, as the image below:

![phpcs -i](/assets/images/2015/05/06/xdebug_netbeans_settings1.png)

Then, in the Project > Properties > Run Configuration > Advanced, add the following settings:

![phpcs -i](/assets/images/2015/05/06/xdebug_netbeans_settings2.png)

The <i>Server Path</i> is the path inside your vagrant box where the project is located, and the <i>Project Path</i> is the path for your project outside of the vagrant box. NetBeans need this configuration in order to recognize where the project is. These settings should be made for each project.

Once all these steps are done, you can easily debug your PHP projects on NetBeans through your Vagrant boxes.

