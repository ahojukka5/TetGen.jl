# This file is a part of JuliaFEM/TetGen.
# License is MIT: see https://github.com/JuliaFEM/TetGen.jl/blob/master/LICENSE.md

using TetGen
using FactCheck
using Logging
@Logging.configure(level=DEBUG)

facts("Testing if somebody used print, println(), @sprint in src directory") do
  # TODO: make better reqular expression. Currently it will match all print words
  lines_with_print = Dict()
  src_dir = joinpath(Pkg.dir("TetGen"),"src")
  src = readdir(src_dir)
  for file_name in src
    fil = open(joinpath(src_dir,file_name),"r")
    for (line_number,line) in enumerate(readlines(fil))
      if ismatch(r"print",line)
        lines_with_print[file_name * ":$line_number"] = "print found in line: $line_number"
      end
    end
    close(fil)
  end
  @fact lines_with_print => isempty "Instead of println() use Logging.jl package"
end

facts("Testing if we have non ascii characters in the src files") do
  # TODO: we should allow Greeck letters in documentation. Thus this test should skip docstrings
  lines_with_non_ascii = []
  src_dir = joinpath(Pkg.dir("TetGen"),"src")
  src = readdir(src_dir)
  for file_name in src
    fil = open(joinpath(src_dir,file_name),"r")
    for (line_number,line) in enumerate(readlines(fil))
      if ismatch(r"[^\x00-\x7F]",line)
        push!(lines_with_non_ascii, file_name * ":line $line_number")
      end
    end
    close(fil)
  end
  @fact lines_with_non_ascii => isempty "non ascii charecters found in src -> test is failing"
end

facts("Looking the [src,test] folders *.jl files header information") do
  files_no_license = []
  pkg_dir = Pkg.dir("TetGen")
  dirs = ["test";"src";"dev"]
  for folder in dirs
    for file_name in readdir(joinpath(pkg_dir,folder))
      if file_name[end-2:end] == ".jl"
        fil = open(joinpath(pkg_dir,folder,file_name),"r")
        head = readall(fil)
      else
        continue
      end
      if ~ismatch(r"This file is a part of JuliaFEM/TetGen",head)
        push!(files_no_license,"$file_name is missing JuliaFEM/TetGen statement")
      end
      if ~ismatch(r"MIT",head)
        push!(files_no_license,"$file_name is missing MIT statement")
      end
      if ~ismatch(r"https://github.com/JuliaFEM/TetGen.jl/blob/master/LICENSE.md",head)
        push!(files_no_license,"$file_name is missing reference to LICENSE.md")
      end
      close(fil)
    end
  end
  out_str = """License information missing or incorrect. Please use these two lines in the beginning of each file:

# This file is a part of JuliaFEM/TetGen.
# License is MIT: see https://github.com/JuliaFEM/TetGen.jl/blob/master/LICENSE.md

  """
  @fact files_no_license => isempty out_str
end
