using BinDeps

@BinDeps.setup

tetgen = library_dependency("libtet")

sources = provides(Sources,URI("http://tetgen.org/files/tetgen1.4.3.tar.gz"),tetgen,unpacked_dir="tetgen1.4.3")
builddir = joinpath(BinDeps.builddir(tetgen),tetgen.name)
bindir = joinpath(builddir,"bin")
steps = BinDeps.generate_steps(tetgen, Autotools(configure_options=["--enable-shared"]),Dict())
options = ["--enable-shared","--enable-debug"]

provides(BuildProcess,(@build_steps begin
         GetSources(tetgen)
         CreateDirectory(builddir)
#         ChangeDirectory(builddir)
#         # Not an actual configure
#         MakeTargets(["tetlib"])
#         #`chmod +x $(BinDeps.bindir(pythia))/pythia8-config`
         end),tetgen)

# #provides(BuildProcess,Autotools(libtarget = "src/.libs/libfastjet.la"),fastjet)

# @BinDeps.install Dict( :tetgen => :libtetgen)