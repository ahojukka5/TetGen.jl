using Cxx

const path_to_tetgen = "/home/olli/programming/forks/tetgen_src"
tetgen_header = "/home/olli/programming/forks/tetgen_src/tetgen.h"
icxx"""
#define TETLIBRARY
"""
addHeaderDir(path_to_tetgen, kind=C_System)
Libdl.dlopen(path_to_tetgen * "/tetgen.so", Libdl.RTLD_GLOBAL)

cxxinclude(tetgen_header)

b = @cxxnew tetgenbehavior()
in_ = @cxxnew tetgenio()
out = @cxxnew tetgenio()
addin = @cxxnew tetgenio()
bgmin = @cxxnew tetgenio()

icxx"""
char * switches = "example.poly";
tetgenbehavior b;
tetgenio in, addin, bgmin, out;
b.parse_commandline(0, 'p');
tetrahedralize("-p", &in, &out, &addin, &bgmin);
"""


