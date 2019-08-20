# BUCKET PLUGIN

# Inspired by a request (of sorts) on IRC:
# <flameboi> "but fuck" in messages should be replaced by "butt fuck" like
#            with ex* and sex*

use BucketBase qw/say config talking/;

sub signals {
    return (qw/on_public/);
}

sub settings {
    return (
        butfuck_chance => [ p => 15 ],
    );
}

sub route {
    my ( $package, $sig, $data ) = @_;

    if (    $data->{msg} =~ /\bbut fuck(?:\b|$)/i
        and rand(100) < &config("butfuck_chance")
        and &talking( $data->{chl} ) == -1 )
    {
        my $doctored = $data->{msg};
        $doctored =~ s/(but) fuck/$1t fuck/i;
        &say( $data->{chl} => $doctored );

        # don't process any further
        return 1;
    }

    return 0;
}
