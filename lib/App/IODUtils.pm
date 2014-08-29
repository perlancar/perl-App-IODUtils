package App::IODUtils;

# VERSION
# DATE

use 5.010001;

our %common_args = (
    iod => {
        summary => 'IOD file',
        schema  => ['str*'],
        req     => 1,
        pos     => 0,
        cmdline_src => 'stdin_or_files',
    },
    enable_expr => {
        schema  => 'bool',
        default => 0,
        cmdline_aliases => {e=>{}},
    },
);

1;
# ABSTRACT: IOD utilities

=head1 SYNOPSIS

This distribution provides the following command-line utilities:

 dump-iod
 get-iod-key
 get-iod-section
 list-iod-sections


