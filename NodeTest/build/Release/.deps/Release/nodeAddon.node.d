cmd_Release/nodeAddon.node := c++ -bundle -undefined dynamic_lookup -Wl,-search_paths_first -mmacosx-version-min=10.5 -arch x86_64 -L./Release  -o Release/nodeAddon.node Release/obj.target/nodeAddon/nodeAddon.o Release/obj.target/nodeAddon/nativeCheck1.o Release/obj.target/nodeAddon/nativeCheck2.o Release/obj.target/nodeAddon/nativeCheck3.o 