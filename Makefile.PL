use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => "cpan2tgz",
	VERSION_FROM => "cpan2tgz",
	$] < 5.005 ? () : (
		AUTHOR => 'Jason Woodward <woodwardj@jaos.org>',
		ABSTRACT_FROM => "cpan2tgz",
	),
	EXE_FILES => [ "cpan2tgz" ],
	PREREQ_PM => { # e.g., Module::Name => 1.1
		'Config' => 0,
		'CPAN' => 0,
		'Getopt::Long' => 0,
	},
	dist => {
		COMPRESS => "gzip -9 -vf",
	},
);

