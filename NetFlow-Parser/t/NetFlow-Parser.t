use strict;
use warnings;
use English qw(-no_match_vars) ;
use Test::More tests => 31;
use Test::Exception;
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

# Test exception thrown by parse method
throws_ok { NetFlow::Parser->parse() } 'SPM::X::BadValue', "NetFlow::Parser->parse throws SPM::X::BadValue when missing parameter";

# Test parse method with binary data
SKIP: {
    eval 'use Text::CSV';
    my $Csv_Parser;
    my $Skip_Parse_Tests = 0;
    unless ($EVAL_ERROR) {
        $Csv_Parser = Text::CSV->new( { binary => 1 } ) or
            $Skip_Parse_Tests = 1;
    }

    skip "Text::CSV module required for testing NetFlow::Parser->parse method", 7 if $EVAL_ERROR || $Skip_Parse_Tests;
    my ($Packet_Data, $Test_Type, $Test_Description);
    TEST:
    while (my $line = <DATA>) {
        chomp $line;
        if ($line =~ /^#/) {
            next TEST;
        }
        $Csv_Parser->parse($line);
        ($Packet_Data, $Test_Type, $Test_Description) = $Csv_Parser->fields();
        if (!defined $Packet_Data) {
            fail("Text::CSV->parse method failed: " . Csv_Parser->error_input());
            next TEST;
        }
        $Packet_Data = pack('H*', $Packet_Data);
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
}
my $Packet_Data = pack('H*', "00020001cba6a0d851074503145d3578001944872a2a0000c0a80171c0a8010100000000000000000000000100000040cba5d1d0cba5e94083f00035000011000000000000000000");
throws_ok { $Parser->parse($Packet_Data) } 'SPM::X::BadValue', 'NetFlow::Parser->parse throws SPM::X::BadValue with invalid Netflow version';


$Packet_Data = pack('H*', "00050001cba6a0d851074503145d3578001944872a2a0000c0a80171c0a80000000000000000000000");
throws_ok { $Parser->parse($Packet_Data) } 'SPM::X::BadValue', 'NetFlow::Parser->parse throws SPM::X::BadValue with invalid flow lenght';

__DATA__
#HEX_DATA,TYPE,DESCRIPTION
#XXXX,LIVES,LIVES OK EXAMPLE
#ZZZZ,DIES,DIES OK EXAMPLE
00050001cba6a0d851074503145d3578001944872a2a0000c0a80171c0a8010100000000000000000000000100000040cba5d1d0cba5e94083f00035000011000000000000000000,LIVES,Netflow::Parser->parse() lives with single flow
00050002cba6a0d851074503145d3578001944872a2a0000c0a80171c0a8010100000000000000000000000100000040cba5d1d0cba5e94083f00035000011000000000000000000c0a80101c0a801710000000000000000000000010000017bcba5d1d0cba5e940003583f0000011000000000000000000,LIVES,Netflow::Parser->parse() lives with two flows
00050001cba6a0d851074503145d3578001944872a2a0000c0a80171c0a8010100000000000000000000000100000040cba5d1d0cba5e94083f000350000110000000000000000,DIES,Netflow::Parser->parse() dies with missing byte
00050001cba6a0d851074503145d3578001944872a2a0000c0a80171c0a8010100000000000000000000000100000040cba5d1d0cba5e94083f0003500001100000000000000000000,DIES,Netflow::Parser->parse() dies with extra byte
00020001cba6a0d851074503145d3578001944872a2a0000c0a80171c0a8010100000000000000000000000100000040cba5d1d0cba5e94083f00035000011000000000000000000,DIES,Netflow::Parser->parse() dies with Netflow version equal to 2
00050001cba6a0d851074503145d578001944872a2a00000a80171c0a80101000000000000000000000010000004cba5d1d0cba5e9483f0003500011000000000000000000,DIES,Netflow::Parser->parse() dies with invalid data
XXX,DIES,Netflow::Parser->parse() dies with bad data
