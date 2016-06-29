#include <mono/jit/jit.h>
#include <mono/metadata/environment.h>
#include <mono/utils/mono-publib.h>
#include <mono/metadata/mono-config.h>
#include <stdlib.h>

/*
 * Very simple mono embedding example.
 * Compile with: 
 * 	gcc -o teste teste.c `pkg-config --cflags --libs mono-2` -lm
 * 	mcs test.cs
 * Run with:
 * 	./teste test.exe
 */

static MonoString*
gimme () {
	return mono_string_new (mono_domain_get (), "All your monos are belong to us!");
}

static void main_function (MonoDomain *domain, const char *file, int argc, char** argv)
{
	MonoAssembly *assembly;

	assembly = mono_domain_assembly_open (domain, file);
	if (!assembly)
		exit (2);
	/*
	 * mono_jit_exec() will run the Main() method in the assembly.
	 * The return value needs to be looked up from
	 * System.Environment.ExitCode.
	 */
	mono_jit_exec (domain, assembly, argc, argv);
}

static int memory_calls = 0;
static int malloc_count = 0;

static void* custom_malloc(size_t bytes)
{
	++memory_calls;
	++malloc_count;
	return malloc(bytes);
}

static
void* custom_realloc (void* mem, size_t bytes)
{
	++memory_calls;
	if (mem && !bytes)
		--malloc_count;
	else if (!mem && bytes)
		++malloc_count;
	return realloc (mem, bytes);
}

static
void* custom_calloc (size_t count, size_t bytes)
{
	++memory_calls;
	++malloc_count;
	return calloc (count, bytes);
}

static
void custom_free (void* mem)
{
	++memory_calls;
	--malloc_count;
	free (mem);
}

int 
main(int argc, char* argv[]) {
	MonoDomain *domain;
	const char *file;
	int retval;
	
	if (argc < 2){
		fprintf (stderr, "Please provide an assembly to load\n");
		return 1;
	}
	file = argv [1];

	MonoAllocatorVTable mem_vtable = {custom_malloc, custom_realloc, custom_free, custom_calloc};
	mono_set_allocator_vtable (&mem_vtable);

	/*
	 * Load the default Mono configuration file, this is needed
	 * if you are planning on using the dllmaps defined on the
	 * system configuration
	 */
	mono_config_parse (NULL);
	/*
	 * mono_jit_init() creates a domain: each assembly is
	 * loaded and run in a MonoDomain.
	 */
	domain = mono_jit_init (file);
	/*
	 * We add our special internal call, so that C# code
	 * can call us back.
	 */
	mono_add_internal_call ("MonoEmbed::gimme", gimme);

	main_function (domain, file, argc - 1, argv + 1);
	
	retval = mono_environment_exitcode_get ();
	
	mono_jit_cleanup (domain);
	fprintf (stdout, "custom malloc calls = %d(%d)\n", malloc_count, memory_calls);

	return retval;
}

