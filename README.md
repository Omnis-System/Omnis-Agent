<a href="https://travis-ci.org/hirose31/Omnis"><img src="https://travis-ci.org/hirose31/Omnis.png?branch=master" alt="Build Status" /></a>
<a href="https://coveralls.io/r/hirose31/Omnis?branch=master"><img src="https://coveralls.io/repos/hirose31/Omnis/badge.png?branch=master" alt="Coverage Status" /></a>

# NAME

Omnis - fixme

# INSTALLATION

To install this module, run the following commands:

    perl Build.PL
    ./Build
    ./Build test
    ./Build install

# SYNOPSIS

    use Omnis;
    fixme

# DESCRIPTION

Omnis is fixme

# METHODS

## Class Methods

### __new__(%args:Hash) :Omnis

Creates and returns a new InfluxDB client instance. Dies on errors.

%args is following:

- hostname => Str ("127.0.0.1")

## Instance Methods

### __method\_name__($message:Str) :Bool

# ENVIRONMENT VARIABLES

- HOME

    Used to determine the user's home directory.

# FILES

- `/path/to/config.ph`

    設定ファイル。

# AUTHOR

HIROSE Masaaki <hirose31@gmail.com>

# REPOSITORY

[https://github.com/Omnis-System/Omnis-Agent](https://github.com/Omnis-System/Omnis-Agent)

    git clone https://github.com/Omnis-System/Omnis-Agent.git

patches and collaborators are welcome.

# SEE ALSO

[Module::Hoge](https://metacpan.org/pod/Module::Hoge),
ls(1), cd(1)

# COPYRIGHT

Copyright HIROSE Masaaki

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
