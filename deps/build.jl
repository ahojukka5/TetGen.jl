using BinDeps

@BinDeps.setup

libtet = library_dependency("libtet", aliases = ["libtet.so"])
sources = provides(Sources,URI("http://tetgen.org/files/tetgen1.4.3.tar.gz"),libtet,unpacked_dir="tetgen1.4.3")
builddir = joinpath(BinDeps.builddir(libtet),libtet.name)
srcdir = joinpath(BinDeps.srcdir(libtet),"tetgen1.4.3")

provides(SimpleBuild,
         (@build_steps begin
            GetSources(libtet)
            CreateDirectory(builddir)
            @build_steps begin
              ChangeDirectory(builddir)
              `g++ -fPIC -O0 -c $srcdir/predicates.cxx`
              `g++ -fPIC -DTETLIBRARY -c $srcdir/tetgen.cxx`
              `g++ -shared -fPIC tetgen.o predicates.o -o libtet.so`
            end
          end),
         libtet, os = :Unix)

@BinDeps.install Dict( :libtet => :libtet)
