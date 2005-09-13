use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => "cpan2tgz",
	VERSION_FROM => "cpan2tgz",
	$] < 5.005 ? () : (
		AUTHOR => 'Jason Woodward <woodwardj@jaos.org>',
		ABSTRACT => "create Slackware packages from CPAN Perl module distributions",
	),
	EXE_FILES => [ "cpan2tgz" ],
	PREREQ_PM => {
		'ExtUtils::MakeMaker' => 6.17,
		'Config' => 0,
		'CPAN' => 0,
		'Getopt::Long' => 0,
	},
);

