use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => "cpan2tgz",
	VERSION_FROM => "cpan2tgz",
	$] < 5.005 ? () : (
		AUTHOR => 'Jason Woodward <woodwardj@jaos.org>',
		ABSTRACT => "create Slackware packages from CPAN Perl module distributions",
	),
	EXE_FILES => [ "cpan2tgz" ],
	PREREQ_PM => { # e.g., Module::Name => 1.1
		'ExtUtils::MakeMaker' => 6.25,
		'Config' => 0,
		'CPAN' => 0,
		'Getopt::Long' => 0,
	},
);

