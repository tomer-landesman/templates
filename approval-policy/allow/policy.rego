package env0
# METADATA
# title: always allow
# description: approved
allow[format(rego.metadata.rule())] {
	1 == 1
}

default hello := 15

format(meta) := meta.description