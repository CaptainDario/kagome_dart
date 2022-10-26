


if __name__ == "__main__":
    
    pos_table = []
    with open("pos_unidic.txt", mode="r", encoding="utf8") as f:
        for line in f.readlines():
            pos_table.append(line.replace("\n", "").split("\t"))

    with open("pos_unidic.dart", mode="w+", encoding="utf8") as f:
        # write the enum with all POS elements (english names)
        f.write("\n\n\n///Contains")
        f.write("\nenum PosUnidic {\n")
        for pos in pos_table:
            f.write(f"\t{pos[1].replace('.', '_')},\n")
        f.write("}\n\n")

        # write the map to convert kagome output to pos enum
        f.write("///Convert a kagome output string (japanese) to an pos enum instance\n")
        f.write("\nMap<String, PosUnidic> jpToPosUnidic = {\n")
        for pos in pos_table:
            f.write(f"\t'{pos[0]}' : PosUnidic.{pos[1].replace('.', '_')},\n")
        f.write("};\n\n")
        
        # write the map to convert japanese pos string to pos enum
        f.write("///Convert a kagome output string (english) to an pos enum instance\n")
        f.write("Map<String, PosUnidic> enToPosUnidic = {\n")
        for pos in pos_table:
            f.write(f"\t'{pos[1]}' : PosUnidic.{pos[1].replace('.', '_')},\n")
        f.write("};\n\n")

        # write the map to convert japanese <-> english pos
        f.write("///Convert english to japanese pos and vice versa\n")
        f.write("Map<String, String> jpEnConverter = {\n")
        for pos in pos_table:
            f.write(f"\t'{pos[0]}' : '{pos[1]}', '{pos[1]}' : '{pos[0]}',\n")
        f.write("};\n\n")

        # write the map to convert pos enum to en
        f.write("///Convert pos enum to en\n")
        f.write("Map<PosUnidic, String> posToEn = {\n")
        for pos in pos_table:
            f.write(f"\tPosUnidic.{pos[1].replace('.', '_')} : '{pos[1]}',\n")
        f.write("};\n\n")

        # write the map to convert pos enum to jp
        f.write("///Convert pos enum to jp\n")
        f.write("Map<PosUnidic, String> posToJp = {\n")
        for pos in pos_table:
            f.write(f"\tPosUnidic.{pos[1].replace('.', '_')} : '{pos[0]}',\n")
        f.write("};\n\n")

        # write the map to convert pos enum to description
        f.write("///Convert pos enum to jp\n")
        f.write("Map<PosUnidic, String> posToDesc = {\n")
        for pos in pos_table:
            f.write(f"\tPosUnidic.{pos[1].replace('.', '_')} : '{pos[2].replace('(', ' (')}',\n")
        f.write("};\n\n")