using Cxx

# Adding path to tetgen folder
const path_to_tetgen = "/home/olli/programming/forks/tetgen_src"

# Adding source files
tetgen_source = "/home/olli/programming/forks/tetgen_src/tetgen.cxx"
predicates_source = "/home/olli/programming/forks/tetgen_src/predicates.cxx"

# Adding header dir path
addHeaderDir(path_to_tetgen, kind=C_System)

# include source files
cxxinclude(predicates_source)
cxxinclude(tetgen_source)

# Creating tetgen objects
b_ = @cxxnew tetgenbehavior()
in_ = @cxxnew tetgenio()
out = @cxxnew tetgenio()
addin_ = @cxxnew tetgenio()
bgmin_ = @cxxnew tetgenio()

# including polynomial file
# It's necessary to procide 2 arguments for parse_commandline. "test" is only for that purpose
icxx"""
char *file_name[] = {"test", "example.poly"};
$b_->parse_commandline(2, file_name);
"""

# checking input
icxx"""
if ($b_->refine) {
    if (!$in_->load_tetmesh($b_->infilename)) {
      std::cout << "Something went wrong in refine section?"<< std::endl;
    }
} else {
if (!$in_->load_plc($b_->infilename, (int) $b_->object)) {
      std::cout << "Something went wrong in load plc?"<< std::endl;
    }
}
"""

# Adding points
icxx"""
  if ($b_->insertaddpoints) {
    if (!$addin_->load_node($b_->addinfilename)) {
      $addin_->numberofpoints = 0l;
    }
  }
  if ($b_->metric) {
    if (!$bgmin_->load_tetmesh($b_->bgmeshfilename)) {
      $bgmin_->numberoftetrahedra = 0l;
    }
  }

  if ($bgmin_->numberoftetrahedra > 0l) {
    tetrahedralize($b_, $in_, NULL, $addin_, $bgmin_);
  } else {
    tetrahedralize($b_, $in_, NULL, $addin_, NULL);
  }
"""








