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
        cmdline_src => 'stdin_or_file',
        tags    => ['common'],
    },
    enable_expr => {
        schema  => 'bool',
        default => 0,
        cmdline_aliases => {e=>{}},
        tags    => ['common'],
    },
    allow_encodings => {
        'x.name.is_plural' => 1,
        'x.name.singular' => 'allow_encoding',
        schema  => ['array*', of=>'str*'],
        tags    => ['common'],
    },
    disallow_encodings => {
        'x.name.is_plural' => 1,
        'x.name.singular' => 'disallow_encoding',
        schema  => ['array*', of=>'str*'],
        tags    => ['common'],
    },
    ignore_unknown_directive => {
        schema  => 'bool',
        default => 0,
        tags    => ['common'],
    },
);

our %inplace_arg = (
    inplace => {
        summary => 'Modify file in-place',
        schema => ['bool', is=>1],
        description => <<'_',

Note that this can only be done if you specify an actual file and not STDIN.
Otherwise, an error will be thrown.

_
    },
);

sub _check_inplace {
    my $args = shift;
    if ($args->{inplace}) {
        die [412, "To use in-place editing, please supply an actual file"]
            if @{ $args->{-cmdline_srcfilenames_iod} // []} == 0;
        die [412, "To use in-place editing, please supply only one file"]
            if @{ $args->{-cmdline_srcfilenames_iod} // []} > 1;
    }
}

sub _return_mod_result {
    my ($args, $doc) = @_;

    if ($args->{inplace}) {
        require File::Slurper;
        File::Slurper::write_text(
            $args->{-cmdline_srcfilenames_iod}[0], $doc->as_string);
        [200, "OK"];
    } else {
        [200, "OK", $doc->as_string, {'cmdline.skip_format'=>1}];
    }
}

sub _get_parser {
    require Config::IOD;

    my $args = shift;
    Config::IOD->new(
        enable_expr=>$args->{enable_expr},
        ignore_unknown_directive=>$args->{ignore_unknown_directive},
        (allow_encodings    => $args->{allow_encodings})    x !!@{ $args->{allow_encodings}    // [] },
        (disallow_encodings => $args->{disallow_encodings}) x !!@{ $args->{disallow_encodings} // [] },
    );
}

sub _get_reader {
    require Config::IOD::Reader;

    my $args = shift;
    Config::IOD::Reader->new(
        enable_expr=>$args->{enable_expr},
        ignore_unknown_directive=>$args->{ignore_unknown_directive},
        (allow_encodings    => $args->{allow_encodings})    x !!@{ $args->{allow_encodings}    // [] },
        (disallow_encodings => $args->{disallow_encodings}) x !!@{ $args->{disallow_encodings} // [] },
    );
}

1;
# ABSTRACT: IOD utilities

=head1 SYNOPSIS

This distribution provides the following command-line utilities:

#INSERT_EXECS_LIST

The main feature of these utilities is tab completion.


=head1 SEE ALSO

#INSERT_BLOCK: App::PMUtils see_also

=cut
