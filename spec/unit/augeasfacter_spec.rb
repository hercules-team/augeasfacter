#!/usr/bin/env rspec

require 'spec_helper'

DIR = File.expand_path(File.dirname(__FILE__))
FAKEROOT = File.join(DIR, '../fixtures/root')
FACTERLIB = File.join(DIR, '../../lib/facter')
CONFDIR = '/etc/augeasfacter'

def do_facter (conf, fact)
  `AUGEAS_ROOT="#{FAKEROOT}" FACTERLIB="#{FACTERLIB}" AUGEASFACTER_CONF="#{CONFDIR}/#{conf}" facter #{fact}`
end

describe "augeasfacter" do
  context "with empty file" do
    it "should not output anything" do
      output = do_facter('empty', 'root_shell')
      output.should == ''
    end
  end

  context "with simple value" do
    it "should return one value" do
      output = do_facter('simple_value', 'root_shell')
      output.chomp.should == '/bin/bash'
    end
  end

  context "with simple label" do
    it "should return one value" do
      output = do_facter('simple_label', 'uid_0')
      output.chomp.should == 'root'
    end
  end

  context "with multiple label" do
    it "should return several values" do
      output = do_facter('multiple_label', 'users')
      output.chomp.should == 'root:daemon:bin:sys:sync:games:man:lp:mail:news:uucp:proxy:www-data:backup:list:irc:gnats:nobody:libuuid:syslog:messagebus:colord:lightdm:avahi-autoipd:avahi:usbmux:kernoops:pulse:rtkit:saned:whoopsie:speech-dispatcher:hplip:sshd:guest-7Oz932:Debian-exim:ntp'
    end
  end
end
