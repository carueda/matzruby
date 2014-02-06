This is a fork of https://github.com/brentr/matzruby ('esp' branch) with minor
adjustments (in espconfig and espinstall) to facilitate the build/installation
of ruby and the MBARI extensions, without needing root permissions, eg., to
install under a regular user directory.

*Note*: the default behavior of these scripts is unchanged. Customization is
done via the ESP_PREFIX and ESP_SUDO environment variables.

```shell
    $ git clone https://github.com/carueda/matzruby.git
    $ cd matzruby
    $ git checkout -b esp remotes/origin/esp
```

Say you want to build and install under `/home/carueda/opt/mbari`:

```shell
    $ PATH=.:$PATH
    $ ESP_PREFIX=/home/carueda/opt/mbari espconfig
    ...
    creating config.h
    configure: creating ./config.status
    config.status: creating Makefile

    $ ESP_SUDO= espinstall
    ...
    Installing MBARI extensions...
    /home/carueda/opt/mbari/lib/ruby/site_ruby/1.8/x86_64-linux
    /home/carueda/opt/mbari/lib/ruby/site_ruby/1.8
```

Quick test:

```shell
    $ PATH=/home/carueda/opt/mbari/bin/:$PATH
    $ ruby --version
    ruby 1.8.7 (2013-8-5 MBARI8esp7/0x6770 on patchlevel 352) [x86_64-linux]

    $ irb
    irb(main):001:0> require 'mbari'
    => true
    irb(main):002:0> require 'termios'
    => true
```
