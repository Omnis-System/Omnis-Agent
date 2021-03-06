# -*- mode: cperl -*-

requires 'perl', '5.010';

# fixme
requires 'Amon2', '6.02';
requires 'DBD::SQLite', '1.33';
requires 'HTML::FillInForm::Lite', '1.11';
requires 'HTTP::Session2', '0.04';
requires 'JSON', '2.50';
requires 'Module::Functions', '2';
requires 'Plack::Middleware::ReverseProxy', '0.09';
requires 'Router::Boom', '0.06';
requires 'Starlet', '0.20';
requires 'Teng', '0.18';
requires 'Test::WWW::Mechanize::PSGI';
requires 'Text::Xslate', '2.0009';
requires 'Time::Piece', '1.20';

requires 'Data::Validator', '1.03';
requires 'Log::Minimal';
requires 'Proclet';
requires 'IO::File::AtomicChange';
requires 'IPC::Cmd';
requires 'IPC::Run';
requires 'Parse::Daemontools::Service', '0.03';
requires 'Parallel::Scoreboard', '0.04';

on configure => sub {
    requires 'Module::Build::Tiny', '0.030';
};

on develop => sub {
    requires 'App::scan_prereqs_cpanfile', '0.09';
    requires 'Pod::Wordlist';
    requires 'Test::Fixme';
    requires 'Test::Kwalitee';
    requires 'Test::Spelling', '0.12';
};

on test => sub {
    requires 'Test::More', '0.88';
};
