use strict;
use warnings;
use Test::More;
use Test::Exception;
use Text::CSV;
BEGIN { use_ok('NetFlow::Parser') };

my $Module = "NetFlow::Parser";

# Module can run these methods.
can_ok($Module, 'new');
can_ok($Module, 'debug');
can_ok($Module, 'parse');

# Test consturctor with valid input.
new_ok($Module => [ ]);
new_ok($Module => [ debug => 1 ]);
my $Parser = $Module->new();
isa_ok($Parser, $Module);

# Test constructor with invalid parmateters
dies_ok { NetFlow::Parser->new({ debug => 'a'}) } "NetFlow::Parser->new dies, debug parameter is not numeric";
dies_ok { NetFlow::Parser->new({ debug => 1.1}) } "NetFlow::Parser->new dies, debug parameter is 1.1";
dies_ok { NetFlow::Parser->new({ debug => ""})  } "NetFlow::Parser->new dies, debug parameter is empty string";

# Accessor methods live.
lives_ok { $Parser->debug() } 'NetFlow::Parser->debug accessor lives';

# Accessor methods return correct value.
cmp_ok ( $Parser->debug(), '==', 0, 'NetFlow::Parser->debug accessor returns correct value' );

# Test parse method with non-binary data
dies_ok { NetFlow::Parser->parse()    } "NetFlow::Parser->parse dies, no parameter";
dies_ok { NetFlow::Parser->parse("")  } "NetFlow::Parser->parse dies, empty string parameter";
dies_ok { NetFlow::Parser->parse("a") } "NetFlow::Parser->parse dies, string parameter";
dies_ok { NetFlow::Parser->parse(1)   } "NetFlow::Parser->parse dies, integer parameter";
dies_ok { NetFlow::Parser->parse(1.1) } "NetFlow::Parser->parse dies, float parameter";
dies_ok { NetFlow::Parser->parse([])  } "NetFlow::Parser->parse dies, array reference parameter";
dies_ok { NetFlow::Parser->parse({})  } "NetFlow::Parser->parse dies, hash reference parameter";

# TODO: Test parse method with binary data
my ($Packet_Data, $Test_Type, $Test_Description);
my $Csv_Parser = Text::CSV->new( { binary => 1 } );   # TODO: handle error if constructor fails
LINE:
while (my $line = <DATA>) {
    chomp $line;
    if ($line =~ /^#/) {
        next LINE;
    }
    $Csv_Parser->parse($line);    # TODO: handle parse method failure
    ($Packet_Data, $Test_Type, $Test_Description) = $Csv_Parser->fields();
    #diag("Packet_Data = $Packet_Data");
    # TODO: run pack() on $Packet_Data  (what if pack() fails?)
    if ($Test_Type eq 'DIES') {
        dies_ok { $Parser->parse($Packet_Data) } $Test_Description;
    } elsif ($Test_Type eq 'LIVES') {
        lives_ok { $Parser->parse($Packet_Data) } $Test_Description;
        isa_ok($Parser->parse($Packet_Data), 'NetFlow::Packet');
    } else {
        diag("Invalid test type '$Test_Type'");
        fail($Test_Description);
    }
}
done_testing();

__DATA__
#DATA,TYPE,DESCRIPTION
#XXXX,LIVES,LIVES OK
#ZZZZ,DIES,DIES OK
#XXXX,DIES,Test Test Test
