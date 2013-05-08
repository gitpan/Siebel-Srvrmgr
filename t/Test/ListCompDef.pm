package Test::ListCompDef;

use Test::Most;
use Test::Moose 'has_attribute_ok';
use base 'Test::Class';

sub class { 'Siebel::Srvrmgr::ListParser::Output::ListCompDef' }

sub startup : Tests(startup => 1) {

    my $test = shift;
    use_ok $test->class;
}

sub constructor : Tests(7) {

    my $test  = shift;
    my $class = $test->class;

    can_ok( $class, 'new' );

    #extended method tests
    can_ok( $class, qw(parse get_comp_defs set_comp_defs) );

    my @data = <Test::ListCompDef::DATA>;
    close(Test::ListCompDef::DATA);

    ok(
        my $comps = $class->new(
            {
                data_type => 'list_comp_def',
                raw_data  => \@data,
                cmd_line  => 'list comp def Foo'
            }
        ),
        '... and the constructor should succeed'
    );

	has_attribute_ok($comps, 'comp_defs');

    isa_ok( $comps, $class, '... and the object it returns' );
    is(
        $comps->get_fields_pattern(),
        'A78A78A33A33A63A118A78A33A25',
        'fields_patterns is correct'
    );

    my $default_comp_defs = [
        qw(CC_NAME CT_NAME CC_RUNMODE CC_ALIAS CC_DISP_ENABLE_ST CC_DESC_TEXT CG_NAME CG_ALIAS CC_INCARN_NO)
    ];

    is_deeply( $comps->get_comp_defs(), $default_comp_defs,
        'get_fields_pattern returns a correct set of attributes' );

}

1;

__DATA__
CC_NAME                                                                       CT_NAME                                                                       CC_RUNMODE                       CC_ALIAS                         CC_DISP_ENABLE_ST                                              CC_DESC_TEXT                                                                                                                                                                                                                                                 CG_NAME                                                                       CG_ALIAS                         CC_INCARN_NO             
----------------------------------------------------------------------------  ----------------------------------------------------------------------------  -------------------------------  -------------------------------  -------------------------------------------------------------  --------------------------------------------------------------------------------------------------------------------  ----------------------------------------------------------------------------  -------------------------------  -----------------------  
Foo Workflow Monitor Agent                                                    Workflow Monitor Agent                                                        Background                       BISAOWorkMon                     Active                                                                                                                                                                                                                                                                                                                      Workflow Management                                                           Workflow                         0                        

1 row returned.

