# This file is a part of JuliaFEM/TetGen.
# License is MIT: see https://github.com/JuliaFEM/TetGen.jl/blob/master/LICENSE.md

module TetGen
using Cxx

cxx"""#define TETLIBRARY"""
const header_dir = joinpath(Pkg.dir("TetGen"),"deps/usr/include/")
const tetgen_so = joinpath(Pkg.dir("TetGen"),"deps/usr/lib/libtet.so")
addHeaderDir(header_dir, kind=C_System)
Libdl.dlopen(tetgen_so, Libdl.RTLD_GLOBAL)
cxxinclude("tetgen.h")

in_ = @cxxnew tetgenio()
out_ = @cxxnew tetgenio()
addin_ = @cxxnew tetgenio()
bgmin_ = @cxxnew tetgenio()

end # module
