{application, 'hello_world', [
	{description, "New project"},
	{vsn, "0.1.0"},
	{modules, ['hello_world','hello_world_app','hello_world_sup']},
	{registered, [hello_world_sup]},
	{applications, [kernel,stdlib]},
	{mod, {hello_world_app, []}},
	{env, []}
]}.