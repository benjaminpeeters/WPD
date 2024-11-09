structure <- capture.output(fs::dir_tree(all = TRUE))
writeLines(structure, "dev/structure.txt")
