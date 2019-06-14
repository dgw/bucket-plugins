# BUCKET PLUGIN

use BucketBase qw/config Log post say/;
use Config::Tiny;

our $prefix = '';

sub signals {
    return (qw/on_public/)
}

sub settings {
    return ();
}

sub commands {
    return (
        {
            label     => 'quote add',
            addressed => 1,
            operator  => 0,
            editable  => 0,
            re        => qr/^quote add (.+)$/i,
            callback  => \&quote_add
        },
    );
}

sub route {
    my ( $package, $sig, $data ) = @_;

    return 0;
}

sub quote_add {
    my $bag = shift;

    my $quote = $1;
    $quote =~ s/\$/\\\$/g;  # cleanup stolen from quote plugin

    my @lines = split /\s+(?=\<.+?\>|\* )/, $quote;

    return &say( $bag->{chl} => "Sorry, I couldn't parse that quote." )
        unless $lines[-1] =~ /^(?:\<(.+?)\>|\* (\w+))/;
    my $user = $1 || $2;

    return &say( $bag->{chl} => "Please don't quote yourself, $bag->{who}." ) if ( lc $user eq lc $bag->{who} );

    &Log("Remembering '$user quotes' '<reply>' '$quote'");
    &post(
        db  => 'SINGLE',
        SQL => 'select id, tidbit from bucket_facts 
                where fact = ? and verb = "<alias>"',
        PLACEHOLDERS => ["$user quotes"],
        BAGGAGE      => {
            %$bag,
            msg       => "$user quotes <reply> $quote",
            orig      => "$user quotes <reply> $quote",
            addressed => 1,
            fact      => "$user quotes",
            verb      => "<reply>",
            tidbit    => $quote,
            cmd       => "unalias",
            ack       => "Okay, $bag->{who}, adding \"$quote\".",
        },
        EVENT => 'db_success'
    );
}
