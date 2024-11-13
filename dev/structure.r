structure <- capture.output(fs::dir_tree(all = FALSE))
writeLines(structure, "dev/structure.txt")
