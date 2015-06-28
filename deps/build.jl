# This file is a part of JuliaFEM/TetGen.
# License is MIT: see https://github.com/JuliaFEM/TetGen.jl/blob/master/LICENSE.md

using BinDeps

@BinDeps.setup
tetgen = "tetgen1.4.3"
libtet = library_dependency("libtet", aliases = ["libtet.so"])
sources = provides(Sources,URI("http://tetgen.org/files/$tetgen.tar.gz"),libtet,unpacked_dir=tetgen)
builddir = joinpath(BinDeps.builddir(libtet),libtet.name)
srcdir = joinpath(BinDeps.srcdir(libtet),tetgen)
libdir = joinpath(BinDeps.depsdir(libtet),"usr","lib")
includedir = joinpath(BinDeps.depsdir(libtet),"usr","include")

provides(SimpleBuild,
         (@build_steps begin
            GetSources(libtet)
            CreateDirectory(builddir)
            CreateDirectory(libdir)
            CreateDirectory(includedir)
            @build_steps begin
              ChangeDirectory(builddir)
              `g++ -fPIC -O0 -c $srcdir/predicates.cxx`
              `g++ -fPIC -DTETLIBRARY -c $srcdir/tetgen.cxx`
              `g++ -shared -fPIC tetgen.o predicates.o -o libtet.so`
              `cp libtet.so $libdir`
              `cp $srcdir/tetgen.h $includedir`
            end
          end),
         libtet, os = :Unix)

@BinDeps.install Dict( :libtet => :libtet)
